package hgsl.macro;

import haxe.macro.Context;

#if macro
class Environment {
	public var module:String;
	public var className:String;
	public var withinClass:ClassType;

	public final passedFuncs:Array<GFunc> = [];

	final scopes:Array<Array<GField>> = [[]];

	final tempVariables:Array<Placeholder> = [];
	final superFuncNameMap:Map<String, String> = [];

	// we have to mark this map persistent, since some of the shaders may be cached and not going to be built
	@:persistent
	static final envMap:Map<String, Environment> = [];

	static var idcount = 0;

	final ID = ++idcount;

	var localFunctionScopeDepth:Int = 0;

	public function new(module:String, className:String) {
		this.module = module;
		this.className = className;
	}

	static function generateKey(module:String, name:String):String {
		return module + "." + name;
	}

	public static function getRegistered(module:String, name:String):Environment {
		final key = generateKey(module, name);
		if (envMap.exists(key))
			return envMap[key].copyGlobal();
		return null;
	}

	public static function register(module:String, name:String, env:Environment):Void {
		final key = generateKey(module, name);
		envMap[key] = env;
	}

	public function copyGlobal():Environment {
		final res = new Environment(module, className);
		res.withinClass = withinClass;
		res.scopes[0] = scopes[0];
		for (origName => name in superFuncNameMap) {
			res.superFuncNameMap[origName] = name;
		}
		return res;
	}

	public function copyLocalSnapshot():Environment {
		final res = new Environment(module, className);
		res.withinClass = withinClass;
		res.scopes.resize(0);
		for (scope in scopes) {
			res.scopes.push(scope.copy());
		}
		for (origName => name in superFuncNameMap) {
			res.superFuncNameMap[origName] = name;
		}
		res.localFunctionScopeDepth = scopes.length;
		return res;
	}

	public function registerSuperFunctionNameAs(origName:String, name:String):Void {
		superFuncNameMap[origName] = name;
	}

	public function resolveSuperFunctionName(origName:String):Null<String> {
		return superFuncNameMap[origName];
	}

	public function tweakFunctionName(name:String):String {
		final existingNames = [for (_ => superName in superFuncNameMap) superName];
		return name.tweakIdentifier(name -> resolveField(name) == null && !existingNames.contains(name), true);
	}

	public function pushScope():Void {
		scopes.push([]);
	}

	public function popScope():Void {
		if (scopes.length == 1)
			throw "cannot pop global scope";
		scopes.pop();
	}

	public function popToGlobal():Void {
		scopes.resize(1);
	}

	public function resolveFieldTypes(parser:Parser):Void {
		for (field in scopes[0]) {
			switch field {
				case FVar(v) if (v.type != TVoid && v.field != null):
					final ptype = v.type;
					v.type = parser.resolveArraySize(this, v.type, v.field.pos);
					switch v.field.kind {
						case FVar(t, e):
							if (v.type.match(TStruct(_) | TArray(_) | TFunc(_))) {
								v.field.kind = FVar(v.type.toComplexType(), e);
							}
						case _:
							throw ierror(macro "internal error");
					}
				case FFunc(f):
					switch f.kind {
						case BuiltIn | BuiltInConstructor:
							throw ierror(macro "unexpected built-in function");
						case User(data):
							final ptype = f.type;
							final pargs = f.args.map(arg -> arg.type);
							f.type = parser.resolveArraySize(this, f.type, f.pos);
							for (arg in f.args) {
								arg.type = parser.resolveArraySize(this, arg.type, f.pos);
							}
							switch data.field.kind {
								case FFun(func):
									if (f.type.match(TStruct(_) | TArray(_) | TFunc(_))) {
										func.ret = f.type.toComplexType();
									}
									for (i => arg in func.args) {
										if (f.args[i].type.match(TStruct(_) | TArray(_) | TFunc(_))) {
											arg.type = f.args[i].type.toComplexType();
										}
									}
								case _:
									throw ierror(macro "internal error");
							}
					}
				case _:
			}
		}
	}

	function nextTempName():String {
		final map:Map<String, Bool> = [];
		for (scope in scopes) {
			for (field in scope) {
				switch field {
					case FVar(v):
						map[v.name] = true;
					case FFunc(f):
						map[f.name] = true;
				}
			}
		}
		for (tmp in tempVariables) {
			map[tmp.str] = true;
		}
		var i = 0;
		while (true) {
			final name = "tmp" + i++;
			if (!map.exists(name)) {
				return name;
			}
		}
	}

	public function createTempVar():Placeholder {
		final tmp = {str: nextTempName()};
		tempVariables.push(tmp);
		return tmp;
	}

	function checkNameConflict(name:String):Void {
		for (tmp in tempVariables) {
			if (tmp.str == name) {
				tmp.str = nextTempName();
			}
		}
	}

	function checkIdentifier(name:String, definedByUser:Bool, pos:Position):Void {
		if (Keyword.KEYWORDS.contains(name)) {
			throw error("cannot use " + name + " as an identifier", pos);
		}
		if (name.startsWith("gl_")) {
			throw error("identifier must not start with \"gl_\"", pos);
		}
		if (definedByUser && name.startsWith(RESERVED_PREFIX)) {
			throw error("identifier must not start with \"" + RESERVED_PREFIX + "\"", pos);
		}
		if (name.contains("__")) {
			throw error("identifier must not include \"__\"", pos);
		}
	}

	public function defineVar(name:String, type:GType, kind:GVarKind, field:Field, pos:Position):GVar {
		checkIdentifier(name, true, pos);
		if (resolveField(name, true) != null)
			throw error("redefinition of a variable in the same scope: " + name, pos);

		switch kind {
			case Attribute(_):
				if (!type.isOkayForAttribute())
					throw error("unsupported type for a vertex attribute: " + type.toString(), pos);
			case Color(_):
				if (!type.isOkayForColor())
					throw error("unsupported type for an output color: " + type.toString(), pos);
			case Varying(kind):
				if (!type.isOkayForVarying())
					throw error("unsupported type for a varying: " + type.toString(), pos);
				switch type.getElementType() {
					case TInt | TUInt if (kind != Flat):
						throw error("varying of " + type.toString() + " must be specified flat", pos);
					case _:
				}
			case Local(v):
				if (type.containsSampler())
					addError("cannot define a local variable of a type that contains a sampler", pos);
				if (type.match(TFunc(_))) {
					switch v.kind {
						case Const(_): // ok
						case _:
							addError("function type variable must be a compile-time constant", pos);
					}
				}
			case _:
		}

		switch kind {
			case Attribute(Specified(location)):
				for (f in scopes[0]) {
					switch f {
						case FVar(_.kind => Attribute(Specified(location2))):
							if (location == location2) throw error("multiple vertex attributes at the same location", pos);
						case _:
					}
				}
			case Color(Specified(location)):
				for (f in scopes[0]) {
					switch f {
						case FVar(_.kind => Color(Specified(location2))):
							if (location == location2) throw error("multiple output colors at the same location", pos);
						case _:
					}
				}
			case _:
		}
		final res = {
			name: name,
			type: type,
			kind: kind,
			field: field,
			pos: pos
		}
		defineField(FVar(res));
		return res;
	}

	public function defineFunc(name:String, definedByUser:Bool, type:GType, args:Array<GFuncArg>, region:GFuncRegion, expr:Expr, field:Field,
			pos:Position):GFunc {
		checkIdentifier(name, definedByUser, pos);
		if (scopes.length > 1)
			throw error("function can only be defined at a global scope", pos);
		if (!type.isOkayForReturn())
			throw error("cannot use " + type.toString() + " for a return type", pos);
		final res = {
			type: type,
			args: args,
			name: name,
			region: region,
			generic: type.isFunctionType(),
			kind: User({
				expr: expr,
				field: field,
				env: this
			}),
			pos: pos,
			parsed: !definedByUser // treat as parsed if automatically generated
		}
		defineField(FFunc(res));
		return res;
	}

	public function deleteGlobalFunc(func:GFunc):Void {
		final f = scopes[0].find(f -> switch f {
			case FFunc(f):
				f == func;
			case _:
				false;
		});
		if (f == null) {
			throw ierror(macro "could not delete the function; function not found");
		}
		scopes[0].remove(f);
	}

	public function getGlobalVars():Array<GVar> {
		final res = [];
		for (field in scopes[0]) {
			switch field {
				case FVar(v):
					res.push(v);
				case FFunc(_):
			}
		}
		return res;
	}

	public function getGlobalFuncs():Array<GFunc> {
		final res = [];
		for (field in scopes[0]) {
			switch field {
				case FVar(_):
				case FFunc(f):
					res.push(f);
			}
		}
		return res;
	}

	function defineField(f:GField):Void {
		scopes[scopes.length - 1].push(f);
		checkNameConflict(switch f {
			case FVar(_.name => name) | FFunc(_.name => name):
				name;
		});
	}

	public function accessVariable(target:GVar, requestUniqueGlobalName:(baseName:String) -> String, pos:Position):VariableAccessResult {
		final n = scopes.length;
		for (i in 0...n) {
			final scopeIndex = n - 1 - i;
			final scope = scopes[scopeIndex];
			for (f in scope) {
				final fname = switch f {
					case FVar(_.name => name) | FFunc(_.name => name):
						name;
				}
				if (fname == target.name) {
					switch f {
						case FVar(v):
							if (v != target)
								throw ierror(macro "different variable hit");
							if (v.type.isFunctionType())
								return RFunc;
							switch v.kind {
								case Uniform | Attribute(_) | Color(_) | Varying(_) | Global(_):
									return RGlobal;
								case Argument(argumentVar):
									if (scopeIndex < localFunctionScopeDepth && !argumentVar.turnedGlobal) {
										if (v.type.containsSampler())
											throw error("cannot capture a variable that contains samplers", pos);

										// captured local variable hit, make it global
										argumentVar.turnedGlobal = true;
										final globalName = requestUniqueGlobalName(v.name);
										argumentVar.namePlaceholder.str = globalName;

										// assign to the global variable
										final functionHead = argumentVar.functionHead;
										functionHead.breakLine();
										functionHead.add(globalName + " = " + v.name + ";");

										return RGlobalGenerated({
											name: globalName,
											type: v.type,
											kind: Global(Mutable),
											field: v.field,
											pos: v.pos
										});
									}
									return RLocal;
								case BuiltIn(_):
									throw ierror(macro "unexpected built-in variable");
								case GlobalConstUnparsed(_):
									throw ierror(macro "unexpected unparsed global const");
								case GlobalConstParsing:
									throw ierror(macro "unexpected parsing global const");
								case Local(localVar):
									if (scopeIndex < localFunctionScopeDepth && !localVar.turnedGlobal) {
										// captured local variable hit, make it global
										localVar.turnedGlobal = true;
										final globalName = requestUniqueGlobalName(v.name);
										localVar.namePlaceholder.str = globalName;

										// remove local definition
										localVar.typeBeforeNameAndSpacePlaceholder.str = "";
										localVar.typeAfterNamePlaceholder.str = "";

										return RGlobalGenerated({
											name: globalName,
											type: v.type,
											kind: Global(Mutable),
											field: v.field,
											pos: v.pos
										});
									}
									return RLocal;
							}
						case FFunc(_):
							throw ierror(macro "variable expected");
					}
				}
			}
		}
		throw ierror(macro "variable did not hit");
	}

	public function resolveField(name:String, sameScope:Bool = false):Null<GField> {
		final n = scopes.length;
		for (i in 0...n) {
			final scope = scopes[n - 1 - i];
			for (f in scope) {
				final fname = switch f {
					case FVar(_.name => name) | FFunc(_.name => name):
						name;
				}
				if (fname == name)
					return f;
			}
			if (sameScope)
				break;
		}
		return null;
	}

	public function resolveFields(name:String, sameScope:Bool = false):Array<GField> {
		final res = [];
		final n = scopes.length;
		for (i in 0...n) {
			final scope = scopes[n - 1 - i];
			for (f in scope) {
				final fname = switch f {
					case FVar(_.name => name) | FFunc(_.name => name):
						name;
				}
				if (fname == name)
					res.push(f);
			}
			if (sameScope)
				break;
		}
		return res;
	}

	public function getGlobalFuncsOfName(name:String):Array<GFunc> {
		return getGlobalFuncs().filter(f -> f.name == name);
	}

	public function getGlobalFuncOfNameAndArgs(name:String, args:Array<GFuncArg>):Null<GFunc> {
		return switch getGlobalFuncs().filter(f -> f.name == name
			&& f.args.length == args.length
			&& f.args.zip(args, (a1, a2) -> a1.type.equals(a2.type)).all()) {
			case [f]:
				f;
			case []:
				null;
			case _:
				final msg = "multiple functions with the same name and arguments found: " + name;
				throw ierror(macro $v{msg});
		};
	}

	public function getAccessibleGlobalFuncsOfName(name:String):Array<GFunc> {
		return resolveFields(name).filter(field -> field.match(FFunc(_))).map(f -> switch f {
			case FFunc(f):
				f;
			case _:
				throw ierror(macro "internal error");
		});
	}
}
#end

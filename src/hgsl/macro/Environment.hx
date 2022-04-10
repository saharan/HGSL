package hgsl.macro;

import haxe.macro.Context;

#if macro
class Environment {
	public var module:String;
	public var className:String;
	public var target:GFunc;
	public var withinClass:ClassType;

	final scopes:Array<Array<GField>> = [[]];

	final tempVariables:Array<TempVariable> = [];
	final superFuncNameMap:Map<String, String> = [];

	// we have to mark this map persistent, since some of the shaders may be cached and not going to be built
	@:persistent
	static final envMap:Map<String, Environment> = [];

	static var idcount = 0;

	final ID = ++idcount;

	public function new(module:String, className:String) {
		this.module = module;
		this.className = className;
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

	public static function ofClassType(classType:ClassType):Environment {
		final module = classType.module;
		final name = classType.name;
		final reg = getRegistered(module, name);
		if (reg != null)
			return reg;
		final res = new Environment(module, name);
		res.withinClass = classType;
		for (field in classType.statics.get().filter(field -> !field.meta.has(":deprecated")).toGFields(true)) {
			res.defineField(field);
		}
		register(module, name, res);
		return res;
	}

	public function registerSuperFunctionNameAs(origName:String, name:String):Void {
		superFuncNameMap[origName] = name;
	}

	public function resolveSuperFunctionName(origName:String):Null<String> {
		return superFuncNameMap[origName];
	}

	public function tweakFunctionName(name:String):String {
		while (resolveField(name) != null || [for (_ => superName in superFuncNameMap) superName].contains(name))
			name = "_" + name;
		return name;
	}

	public function setTargetFunc(func:GFunc):Void {
		target = func;
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
							if (v.type.match(TStruct(_) | TArray(_))) {
								v.field.kind = FVar(v.type.toComplexType(), e);
							}
						case _:
							throw ierror(macro "internal error");
					}
				case FFunc(f) if (f.field != null):
					final ptype = f.type;
					final pargs = f.args.map(arg -> arg.type);
					f.type = parser.resolveArraySize(this, f.type, f.field.pos);
					for (arg in f.args) {
						arg.type = parser.resolveArraySize(this, arg.type, f.field.pos);
					}
					switch f.field.kind {
						case FFun(func):
							if (f.type.match(TStruct(_) | TArray(_))) {
								func.ret = f.type.toComplexType();
							}
							for (i => arg in func.args) {
								if (f.args[i].type.match(TStruct(_) | TArray(_))) {
									arg.type = f.args[i].type.toComplexType();
								}
							}
						case _:
							throw ierror(macro "internal error");
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
			map[tmp.name] = true;
		}
		var i = 0;
		while (true) {
			final name = "tmp" + i++;
			if (!map.exists(name)) {
				return name;
			}
		}
	}

	public function createTempVar():TempVariable {
		final tmp = new TempVariable(nextTempName());
		tempVariables.push(tmp);
		return tmp;
	}

	function checkNameConflict(name:String):Void {
		for (tmp in tempVariables) {
			if (tmp.name == name) {
				tmp.name = nextTempName();
			}
		}
	}

	function checkIdentifier(name:String, pos:Position):Void {
		if (Keyword.KEYWORDS.contains(name)) {
			throw error("cannot use " + name + " as an identifier", pos);
		}
		if (name.startsWith("gl_")) {
			throw error("identifier must not start with gl_", pos);
		}
	}

	public function defineVar(name:String, type:GType, kind:GVarKind, field:Field, pos:Position):GVar {
		checkIdentifier(name, pos);
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
			case Local(_):
				if (type.containsSampler())
					addError("cannot define a local variable of a type that contains a sampler", pos);
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

	public function defineFunc(name:String, type:GType, args:Array<GFuncArg>, region:GFuncRegion, expr:Expr, field:Field,
			pos:Position):GFunc {
		checkIdentifier(name, pos);
		if (scopes.length > 1)
			throw error("function can only be defined at a global scope", pos);
		final res = {
			type: type,
			args: args,
			name: name,
			region: region,
			ctor: false,
			expr: expr,
			field: field,
			pos: pos
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
		return switch getGlobalFuncs().filter(f -> f.name == name && f.args.length == args.length && f.args.zip(args, (a1,
				a2) -> a1.type.equals(a2.type))
			.all()) {
			case [f]:
				f;
			case []:
				null;
			case _:
				final msg = "multiple functions with the same name and arguments found: " + name;
				throw ierror(macro $v{msg});
		};
	}

	// TODO: give a more appropriate name for this
	public function getLocalFuncsOfName(name:String):Array<GFunc> {
		return resolveFields(name).filter(field -> field.match(FFunc(_))).map(f -> switch f {
			case FFunc(f):
				f;
			case _:
				throw ierror(macro "internal error");
		});
	}
}
#end

package hgsl.macro;

import hgsl.macro.constant.MatBase;
import haxe.macro.Context;

#if macro
class Parser {
	final mainModule:String;
	final mainName:String;

	final structPool:StructPool;
	final funcNameMap:Map<String, GeneratedFunctionEntry> = [];
	final funcs:Array<ParsedFunction> = [];
	final additionalGlobalVars:Array<GVar> = [];

	var currentlyParsingFunction:{
		func:ParsedFunction,
		ret:Null<GType>,
		retPlaceholder:Placeholder,
		cvalue:ConstValue,
		functionHead:Source
	} = null;

	static var initialized:Bool = false;
	static final globalClassType:Lazy<ClassType> = getGlobalClassType;
	static final builtInVars:Array<GVar> = [];
	static final builtInFuncs:Array<GFunc> = [];

	final kind:GShaderKind;

	var anonFuncCount:Int = 0;
	var genericFuncCount:Int = 0;
	var mainEnvironment:Environment = null; // environment that includes the entrypoint

	var dryMode:Bool = false; // type check only, no global field generation

	public function new(mainModule:String, mainName:String, structPool:StructPool, kind:GShaderKind) {
		this.mainModule = mainModule;
		this.mainName = mainName;
		this.kind = kind;
		this.structPool = structPool;
		if (!initialized) {
			initialized = true;
			collectBuiltInFields();
		}
		for (f in builtInFuncs) {
			funcNameMap[f.name] = {
				names: [f.name],
				cvalue: null
			}
		}
	}

	static function getGlobalClassType():ClassType {
		final global = Context.getType(GLOBAL_MODULE_PATH);
		return switch global {
			case TInst(_.get() => t, _):
				t;
			case _:
				throw ierror(macro "internal error");
		}
	}

	function collectBuiltInFields():Void {
		for (field in globalClassType.data.statics.get().toBuiltInFields()) {
			switch field {
				case FVar(v):
					builtInVars.push(v);
				case FFunc(f):
					builtInFuncs.push(f);
			}
		}
	}

	public function getUniqueStructName(fields:GStructFields):String {
		return structPool.getStructName(fields, this);
	}

	static function generateDummyFunc(f:GFuncType):GFunc {
		return {
			type: f.ret,
			args: f.args.map(arg -> {
				name: arg.name,
				type: arg.type,
				isRef: false
			}),
			name: "dummy",
			region: All,
			generic: false,
			kind: User({
				expr: null,
				field: null,
				env: null
			}),
			pos: null,
			parsed: false
		}
	}

	static function generateDummyFuncArgs(func:GFunc):Array<GFunc> {
		return func.args.filter(arg -> arg.type.isFunctionType()).map(arg -> switch arg.type {
			case TFunc(f):
				generateDummyFunc(f);
			case TFuncs(_):
				throw ierror(macro "unexpected functions type");
			case _:
				throw ierror(macro "expected function type");
		});
	}

	public function parseEntryPoint(env:Environment, func:GFunc):Void {
		mainEnvironment = env;
		structPool.resetUsage();
		env.popToGlobal();
		final dummyFuncArgs = switch kind {
			case Vertex | Fragment:
				[];
			case Module | VertexOrFragment:
				generateDummyFuncArgs(func);
		}
		parseFuncImpl(new FunctionToParse(func, dummyFuncArgs), func.pos, env);
	}

	function generateFunctionAlias(originalName:String, name:String, args:Array<NamedType>, ret:GType):ParsedFunction {
		final alias = new ParsedFunction(name);
		final source = alias.source;
		generateFunctionHeader(name, source, args, ret);
		source.add("{");
		source.increaseIndent();
		source.breakLine();
		if (ret != TVoid)
			source.add("return ");
		source.add(originalName + "(" + args.map(arg -> arg.name).join(", ") + ");");
		source.decreaseIndent();
		source.breakLine();
		source.add("}");
		return alias;
	}

	static function isFunctionAccessible(generatedName:String, env:Environment):Bool {
		final hidden = env.resolveFields(generatedName).exists(field -> switch field {
			case FVar(v):
				!v.type.isFunctionType();
			case FFunc(_):
				false;
		});
		return !hidden;
	}

	function getGeneratedGlobalIdentifiers():Array<String> {
		final globalVarNames = (mainEnvironment == null ? [] : mainEnvironment.getGlobalVars()).concat(additionalGlobalVars)
			.map(v -> v.name);
		final globalFuncNames = [for (_ => entry in funcNameMap) entry.names].flatten();
		return globalVarNames.concat(globalFuncNames);
	}

	public function getUniqueGlobalVarName(base:String):String {
		final existingNames = getGeneratedGlobalIdentifiers();
		// we need to tweak at least once because there is a possibility
		// that the variable is hidden by another local variable
		return base.tweakIdentifier(name -> !existingNames.contains(name), true);
	}

	function chooseFunctionName(name:String, fromEnv:Null<Environment>):String {
		final existingNames = getGeneratedGlobalIdentifiers();
		return name.tweakIdentifier(name -> !existingNames.contains(name) && (fromEnv == null || isFunctionAccessible(name, fromEnv)),
			false);
	}

	function generateFunctionHeader(name:String, source:Source, args:Array<NamedType>, ret:Null<GType>):Placeholder {
		final retPlaceholder = source.addPlaceholder(ret == null ? "void" : ret.isFunctionType() ? "int" : ret.toGLSLType(this).join(""));
		source.add(" ");
		source.add(name);
		source.add("(");
		for (i => arg in args) {
			if (i > 0) {
				source.add(", ");
			}
			final glslType = arg.type.toGLSLType(this);
			source.add(glslType[0]);
			source.add(" ");
			source.add(arg.name);
			source.add(glslType[1]);
		}
		source.add(") ");
		return retPlaceholder;
	}

	function parseFuncImpl(func:FunctionToParse, pos:Position, fromEnv:Environment):FunctionParseResult {
		if (dryMode)
			throw ierror(macro "called in dry mode");
		final target = func.target;
		var key = if (target.generic) {
			"generic(" + genericFuncCount++ + ")"; // always give a unique key
		} else {
			func.generateKey();
		}
		final origName = target.name;
		// first parse
		if (!funcNameMap.exists(key)) {
			final parseResult = parseOriginalFunc(func, pos);
			key = target.generic ? key : func.generateKey(); // check if the func is still generic
			funcNameMap[key] = {
				names: [parseResult.generatedName],
				cvalue: parseResult.cvalue
			}
		}
		final name = getAccessibleGeneratedFuncName(key, origName, func.normalArgs, func.target.type, fromEnv);
		return {
			generatedName: name,
			cvalue: funcNameMap[key].cvalue
		}
	}

	function getAccessibleGeneratedFuncName(key:String, origName:String, args:Array<NamedType>, ret:GType, fromEnv:Environment):String {
		if (dryMode)
			throw ierror(macro "called in dry mode");
		// check for available names
		for (name in funcNameMap[key].names) {
			if (isFunctionAccessible(name, fromEnv))
				return name;
		}
		// no accessible name found, make an alias of it
		final name = chooseFunctionName(origName, fromEnv);
		final alias = generateFunctionAlias(origName, name, args, ret);
		funcs.push(alias);
		funcNameMap[key].names.push(alias.name);
		if (!isFunctionAccessible(name, fromEnv))
			throw ierror(macro "generated function alias is not accessible");
		return alias.name;
	}

	function parseOriginalFunc(func:FunctionToParse, pos:Position):FunctionParseResult {
		final data = func.userFuncData;
		final target = func.target;
		final env = data.env;
		final generatedName = switch target.name {
			case "vertex" | "fragment":
				"main";
			case name:
				chooseFunctionName(name, null);
		}
		final parsed = new ParsedFunction(generatedName);
		final source = parsed.source;
		final functionHead = new Source();
		var dummyArgCount = 0;
		final retPlaceholder = generateFunctionHeader(generatedName, source, func.target.args.map(arg -> {
			if (arg.type.isFunctionType()) {
				{
					name: RESERVED_PREFIX + "dummyArg_" + dummyArgCount++,
					type: TInt // receive int for possible side effects
				}
			} else {
				{
					name: arg.name,
					type: arg.type
				}
			}
		}), func.target.type);
		env.pushScope();
		// define normal args
		for (arg in func.normalArgs) {
			env.defineVar(arg.name, arg.type, Argument({
				kind: In,
				turnedGlobal: false,
				namePlaceholder: {str: arg.name},
				functionHead: functionHead
			}), null, pos);
		}
		// define passed function arguments
		for (arg in func.funcArgs) {
			env.defineVar(arg.name, TFunc(arg.type), Local({
				kind: Const(VFunc([arg.func], null)),
				turnedGlobal: false,
				typeBeforeNameAndSpacePlaceholder: {str: ""},
				namePlaceholder: {str: ""},
				typeAfterNamePlaceholder: {str: ""}
			}), null, pos);
		}
		final noBlockAtRoot = !data.expr.expr.match(EBlock(_));
		if (noBlockAtRoot) {
			source.add("{");
			source.increaseIndent();
			source.append(functionHead, false);
			source.breakLine();
		}

		// push function data
		final tmp = currentlyParsingFunction;
		currentlyParsingFunction = {
			func: parsed,
			ret: target.type,
			retPlaceholder: retPlaceholder,
			cvalue: null,
			functionHead: functionHead
		}

		parseExpr(data.expr, source, env, true, null, true);
		target.parsed = true; // mark as parsed

		final cvalue = currentlyParsingFunction.cvalue;
		final ret = currentlyParsingFunction.ret;
		if (ret == null) { // no return found
			target.type = TVoid;
		} else { // (expected) return found
			target.type = ret;
			currentlyParsingFunction.retPlaceholder.str = ret.isFunctionType() ? "int" : ret.toGLSLType(this).join("");
		}
		target.generic = target.type.isFunctionType();

		// pop function data
		currentlyParsingFunction = tmp;

		if (noBlockAtRoot) {
			source.decreaseIndent();
			source.breakLine();
			source.add("}");
		}

		// add to the function list AFTER the parsing is completed
		if (!dryMode)
			funcs.push(parsed);

		env.popScope();
		// trace(parsed.source.toString());
		return {
			generatedName: generatedName,
			cvalue: cvalue
		};
	}

	public function generateSource(env:Environment):String {
		final globalVars = env.getGlobalVars().concat(additionalGlobalVars);
		for (gvar in globalVars) {
			gvar.type.toGLSLType(this); // to register structures
		}
		final structs = structPool.getUsedStructs();
		final structSources = [];
		final sources = [];
		switch kind {
			case Vertex:
				sources.push("#version 300 es");
				for (type in [
					"sampler2D",
					"sampler3D",
					"samplerCube",
					"samplerCubeShadow",
					"sampler2DShadow",
					"sampler2DArray",
					"sampler2DArrayShadow",
					"isampler2D",
					"isampler3D",
					"isamplerCube",
					"isampler2DArray",
					"usampler2D",
					"usampler3D",
					"usamplerCube",
					"usampler2DArray"
				]) {
					sources.push("precision highp " + type + ";");
				}
				sources.push("");
			case Fragment:
				sources.push("#version 300 es");
				for (type in [
					"int",
					"float",
					"sampler2D",
					"sampler3D",
					"samplerCube",
					"samplerCubeShadow",
					"sampler2DShadow",
					"sampler2DArray",
					"sampler2DArrayShadow",
					"isampler2D",
					"isampler3D",
					"isamplerCube",
					"isampler2DArray",
					"usampler2D",
					"usampler3D",
					"usamplerCube",
					"usampler2DArray"
				]) {
					sources.push("precision highp " + type + ";");
				}
				sources.push("");
			case Module | VertexOrFragment:
				throw "cannot generate module source";
		}

		for (struct in structs) {
			sources.push(struct.source);
		}
		if (structs.length > 0)
			sources.push("");
		final plen = sources.length;
		for (gvar in globalVars) {
			switch gvar.kind {
				case Uniform:
					sources.push("uniform " + gvar.type.toGLSLTypeOfName(gvar.name, this) + ";");
				case Attribute(location):
					if (kind == Vertex)
						sources.push((switch location {
							case Unspecified:
								"in ";
							case Specified(location):
								"layout(location = " + location + ") in ";
						}) + gvar.type.toGLSLTypeOfName(gvar.name, this) + ";");
				case Color(location):
					if (kind == Fragment)
						sources.push((switch location {
							case Unspecified:
								"out ";
							case Specified(location):
								"layout(location = " + location + ") out ";
						}) + gvar.type.toGLSLTypeOfName(gvar.name, this) + ";");
				case Varying(vkind):
					final attrib = switch vkind {
						case Centroid:
							"centroid ";
						case Smooth:
							"";
						case Flat:
							"flat ";
					}
					switch kind {
						case Vertex:
							sources.push(attrib + "out " + gvar.type.toGLSLTypeOfName(gvar.name, this) + ";");
						case Fragment:
							sources.push(attrib + "in " + gvar.type.toGLSLTypeOfName(gvar.name, this) + ";");
						case Module | VertexOrFragment:
							throw ierror(macro "internal error");
					}
				case BuiltIn(_):
					throw ierror(macro "internal error");
				case Global(kind):
					switch kind {
						case Mutable:
							sources.push(gvar.type.toGLSLTypeOfName(gvar.name, this) + ";");
						case Const(_): // just ignore; should never appear due to folding
					}
				case GlobalConstUnparsed(_): // unused, ignore
				case GlobalConstParsing:
					throw ierror(macro "unexpected parsing global const");
				case Local(_):
					throw ierror(macro "local variable must not appear here");
				case Argument(_):
					throw ierror(macro "argument must not appear here");
			}
		}
		if (sources.length != plen)
			sources.push("");
		for (i => func in funcs) {
			if (i > 0)
				sources.push("");
			sources.push(func.source.toString());
		}
		final res = sources.join("\n");
		// trace(res);
		return res;
	}

	function splitByOr(e:Expr):Array<Expr> {
		switch e.expr {
			case EBinop(OpOr, e1, e2):
				return [e1, e2].flatMap(splitByOr);
			case _:
				return [e];
		}
	}

	public function resolveArraySize(env:Environment, type:GType, pos:Position):GType {
		return switch type {
			case TStruct(fields):
				TStruct(fields.map(f -> {name: f.name, type: resolveArraySize(env, f.type, pos), pos: f.pos}));
			case TArray(type, Delayed(path)):
				final source = new Source();
				final t = parseExpr(path, source, env, false, TInt);
				if (t.cvalue != null) {
					switch t.cvalue {
						case VScalar(VInt(count)):
							if (count.checkArraySize(pos)) {
								TArray(type, Resolved(count));
							} else {
								TVoid;
							}
						case _:
							throw ierror(macro "internal error");
					};
				} else {
					addError("array size must be a compile-time const value", pos);
					TVoid;
				}
			case _:
				type;
		}
	}

	function constructType(type:GType, args:Array<GInternalType>, pos:Position):GInternalType {
		if (args.length == 0)
			throw error("arguments required", pos);
		final kind = switch type {
			case TFloat | TInt | TUInt | TBool:
				Scalar;
			case TVec2 | TIVec2 | TUVec2 | TBVec2:
				Vec(2);
			case TVec3 | TIVec3 | TUVec3 | TBVec3:
				Vec(3);
			case TVec4 | TIVec4 | TUVec4 | TBVec4:
				Vec(4);
			case TMat2x2:
				Mat(2, 2);
			case TMat3x3:
				Mat(3, 3);
			case TMat4x4:
				Mat(4, 4);
			case TMat2x3:
				Mat(2, 3);
			case TMat2x4:
				Mat(2, 4);
			case TMat3x2:
				Mat(3, 2);
			case TMat3x4:
				Mat(3, 4);
			case TMat4x2:
				Mat(4, 2);
			case TMat4x3:
				Mat(4, 3);
			case _:
				throw ierror(macro "invalid type of constructor");
		}
		final size = type.numComponents();
		final etype = type.getElementType();
		if (etype == null)
			throw ierror(macro "invalid type of constructor");
		var vecComponentCount = 0;
		var matCount = 0;
		final cvalues = [];
		for (arg in args) {
			cvalues.push(arg.cvalue);
			if (arg.type.isMatrix()) {
				matCount++;
			} else {
				final n = arg.type.numComponents();
				if (n == 0)
					throw error("invalid constructor argument", pos);
				vecComponentCount += n;
			}
		}
		if (vecComponentCount > 0 && matCount > 0)
			throw error("cannot mix vector and matrix arguments", pos);
		if (matCount > 1)
			throw error("multple matrix arguments are not allowed", pos);

		final componentSizesMismatchError = "component sizes mismatch, want: " + size + ", have: " + vecComponentCount;
		final mode:ConstructorMode = switch kind {
			case Scalar:
				switch args.length {
					case 1:
						Scalar;
					case _:
						throw error("too many arguments", pos);
				}
			case Vec(_):
				switch matCount {
					case 0:
						switch vecComponentCount {
							case 1:
								VecFromScalar;
							case _ == size => true:
								VecFromVecs;
							case _ < size => true:
								throw error(componentSizesMismatchError, pos);
							case _:
								if (args.length == 1) {
									VecFromVecTruncate;
								} else {
									throw error(componentSizesMismatchError, pos);
								}
						}
					case 1:
						VecFromMat;
					case _:
						throw ierror(macro "internal error");
				}
			case Mat(cols, rows):
				switch matCount {
					case 0:
						switch vecComponentCount {
							case 1:
								MatFromScalar(cols, rows);
							case _ == size => true:
								MatFromVecs(cols, rows);
							case _:
								throw error(componentSizesMismatchError, pos);
						}
					case 1:
						MatFromMat(cols, rows);
					case _:
						throw ierror(macro "internal error");
				}
		}

		final cvalue:ConstValue = if (cvalues.contains(null)) {
			null;
		} else {
			switch mode {
				case Scalar:
					switch cvalues[0] {
						case VScalar(v):
							VScalar(v.castTo(etype));
						case VVector(v):
							VScalar(v.extractFirst().castTo(etype));
						case VMatrix(v):
							VScalar(v.extractFirst().castTo(etype));
						case _:
							throw ierror(macro "internal error");
					}
				case VecFromScalar:
					switch cvalues[0] {
						case VScalar(v):
							VVector(v.castTo(etype).toVector(size));
						case _:
							throw ierror(macro "internal error");
					}
				case VecFromMat:
					switch cvalues[0] {
						case VMatrix(v):
							VVector(v.toVector().truncate(size).castTo(etype));
						case _:
							throw ierror(macro "internal error");
					}
				case VecFromVecTruncate:
					switch cvalues[0] {
						case VVector(v):
							VVector(v.truncate(size).castTo(etype));
						case _:
							throw ierror(macro "internal error");
					}
				case VecFromVecs:
					VVector(cvalues.flatMap(cvalue -> switch cvalue {
						case VScalar(v):
							[v];
						case VVector(v):
							v.toScalars();
						case _:
							throw ierror(macro "internal error");
					}).toVectorOf(etype));
				case MatFromScalar(cols, rows):
					switch cvalues[0] {
						case VScalar(v):
							switch v.castTo(TFloat) {
								case VFloat(v):
									VMatrix(VMat(MatBase.fromScalar(v, cols, rows)));
								case _:
									throw ierror(macro "internal error");
							}
						case _:
							throw ierror(macro "internal error");
					};
				case MatFromVecs(cols, rows):
					VMatrix(cvalues.flatMap(cvalue -> switch cvalue {
						case VScalar(v):
							[v];
						case VVector(v):
							v.toScalars();
						case _:
							throw ierror(macro "internal error");
					}).toMatrixOf(cols, rows));
				case MatFromMat(cols, rows):
					switch cvalues[0] {
						case VMatrix(VMat(v)):
							VMatrix(VMat(v.resize(cols, rows)));
						case _:
							throw ierror(macro "internal error");
					}
			}
		}
		return {
			type: type,
			lvalue: false,
			cvalue: cvalue
		};
	}

	static function addTypesMismatchError(want:GType, have:GType, pos:Position, additional:String = ""):Void {
		addError("types mismatch,\nwant: " + want.toString() + "\nhave: " + have.toString() + additional, pos);
	}

	static function parseFieldChain(e:Expr):Null<FieldChain> {
		return switch e.expr {
			case EConst(CIdent(s)):
				return [s];
			case EField(e, field):
				final head = parseFieldChain(e);
				if (head == null) {
					null;
				} else {
					head.concat([field]);
				}
			case _:
				null;
		}
	}

	function addFoldingConstant(srcFrom:Source, srcTo:Source, statement:Bool, cvalue:Null<ConstValue>):Void {
		if (cvalue != null && !cvalue.match(VFunc(_))) {
			srcTo.add(cvalue.toSource(this));
			if (statement)
				srcTo.add(";");
		} else {
			srcTo.append(srcFrom, true);
		}
	}

	function resolveExternalClassFieldAccess(fieldChain:FieldChain, pos:Position):{
		localChain:FieldChain,
		fullChain:FieldChain,
		classType:ClassType,
		env:Environment
	} {
		final classFieldAccess = fieldChain.splitClassFieldAccess(pos);
		final type = classFieldAccess.type;
		final typeString = type.toComplexType().toString();
		var fields = null;
		final classType = switch type {
			case TInst(_.get() => t, _):
				t;
			case _:
				null;
		}
		final env = classType == null ? null : Environment.getRegistered(classType.module, classType.name);
		if (env == null) {
			// since the type is loaded, the environment should have been registered at this point
			throw error("cannot access type " + typeString + " by " + fieldChain.join(".") + " " + classFieldAccess.fieldAccess, pos);
		}
		final localChain = classFieldAccess.fieldAccess;
		if (localChain.length == 0)
			throw error("unexpected type " + typeString, pos);

		// make sure the first field exists, otherwise another external field access becomes
		// possible, since we recursively resolve the field access
		if (env.resolveField(localChain[0]) == null)
			throw error(typeString + " has no field " + localChain[0], pos);

		// make a full path chain to replace the original expr,
		// since it can be resolved in a different context later
		final fullChain = typeString.split(".").concat(localChain);
		return {
			localChain: localChain,
			fullChain: fullChain,
			classType: classType,
			env: env
		}
	}

	public function parseExpr(e:Expr, src:Source, env:Environment, statement:Bool, expectedType:GType = null,
			isFuncRoot:Bool = false):GInternalType {
		final source = new Source();
		final res = parseExprWithoutConstantFolding(e, source, env, statement, expectedType, isFuncRoot);
		addFoldingConstant(source, src, statement, res.cvalue);
		return res;
	}

	function addWithImplicitCast(addToSource:Source, source:Source, sourceType:GInternalType, expectedType:GType):GInternalType {
		final tmpSource = new Source();
		var cvalue = sourceType.cvalue;
		if (sourceType.type.equals(expectedType)) {
			tmpSource.append(source, true);
		} else {
			if (sourceType.type.canImplicitlyCast(expectedType)) {
				tmpSource.add(expectedType.toGLSLType(this).join(""));
				tmpSource.add("(");
				tmpSource.append(source, true);
				tmpSource.add(")");
				cvalue = cvalue == null || expectedType == TVoid ? null : cvalue.castTo(expectedType.getElementType());
			} else {
				final msg = "cannot cast " + sourceType.type.toString() + " to " + expectedType.toString();
				throw ierror(macro $v{msg});
			}
		}
		addFoldingConstant(tmpSource, addToSource, false, cvalue);
		return {
			type: expectedType,
			lvalue: false,
			cvalue: cvalue
		}
	}

	static function extractFunction(expected:GFuncType, funcs:Array<GFunc>, pos:Position):GFunc {
		var candidate = funcs.filter(f -> f.toFuncType().funcTypeEquals(expected));
		if (candidate.length == 0) {
			candidate = funcs.filter(f -> f.canImplicitlyCast(expected));
		}
		switch candidate {
			case [f]:
				return f;
			case []:
				throw error("no suitable overload found; expected: " + TFunc(expected).toString() + "\nhave: " + (funcs.map(f -> f.toType()
					.toString())
					.join("\n  ")), pos);
			case fs:
				throw error("ambiguous overload found; expected: " + TFunc(expected).toString() + "\ncandidates: " + (funcs.map(f ->
					f.toType()
					.toString())
					.join("\n  ")), pos);
		}
	}

	function parseExprWithoutConstantFolding(e:Expr, src:Source, env:Environment, statement:Bool, expectedType:GType = null,
			isFuncRoot:Bool = false):GInternalType {
		final origExpr = e;
		final pos = e.pos;
		switch [expectedType, e.expr] {
			case [null, _]: // do nothing
			case [TArray(_), EArrayDecl(_)] | [TStruct(_), EObjectDecl(_)] | [TFunc(_), EFunction(_)]: // process later
			case _:
				final source = new Source();
				final internalType = parseExpr(e, source, env, statement);
				final type = internalType.type;

				if (type.isFunctionType()) {
					switch internalType.cvalue {
						case null:
							throw ierror(macro "function type variable must be a compile-time constant");
						case VFunc(funcs, sideEffectSource):
							switch expectedType {
								case TFunc(expectedFunc): // extract a specific function
									return {
										type: expectedType,
										lvalue: false,
										cvalue: VFunc([extractFunction(expectedFunc, funcs, pos)], sideEffectSource)
									}
								case TFuncs(_): // not identified; any functions are fine
									return {
										type: internalType.type,
										lvalue: false,
										cvalue: VFunc(funcs, sideEffectSource)
									}
								case _:
									final msg = "unexpected expected type: " + expectedType.toString();
									throw ierror(macro $v{msg});
							}
						case _:
							throw ierror(macro "unexpected cvalue");
					}
				}

				var cvalue = if (type.canImplicitlyCast(expectedType)) {
					addWithImplicitCast(src, source, internalType, expectedType).cvalue;
				} else {
					addTypesMismatchError(expectedType, type, pos);
					src.append(source, true);
					null;
				}
				return {
					type: expectedType,
					lvalue: false,
					cvalue: cvalue
				}
		}

		final voidValue = {
			type: TVoid,
			lvalue: false,
			cvalue: null
		}

		return switch e.expr {
			case EConst(c):
				final res:GInternalType = switch c {
					case CString(_, _):
						addError("String is not supported", pos);
						voidValue;
					case CRegexp(_, _):
						addError("RegExp is not supported", pos);
						voidValue;
					case CIdent("null"):
						addError("null is not supported", pos);
						voidValue;
					case CIdent("true"):
						src.add("true");
						{
							type: TBool,
							lvalue: false,
							cvalue: VScalar(VBool(true))
						}
					case CIdent("false"):
						src.add("false");
						{
							type: TBool,
							lvalue: false,
							cvalue: VScalar(VBool(false))
						}
					case CIdent(s):
						switch env.resolveField(s) {
							case null:
								// not found in local, only built-in one is allowed here
								// external field access is processed in EField part
								var val = null;
								for (v in builtInVars) {
									switch v.kind {
										case BuiltIn(vkind):
											if (v.name == s) {
												switch ([kind, vkind]) {
													case [Module | VertexOrFragment, _] | [Vertex, VertexIn | VertexOut] |
														[Fragment, FragmentIn | FragmentOut]:
													// ok
													case [Fragment, _]:
														addError("cannot access " + s + " from a fragment shader", pos);
													case [Vertex, _]:
														addError("cannot access " + s + " from a vertex shader", pos);
												}
												val = {
													type: v.type,
													lvalue: switch vkind {
														case VertexIn | FragmentIn:
															false;
														case VertexOut | FragmentOut:
															true;
													},
													cvalue: null
												}
												break;
											}
										case _:
											throw ierror(macro "internal error");
									}
								}
								if (val == null) {
									// maybe a built-in function
									final funcs = builtInFuncs.filter(f -> f.name == s);
									if (funcs.length == 0) {
										addError("unknown identifier " + s, pos);
										voidValue;
									} else {
										if (statement)
											throw error("cannot use a function here", pos);
										src.add(s);
										{
											type: funcs.toFuncsType(),
											lvalue: false,
											cvalue: VFunc(funcs, null)
										}
									}
								} else {
									src.add(s);
									val;
								}
							case FVar(v):
								// resolve global consts
								switch v.kind {
									case GlobalConstUnparsed(e):
										// parse expression
										v.kind = GlobalConstParsing;
										final env = env.copyGlobal();
										final source = new Source();
										final type = parseExpr(e, source, env, false, v.type == TVoid ? null : v.type);
										if (type.cvalue == null)
											throw error("global variable must be initialized with a compile-time const value", pos);
										v.type = type.type;
										v.kind = Global(Const(type.cvalue));
										// give the field the type, and erase the initial value
										v.field.kind = FVar(v.type.toComplexType(), null);
									case GlobalConstParsing:
										throw error("recursive definition found", pos);
									case _:
								}

								if (!dryMode) { // this process can potentially generate global fields
									var accessResult = switch v.kind {
										case Global(Const(cvalue)):
											src.add(cvalue.toSource(this));
											null;
										case Local(localVar):
											src.add(localVar.namePlaceholder);
											env.accessVariable(v, getUniqueGlobalVarName, pos);
										case Argument(argumentVar):
											src.add(argumentVar.namePlaceholder);
											env.accessVariable(v, getUniqueGlobalVarName, pos);
										case _:
											src.add(s);
											env.accessVariable(v, getUniqueGlobalVarName, pos);
									}
									switch accessResult {
										case null | RLocal | RFunc | RGlobal: // do nothing
										case RGlobalGenerated(v):
											// new global var generated, add it to the list
											additionalGlobalVars.push(v);
									}
								}

								switch [kind, v.kind] {
									case [Fragment, Attribute(_)]:
										addError("cannot access a vertex attribute from a fragment shader", pos);
									case [Vertex, Color(_)]:
										addError("cannot access an output color from a vertex shader", pos);
									case _:
								}

								{
									type: v.type,
									lvalue: switch v.kind {
										case Uniform:
											false;
										case Attribute(_):
											false;
										case Color(_):
											true;
										case Varying(_):
											switch kind {
												case Vertex | VertexOrFragment:
													true;
												case Fragment:
													false;
												case Module:
													throw ierror(macro "expcted no module here");
											}
										case BuiltIn(_):
											throw ierror(macro "internal error");
										case Global(kind):
											switch kind {
												case Mutable:
													true;
												case Const(_):
													false;
											}
										case GlobalConstUnparsed(_) | GlobalConstParsing:
											throw ierror(macro "internal error");
										case Local(v):
											switch v.kind {
												case Mutable:
													true;
												case Immutable | Const(_):
													false;
											}
										case Argument(_):
											true;
									},
									cvalue: switch v.kind {
										case Local({kind: Const(cvalue)}) | Global(Const(cvalue)):
											cvalue;
										case _:
											null;
									}
								}
							case FFunc(f):
								src.add(f.name);
								if (statement)
									throw error("cannot use a function here", pos);
								final funcs = env.getAccessibleGlobalFuncsOfName(f.name);
								{
									type: funcs.toFuncsType(),
									lvalue: false,
									cvalue: VFunc(funcs, null)
								}
						}
					case CInt(v):
						src.add(v);
						{
							type: TInt,
							lvalue: false,
							cvalue: VScalar(VInt(Std.parseInt(v)))
						}
					case CFloat(v):
						src.add(v);
						{
							type: TFloat,
							lvalue: false,
							cvalue: VScalar(VFloat(Std.parseFloat(v)))
						}
				}
				if (statement)
					src.add(";");
				res;
			case EArray(e1, e2):
				final t1 = parseExpr(e1, src, env, false);
				src.add("[");
				final t2 = parseExpr(e2, src, env, false);
				src.add("]");
				if (statement)
					src.add(";");
				t1.resolveArrayAccess(t2, pos);
			case EBinop(op, e1, e2):
				final s1 = new Source();
				final s2 = new Source();
				final t1 = parseExpr(e1, s1, env, false);
				final t2 = parseExpr(e2, s2, env, false, op == OpAssign ? t1.type : null);
				final res = t1.resolveBinop(op, t2, pos);
				final resType = res.result;
				final et1 = res.args[0].type;
				final et2 = res.args[1].type;
				addWithImplicitCast(src, s1, t1, et1);
				src.add(" " + op.toString() + " ");
				addWithImplicitCast(src, s2, t2, et2);
				if (statement)
					src.add(";");
				resType;
			case EField(e, field):
				final fieldChain = parseFieldChain(origExpr);
				var externalType:GInternalType = null;
				if (fieldChain != null) {
					final pos = origExpr.pos;
					final len = fieldChain.length;
					switch fieldChain[0] {
						case "this":
							throw error("\"this\" is not supported", pos);
						case "super":
							switch len {
								case 2:
									final superName = fieldChain[1];
									switch env.resolveSuperFunctionName(superName) {
										case null:
											throw error("could not find a super function " + superName, pos);
										case name:
											src.add(name);
											if (statement)
												throw error("cannot use a function here", pos);
											// replace the original expr with the actual function name,
											// since it can be resolved in a different context later
											origExpr.expr = EConst(CIdent(name));
											// super function might be overloaded
											final funcs = env.getAccessibleGlobalFuncsOfName(name);
											externalType = {
												type: funcs.toFuncsType(),
												lvalue: false,
												cvalue: VFunc(funcs, null)
											}
									}
								case _:
									throw error("invalid usage of super", pos);
							}
						case name:
							final localHit = env.resolveField(name);
							if (localHit == null) {
								// replace the original expr with the full path,
								// since it can be resolved in a different context later
								final cfa = resolveExternalClassFieldAccess(fieldChain, pos);
								origExpr.expr = cfa.fullChain.toExpr(pos).expr;

								// resolve the field actually
								final source = new Source();
								final type = parseExpr(cfa.localChain.toExpr(pos), source, cfa.env, false);
								if (type.cvalue == null)
									throw error("external variable must have a compile-time const value", pos);

								if (type.type.isFunctionType() && statement)
									throw error("cannot use a function here", pos);

								src.append(source, true);
								if (statement)
									src.add(";");
								externalType = type;
							}
					}
				}
				if (externalType != null) {
					externalType;
				} else {
					final t = parseExpr(e, src, env, false);
					src.add(".");
					src.add(field);
					if (statement)
						src.add(";");
					t.resolveFieldAccess(field, pos);
				}
			case EParenthesis(e):
				src.add("(");
				final t = parseExpr(e, src, env, false);
				src.add(")");
				if (t.type.isFunctionType() && statement)
					throw error("cannot use a function here", pos);
				if (statement)
					src.add(";");
				t;
			case EArrayDecl(values):
				if (values.length == 0) {
					addError("array cannot be empty", pos);
					voidValue;
				} else {
					final expectedBaseType = switch expectedType {
						case null:
							null;
						case TArray(type, _):
							type;
						case _:
							throw ierror(macro "internal error");
					}
					final n = values.length;
					final sources = values.map(_ -> new Source());
					final first = parseExpr(values[0], sources[0], env, false, expectedBaseType);
					final baseType = first.type;
					if (baseType.match(TArray(_)))
						addError("multidimensional array is not supported", pos);
					if (baseType.isFunctionType())
						addError("array of functions is not supported", pos);
					final rest = [for (i in 1...n) parseExpr(values[i], sources[i], env, false, baseType)];
					final internalTypes = [first].concat(rest);
					final arrayType = TArray(baseType, Resolved(n));
					if (expectedType != null && !expectedType.equals(arrayType))
						addTypesMismatchError(expectedType, arrayType, pos);
					var cvalues = [];

					src.add(baseType.toGLSLType(this).join(""));
					src.add("[");
					src.add("]");
					src.add("(");
					for (i in 0...n) {
						if (i > 0)
							src.add(", ");
						src.append(sources[i], true);
						cvalues.push(internalTypes[i].cvalue);
					}
					src.add(")");
					if (statement)
						src.add(";");
					{
						type: arrayType,
						lvalue: false,
						cvalue: cvalues.contains(null) ? null : VArray(cvalues)
					}
				}
			case EObjectDecl(fields):
				final expectedFields = switch expectedType {
					case null:
						null;
					case TStruct(fields):
						fields;
					case _:
						throw ierror(macro "internal error");
				}
				final fieldVals = [];
				final sfields:Array<GStructField> = [];
				for (field in fields) {
					final source = new Source();
					final expectedFieldType = switch expectedFields {
						case null:
							null;
						case _.find(f -> f.name == field.field) => field:
							field == null ? null : field.type;
					}
					final type = parseExpr(field.expr, source, env, false, expectedFieldType);
					final pos = field.expr.pos;
					if (type.type.isFunctionType())
						throw error("structure must not contain a function", pos);
					if (type.type.containsSampler())
						throw error("cannot make a structure that contains a sampler", pos);
					fieldVals.push({
						name: field.field,
						source: source,
						type: type
					});
					sfields.push({
						name: field.field,
						type: type.type,
						pos: pos
					});
				}
				final structType = TStruct(sfields);
				if (expectedType != null && !expectedType.equals(structType)) {
					if (expectedType.equals(structType, true)) {
						addTypesMismatchError(expectedType, structType, pos, "\nOrders of the fields must match");
					} else {
						addTypesMismatchError(expectedType, structType, pos);
					}
				}
				src.add(structType.toGLSLType(this).join(""));
				src.add("(");
				for (i => val in fieldVals) {
					if (val.name != sfields[i].name)
						throw ierror(macro "field names mismatch");
					if (i > 0)
						src.add(", ");
					src.append(val.source, true);
				}
				src.add(")");
				if (statement)
					src.add(";");
				final cvalue = fieldVals.mapi((i, f) -> {name: f.name, value: f.type.cvalue});
				{
					type: structType,
					lvalue: false,
					cvalue: cvalue.exists(v -> v.value == null) ? null : VStruct(cvalue)
				}
			case ECall(e, params):
				final source = new Source();
				final pos = e.pos;
				final source = new Source();
				final type = parseExpr(e, source, env, false);
				if (!type.type.isFunctionType())
					throw error("cannot call " + type.type.toString(), pos);
				switch type.cvalue {
					case null:
						throw error("cannot determine function", pos);
					case VFunc(funcs, sideEffectSource):
						if (sideEffectSource != null)
							throw error("cannot immediately call a returned function", pos);

						final sources = params.map(_ -> new Source());
						final args = params.mapi((i, param) -> {
							parseExpr(params[i], sources[i], env, false);
						});
						final name = funcs[0].name;

						final data = switch funcs[0].kind {
							case BuiltIn | BuiltInConstructor:
								null;
							case User(data):
								data;
						}
						final isBuiltIn = data == null;
						final isConstructor = funcs[0].kind == BuiltInConstructor;
						if (isBuiltIn && isConstructor) {
							if (funcs.length > 1)
								throw ierror(macro "built-in constructors must not be overloaded");
							final func = funcs[0];
							src.add(name);
							src.add("(");
							for (i in 0...sources.length) {
								if (i > 0)
									src.add(", ");
								src.append(sources[i], true);
							}
							src.add(")");
							if (statement)
								src.add(";");

							constructType(func.type, args, pos);
						} else {
							final source = new Source();
							final func = funcs[args.map(arg -> arg.type).resolveOverload(funcs, pos)];
							final expectedArgTypes = func.args.map(arg -> arg.type);
							final funcNamePlaceholder = source.addPlaceholder("<unknown name>");

							switch [func.region, kind] {
								case [Vertex, Fragment]:
									addError("cannot call " + name + " from a fragment shader", pos);
								case [Fragment, Vertex]:
									addError("cannot call " + name + " from a vertex shader", pos);
								case _:
							}

							final noParentheses = if (isBuiltIn && name == "discard") {
								if (!statement)
									throw error("cannot call discard in this form", pos);
								true;
							} else {
								false;
							}

							if (!noParentheses)
								source.add("(");
							final funcArgs = [];
							for (i in 0...sources.length) {
								if (i > 0)
									source.add(", ");
								final expected = expectedArgTypes[i];
								if (expected.isFunctionType()) {
									switch args[i].cvalue {
										case null:
											throw ierror(macro "function type variable must be a compile-time constant");
										case VFunc(funcs, sideEffectSource):
											if (sideEffectSource != null) {
												source.append(sideEffectSource, true); // resolve the side effect
											} else {
												source.add("0"); // dummy argument
											}
											switch expected {
												case TFunc(f):
													funcArgs.push(extractFunction(f, funcs, params[i].pos));
												case TFuncs(_):
													throw ierror(macro "argument type cannot be a functions type");
												case _:
													throw ierror(macro "internal error");
											}
										case _:
											throw ierror(macro "expected function type");
									}
								} else {
									addWithImplicitCast(source, sources[i], args[i], expectedArgTypes[i]);
								}
							}
							if (!noParentheses)
								source.add(")");
							src.append(source, true);
							if (statement)
								src.add(";");

							var cvalue = null;
							if (!dryMode) { // this process can potentially generate global fields
								if (isBuiltIn) {
									final name = func.name;
									final generatedName = getAccessibleGeneratedFuncName(name, name, func.args, func.type, env);
									funcNamePlaceholder.str = generatedName;
								} else {
									// parse recursively
									if (kind != Module) {
										final funcToParse = new FunctionToParse(func, funcArgs);
										final result = parseFuncImpl(funcToParse, pos, env);
										funcNamePlaceholder.str = result.generatedName;
										if (func.type.isFunctionType()) {
											cvalue = switch result.cvalue {
												case null:
													throw error("could not resolve function; function did not return a compile-time constant",
														pos);
												case VFunc(funcs, sideEffectSource):
													if (sideEffectSource != null)
														throw ierror(macro "internal error");
													VFunc(funcs, source); // attach source for the potential side effect
												case _:
													throw ierror(macro "expected function value");
											}
										}
									}
								}
							}
							if (dryMode && func.type.isFunctionType()) {
								cvalue = switch func.type {
									case TFunc(f):
										VFunc([generateDummyFunc(f)], null);
									case _:
										throw ierror(macro "expected TFunc");
								}
							}
							{
								type: func.type,
								lvalue: false,
								cvalue: cvalue
							}
						}
					case _:
						throw ierror(macro "expected functions");
				}
			case EUnop(op, postFix, e):
				if (!postFix)
					src.add(op.toString());
				final t = parseExpr(e, src, env, false);
				if (postFix)
					src.add(op.toString());
				if (statement)
					src.add(";");
				t.resolveUnop(op, postFix, pos);
			case EVars(vars):
				if (!statement)
					addError("variable definition cannot be placed here", pos);
				for (v in vars) {
					final source = new Source();
					final sourceRhsOnly = new Source();
					if (v.type == null && v.expr == null) {
						addError("auto typing without an initial value is not supported", pos);
						continue;
					}
					final isConst = v.isFinal;

					final typeBeforeNameAndSpacePlaceholder = source.addPlaceholder("<unknown type> ");
					final namePlaceholder = source.addPlaceholder(v.name);
					final typeAfterNamePlaceholder = source.addPlaceholder("");

					var type = v.type == null ? null : resolveArraySize(env, v.type.toGType(pos), pos);
					var cvalue = null;
					if (v.expr == null) {
						if (isConst)
							addError("const variable must be given an initial value", pos);
					} else {
						source.add(" = ");
						final rhs = parseExpr(v.expr, sourceRhsOnly, env, false, type);
						source.append(sourceRhsOnly, true);
						cvalue = isConst ? rhs.cvalue : null;
						if (type == null) {
							type = rhs.type;
						}
					}
					var isFuncType = false;
					if (type == TVoid) {
						addError("variable type must not be void", pos);
					} else {
						if (type.isFunctionType()) {
							switch cvalue {
								case null:
									addError("function type variable must be a compile-time constant", pos);
									continue;
								case VFunc([f], sideEffectSource):
									if (f.kind == BuiltInConstructor) {
										addError("cannot bind a type constructor to a variable", pos);
										continue;
									}
									if (sideEffectSource != null) {
										src.append(sideEffectSource, true);
										src.add(";");
										src.breakLine();
										cvalue = VFunc([f], null); // resolve the side effect
									}
									isFuncType = true;
								case VFunc(_):
									addError("ambiguous reference to a function", pos);
									continue;
								case _:
									throw ierror(macro "unexpected cvalue");
							}
						}
						v.type = type.toComplexType();
					}
					source.add(";");
					source.breakLine();
					if (!isFuncType) {
						final glslType = type.toGLSLType(this);
						typeBeforeNameAndSpacePlaceholder.str = glslType[0] + " ";
						typeAfterNamePlaceholder.str = glslType[1];
					}
					env.defineVar(v.name, type, Local({
						kind: isConst ? cvalue != null ? Const(cvalue) : Immutable : Mutable,
						turnedGlobal: false,
						typeBeforeNameAndSpacePlaceholder: typeBeforeNameAndSpacePlaceholder,
						namePlaceholder: namePlaceholder,
						typeAfterNamePlaceholder: typeAfterNamePlaceholder
					}), null, pos);
					if (isConst && cvalue != null) {
						// do not generate a compile-time constant definition since all references will be folded
					} else {
						src.append(source, true);
					}
				}
				voidValue;
			case EFunction(kind, f):
				final expected = switch expectedType {
					case TFunc(f):
						f;
					case _:
						null;
				}
				if (expected != null) {
					if (expected.args.length != f.args.length)
						throw error("argument counts mismatch", pos);
				}
				final argLen = f.args.length;
				final expectedArgTypes = expected != null ? expected.args : [for (i in 0...argLen) null];
				final args = f.args.zip(expectedArgTypes, (arg, expectedArgType) -> {
					if (arg.opt)
						addError("optional argument is not supported", pos);
					final argType = arg.type != null ? arg.type.toGType(pos) : null;
					final type = switch [argType, expectedArgType] {
						case [null, null]:
							throw error("argument type must be explicitly given", pos);
						case [type, null]:
							type;
						case [null, {name: _, type: expectedType}]:
							expectedType;
						case [type, {name: _, type: expectedType}]:
							if (!type.equals(expectedType))
								addTypesMismatchError(expectedType, type, pos);
							type;
					}
					{
						name: arg.name,
						type: type,
						isRef: false
					}
				});
				var ret = f.ret == null ? null : f.ret.toGType(pos, true);
				final expectedRet = expected == null ? null : expected.ret;
				ret = switch [ret, expectedRet] {
					case [null, null]:
						null;
					case [type, null]:
						type;
					case [null, expectedType]:
						expectedType;
					case [type, expectedType]:
						if (!type.equals(expectedType))
							addTypesMismatchError(expectedType, type, pos);
						type;
				}
				var defineFunc:Bool = false;
				final func:GFunc = {
					type: ret,
					args: args,
					name: RESERVED_PREFIX + "anon_" + anonFuncCount++,
					region: All,
					generic: ret == null || ret.isFunctionType(),
					kind: User({
						expr: f.expr,
						field: null,
						env: env.copyLocalSnapshot()
					}),
					pos: pos,
					parsed: false
				}
				switch kind {
					case null | FAnonymous:
					case FNamed(name, inlined):
						if (inlined)
							addError("inline is not supported", pos);
						env.defineVar(name, [func].toFuncsType(), Local({
							kind: Const(VFunc([func], null)),
							turnedGlobal: false,
							typeBeforeNameAndSpacePlaceholder: {str: ""},
							namePlaceholder: {str: ""},
							typeAfterNamePlaceholder: {str: ""}
						}), null, pos);
					case FArrow:
						"anon_arrow";
				}

				if (ret == null) { // dry parse to determine the return type
					final tmp = dryMode;
					dryMode = true;
					final funcToParse = new FunctionToParse(func, generateDummyFuncArgs(func));
					final result = parseOriginalFunc(funcToParse, pos);
					dryMode = tmp;
					if (func.type == null)
						throw ierror(macro "could not determine the return type");
					ret = func.type;
				}

				{
					type: TFunc({
						args: args,
						ret: ret
					}),
					lvalue: false,
					cvalue: VFunc([func], null)
				}
			case EBlock(exprs):
				if (!statement)
					addError("a block cannot be placed here", pos);
				src.add("{");
				src.increaseIndent();
				if (isFuncRoot)
					src.append(currentlyParsingFunction.functionHead, false);
				src.breakLine();

				if (!isFuncRoot)
					env.pushScope();

				for (expr in exprs) {
					try {
						parseExpr(expr, src, env, true);
						src.breakLine();
					} catch (e:GError) {
						addError(e.message, e.pos);
					}
				}

				if (!isFuncRoot)
					env.popScope();

				src.decreaseIndent();
				src.add("}");
				voidValue;
			case EFor(it, expr):
				if (!statement)
					addError("a for statement cannot be placed here", pos);
				switch it.expr {
					case EBinop(OpIn, {expr: EConst(CIdent(v)), pos: vpos}, _.expr => EBinop(OpInterval, from, until)):
						src.add("for (");
						final typeBeforeNameAndSpacePlaceholder = src.addPlaceholder("int ");
						final namePlaceholder = src.addPlaceholder(v);
						final typeAfterNamePlaceholder = src.addPlaceholder("");
						src.add(" = ");
						parseExpr(from, src, env, false, TInt);
						src.add("; ");
						src.add(namePlaceholder);
						src.add(" < ");
						parseExpr(until, src, env, false, TInt);
						src.add("; ");
						src.add(namePlaceholder);
						src.add("++) ");
						env.pushScope();
						try {
							env.defineVar(v, TInt, Local({
								kind: Immutable,
								turnedGlobal: false,
								typeBeforeNameAndSpacePlaceholder: typeBeforeNameAndSpacePlaceholder,
								namePlaceholder: namePlaceholder,
								typeAfterNamePlaceholder: typeAfterNamePlaceholder
							}), null, vpos);
							parseExpr(expr, src, env, true);
							src.breakLine();
						} catch (e:GError) {
							addError(e.message, e.pos);
						}
						env.popScope();
					case EBinop(OpIn, {expr: EConst(CIdent(v)), pos: vpos}, e):
						final source = new Source();
						final arrayValue = parseExpr(e, source, env, false);
						final info = switch arrayValue.type {
							case TArray(type, Resolved(count)):
								{
									type: type,
									count: count
								}
							case TArray(_):
								throw ierror(macro "array size must be resolved here");
							case _:
								throw error("cannot iterate " + arrayValue.type.toString(), e.pos);
						}

						if (info.type.containsSampler()) {
							throw error("cannot iterate an array that contains a sampler", e.pos);
						}

						final array = env.createTempVar();
						final arrayGLSLType = arrayValue.type.toGLSLType(this);
						src.add(arrayGLSLType[0] + " ");
						src.add(array);
						src.add(arrayGLSLType[1]);
						src.add(" = ");
						src.append(source, true);
						src.add(";");
						src.breakLine();

						final index = env.createTempVar();
						src.add("for (int ");
						src.add(index);
						src.add(" = 0; ");
						src.add(index);
						src.add(" < " + info.count + "; ");
						src.add(index);
						src.add("++) {");
						src.increaseIndent();
						src.breakLine();
						final glslType = info.type.toGLSLType(this);
						final typeBeforeNameAndSpacePlaceholder = src.addPlaceholder(glslType[0] + " ");
						final namePlaceholder = src.addPlaceholder(v);
						final typeAfterNamePlaceholder = src.addPlaceholder(glslType[1]);
						src.add(" = ");
						src.add(array);
						src.add("[");
						src.add(index);
						src.add("];");
						src.breakLine();

						env.pushScope();
						try {
							env.defineVar(v, info.type, Local({
								kind: Mutable,
								turnedGlobal: false,
								typeBeforeNameAndSpacePlaceholder: typeBeforeNameAndSpacePlaceholder,
								namePlaceholder: namePlaceholder,
								typeAfterNamePlaceholder: typeAfterNamePlaceholder
							}), null, vpos);
							parseExpr(expr, src, env, true);
							src.breakLine();
						} catch (e:GError) {
							addError(e.message, e.pos);
						}
						env.popScope();

						src.decreaseIndent();
						src.add("}");
						src.breakLine();
					case _:
						addError("unsupported for-statement usage", pos);
						src.add("for (<error>) ");
						parseExpr(expr, src, env, true);
						src.breakLine();
				}
				voidValue;
			case EIf(econd, eif, eelse):
				if (!statement)
					addError("an if statement cannot be placed here", pos);
				src.add("if (");
				parseExpr(econd, src, env, false, TBool);
				src.add(") ");
				parseExpr(eif, src, env, true);
				src.breakLine();
				if (eelse != null) {
					src.add("else ");
					parseExpr(eelse, src, env, true);
					src.breakLine();
				}
				voidValue;
			case EWhile(econd, e, normalWhile):
				if (!statement)
					addError("a while statement cannot be placed here", pos);
				if (normalWhile) {
					src.add("while (");
					parseExpr(econd, src, env, false, TBool);
					src.add(") ");
					parseExpr(econd, src, env, true);
					src.breakLine();
				} else {
					src.add("do ");
					parseExpr(econd, src, env, true);
					src.breakLine();
					src.add("while (");
					parseExpr(econd, src, env, false, TBool);
					src.add(");");
				}
				voidValue;
			case ESwitch(e, cases, edef):
				if (!statement)
					addError("a switch statement cannot be placed here", pos);
				src.add("switch (");
				parseExpr(e, src, env, false, TInt);
				src.add(") {");
				src.breakLine();
				final usedValues:Map<Int, Position> = new Map();
				for (c in cases) {
					if (c.guard != null)
						addError("guards are not supported", c.guard.pos);
					final values = c.values.flatMap(splitByOr);
					final actualValues:Array<{value:Int, pos:Position}> = [];
					for (value in values) {
						final source = new Source();
						final type = parseExpr(value, source, env, false, TInt);
						switch type.cvalue {
							case null:
								addError("only compile-time const integers are supported for a case label", value.pos);
							case VScalar(VInt(v)):
								src.add("case " + v + ":");
								src.breakLine();
								actualValues.push({
									value: v,
									pos: value.pos
								});
							case _:
								throw ierror(macro "internal error");
						}
					}
					for (value in actualValues) {
						if (usedValues.exists(value.value)) {
							addError("duplicate case: " + value.value, value.pos);
						}
						usedValues[value.value] = value.pos;
					}
					c.values = actualValues.map(v -> {
						expr: EConst(CInt("" + v.value)),
						pos: v.pos
					});
					src.increaseIndent();
					if (c.expr != null) {
						parseExpr(c.expr, src, env, true);
						src.breakLine();
					}
					src.add("break;");
					src.breakLine();
					src.decreaseIndent();
				}
				src.add("}");
				voidValue;
			case EReturn(e):
				if (!statement)
					addError("a return statement cannot be placed here", pos);
				parseReturn(e, src, env, false, pos);
				voidValue;
			case EBreak:
				if (!statement)
					addError("a break statement cannot be placed here", pos);
				src.add("break;");
				voidValue;
			case EContinue:
				if (!statement)
					addError("a continue statement cannot be placed here", pos);
				src.add("continue;");
				voidValue;
			case ETernary(econd, eif, eelse):
				final tcond = parseExpr(econd, src, env, false, TBool);
				src.add(" ? ");
				final t1 = parseExpr(eif, src, env, false);
				src.add(" : ");
				final t2 = parseExpr(eelse, src, env, false, t1.type);

				final isFunc = t1.type.isFunctionType();
				if (isFunc && statement)
					throw error("cannot use a function here", pos);

				if (statement)
					src.add(";");
				{
					type: t1.type,
					lvalue: false,
					cvalue: switch tcond.cvalue {
						case VScalar(VBool(v)):
							v ? t1.cvalue : t2.cvalue;
						case _:
							if (isFunc)
								throw error("function reference could not be resolved at compile time", pos);
							null;
					}
				}
			case EMeta(_.name => ":implicitReturn", _.expr => EReturn(ret)):
				switch ret.expr {
					case EVars(_) | EBlock(_) | EFor(_) | EIf(_) | EWhile(_) | ESwitch(_):
						// remove implicit return for these cases
						e.expr = ret.expr;
						parseExpr(e, src, env, true, null, isFuncRoot); // do not return
					case _:
						parseReturn(ret, src, env, true, pos); // parse implicit return
						voidValue;
				}
			case _:
				addError("this kind of expression is not supported: " + e.toString() + " (" + e.expr.getName() + ")", e.pos);
				voidValue;
		}
	}

	function parseReturn(e:Expr, src:Source, env:Environment, implicitReturn:Bool, pos:Position):Void {
		final source = new Source();
		final expected = currentlyParsingFunction.ret;
		final t = e == null ? null : parseExpr(e, source, env, false, expected);
		if (t != null) { // some value is returned
			if (expected == null)
				currentlyParsingFunction.ret = t.type; // set return type
			if (t.type == TVoid) {
				if (implicitReturn) {
					src.append(source, true);
					src.add(";");
					return;
				} else {
					throw error("cannot return void", pos);
				}
			}
			if (t.type.isFunctionType()) {
				switch t.cvalue {
					case VFunc(funcs, sideEffectSource):
						if (sideEffectSource != null) {
							src.append(sideEffectSource, true); // resolve the side effect
							src.add(";");
							src.breakLine();
						}
						if (currentlyParsingFunction.cvalue != null) {
							throw error("function that returns a function must not have multiple return statements", pos);
						}
						currentlyParsingFunction.cvalue = VFunc(funcs, null);
					case _:
						throw ierror(macro "expected function value");
				}
				src.add("return 0;"); // dummy return value
			} else {
				src.add("return ");
				src.append(source, true);
				src.add(";");
			}
		} else {
			switch expected {
				case null: // set return type
					currentlyParsingFunction.ret = TVoid;
				case TVoid: // ok
				case _: // NG
					throw error("return value of type " + expected.toString() + " expected", pos);
			}
			src.add("return;");
		}
	}
}
#end

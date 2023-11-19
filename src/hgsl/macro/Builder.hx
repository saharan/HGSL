package hgsl.macro;

import haxe.Timer;
import haxe.macro.Context;

using Lambda;

#if macro
class Builder {
	macro public static function buildBaseType():Array<Field> {
		final pos = Context.currentPos();
		final type = switch Context.getLocalType() {
			case TInst(_.get() => t, params):
				switch t.kind {
					case KAbstractImpl(_.get() => a):
						a.type.toComplexType().toGType(pos);
					case _:
						throw "internal error";
				}
			case _:
				throw "internal error";
		}
		final fields = Context.getBuildFields();
		final baseTypes = (switch type {
			case TVec2 | TVec3 | TVec4:
				[TFloat, TVec2, TVec3, TVec4];
			case TIVec2 | TIVec3 | TIVec4:
				[TInt, TIVec2, TIVec3, TIVec4];
			case TUVec2 | TUVec3 | TUVec4:
				[TUInt, TUVec2, TUVec3, TUVec4];
			case TBVec2 | TBVec3 | TBVec4:
				[TBool, TBVec2, TBVec3, TBVec4];
			case _:
				[];
		}).map(t -> t.toComplexType());
		final dim = switch type {
			case TVec2 | TIVec2 | TUVec2 | TBVec2:
				2;
			case TVec3 | TIVec3 | TUVec3 | TBVec3:
				3;
			case TVec4 | TIVec4 | TUVec4 | TBVec4:
				4;
			case _:
				0;
		}
		if (dim > 0) {
			for (f in buildSwizzles(dim, baseTypes)) {
				fields.push(f);
			}
		}
		for (f in buildOperators(type)) {
			fields.push(f);
		}
		return fields;
	}

	static function buildOperators(type:GType):Array<Field> {
		final fields:Array<Field> = [];
		final pos = Context.currentPos();
		// unary operators don't require implicit casts
		for (un in Operator.UN_LIST.data) {
			final func = un.func;
			if (type.equals(un.func.args[0].type)) {
				fields.push({
					name: "unop" + (un.postFix ? "Post" : "Pre") + un.op.getName().substr(2),
					kind: FFun({
						args: [],
						ret: func.type.toComplexType(),
					}),
					pos: pos,
					access: [APrivate],
					meta: [
						{
							name: ":op",
							params: [
								switch [un.op, un.postFix] {
									case [OpIncrement, false]:
										macro ++A;
									case [OpIncrement, true]:
										macro A++;
									case [OpDecrement, false]:
										macro --A;
									case [OpDecrement, true]:
										macro A++;
									case [OpNot, false]:
										macro !A;
									case [OpNeg, false]:
										macro - A;
									case [OpNegBits, false]:
										macro ~A;
									case _:
										throw "internal error";
								}
							],
							pos: pos
						}
					]
				});
			}
		}
		// make all possible (incliding implicit cast) binary operator overloads
		for (bin in Operator.ALL_POSSIBLE_BINOP_TYPES) {
			for (types in bin.types) {
				final lhs = types[0];
				final rhs = types[1];
				final ret = types[2];
				if (lhs.equals(type) || rhs.equals(type)) {
					fields.push({
						name: "binop" + bin.op.getName().substr(2),
						kind: FFun({
							args: [
								{
									name: "lhs",
									type: lhs.toComplexType()
								},
								{
									name: "rhs",
									type: rhs.toComplexType()
								}
							],
							ret: ret.toComplexType()
						}),
						pos: pos,
						access: [AOverload, APrivate, AStatic],
						meta: [
							{
								name: ":op",
								params: [
									switch bin.op {
										case OpAdd:
											macro A + B;
										case OpMult:
											macro A * B;
										case OpDiv:
											macro A / B;
										case OpSub:
											macro A - B;
										case OpGt:
											macro A > B;
										case OpGte:
											macro A >= B;
										case OpLt:
											macro A < B;
										case OpLte:
											macro A <= B;
										case OpAnd:
											macro A & B;
										case OpOr:
											macro A | B;
										case OpXor:
											macro A ^ B;
										case OpBoolAnd: macro A && B;
										case OpBoolOr: macro A || B;
										case OpShl:
											macro A << B;
										case OpShr:
											macro A >> B;
										case OpMod:
											macro A % B;
										case _:
											throw "internal error";
									}
								],
								pos: pos
							}
						]
					});
				}
			}
		}
		return fields;
	}

	static function buildSwizzles(dim:Int, types:Array<ComplexType>):Array<Field> {
		final fields:Array<Field> = [];
		final vals2 = [["x", "y"], ["r", "g"], ["s", "t"]];
		final vals3 = [["x", "y", "z"], ["r", "g", "b"], ["s", "t", "p"]];
		final vals4 = [["x", "y", "z", "w"], ["r", "g", "b", "a"], ["s", "t", "p", "q"]];
		inline function param(name:String):Void {
			final n = name.length;
			final perm = name.split("").foreach(c -> name.replace(c, "").length == n - 1);
			final pos = Context.currentPos();
			final retType = types[n - 1];
			if (perm) {
				fields.push({
					name: name,
					kind: FProp("get", "set", retType),
					pos: pos
				});
				fields.push({
					name: "get_" + name,
					kind: FFun({
						args: [],
						ret: retType,
					}),
					pos: pos,
					access: [APrivate, AExtern]
				});
				fields.push({
					name: "set_" + name,
					kind: FFun({
						args: [
							{
								name: "v",
								type: retType
							}
						],
						ret: retType,
					}),
					pos: pos,
					access: [APrivate, AExtern]
				});
			} else {
				fields.push({
					name: name,
					kind: FProp("get", "never", retType),
					pos: pos
				});
				fields.push({
					name: "get_" + name,
					kind: FFun({
						args: [],
						ret: retType,
					}),
					pos: pos,
					access: [APrivate, AExtern]
				});
			}
		}
		for (comps in [null, null, vals2, vals3, vals4][dim]) {
			for (a in comps) {
				param(a);
				for (b in comps) {
					param(a + b);
					for (c in comps) {
						param(a + b + c);
						for (d in comps) {
							param(a + b + c + d);
						}
					}
				}
			}
		}
		return fields;
	}

	macro public static function buildModule():Array<Field> {
		// trace("building " + Context.getLocalClass().get().name);
		final res = buildShader(true);
		// trace("finished building " + Context.getLocalClass().get().name);
		return res;
	}

	macro public static function buildMain():Array<Field> {
		// trace("building " + Context.getLocalClass().get().name);
		final res = buildShader(false);
		// trace("finished building " + Context.getLocalClass().get().name);
		return res;
	}

	macro public static function buildStruct():Array<Field> {
		// trace("building " + Context.getLocalClass().get().name);
		return tryToBuild(fields -> {
			final localClass = Context.getLocalClass().get();

			if (fields.length == 0)
				throw error("structure must not be empty", localClass.pos);

			final sup = localClass.superClass.t.get();
			if (sup.module != SHADER_STRUCT_MODULE_PATH)
				throw error("cannot inherit a shader struct", localClass.pos);

			final structFields = [];

			final env = new Environment(localClass.module, localClass.name);
			Environment.register(localClass.module, localClass.name, env);

			for (field in fields) {
				final pos = field.pos;
				switch field.kind {
					case FVar(t, e):
						if (field.access.length != 0)
							addError("variable in a structure class must not have any access modifier", pos);
						if (e != null)
							addError("variable in a structure cannot have an initial value", e.pos);
						if (t == null)
							addError("variable type must be explicitly specified", pos);
						env.defineVar(field.name, t.toGType(pos), Global(Mutable), field, pos);
						field.kind = FVar(t, null);
						structFields.push(field);
					case FFun(_):
						addError("structure class cannot define a function", pos);
					case FProp(_):
						addError("structure class cannot define a property", pos);
				}
			}
			fields.resize(0);

			// resolve array sizes and structs
			{
				final parser = new Parser(localClass.module, localClass.name, new StructPool(), Module);
				env.resolveFieldTypes(parser);
			}

			final type:ComplexType = TAnonymous(structFields);
			fields.push((macro class Struct {
				public var struct:$type;
			}).fields[0]);
		});
	}

	static var fieldsMap:Map<String, Array<Field>> = [];

	static function buildShader(module:Bool):Array<Field> {
		return tryToBuild(fields -> {
			final localClass = Context.getLocalClass().get();

			final env = new Environment(localClass.module, localClass.name);
			Environment.register(localClass.module, localClass.name, env);

			final sup = localClass.superClass.t.get();
			final supEnv = switch sup.module {
				case SHADER_MAIN_MODULE_PATH | SHADER_MODULE_MODULE_PATH:
					new Environment(sup.module, sup.name);
				case _:
					if (module)
						throw error("cannot inherit a shader module", localClass.pos);
					Environment.getRegistered(sup.module, sup.name);
			}

			for (v in supEnv.getGlobalVars()) {
				env.defineVar(v.name, v.type, v.kind, v.field, v.pos);
			}

			final tweakedSuperFuncFields = [];
			for (f in supEnv.getGlobalFuncs()) {
				switch f.kind {
					case BuiltIn | BuiltInConstructor:
						throw ierror(macro "unexpected bult-in function");
					case User(data):
						final origName = f.name;
						// define the function with its original name,
						// this one can be overridden
						env.defineFunc(origName, false, f.type, f.args, f.region, data.expr, data.field, f.pos);

						// also define the function with the tweaked name,
						// this one cannot be overridden and can be accessed with super keyword
						final tweakedName = switch env.resolveSuperFunctionName(origName) {
							case null:
								// this name is not registered yet, generate a unique name and register it for super function calls
								// note that the tweaked name must be consistent because otherwise overload would not work properly
								final tweakedName = env.tweakFunctionName(origName);
								env.registerSuperFunctionNameAs(origName, tweakedName);
								tweakedName;
							case name:
								// already registered, use it
								name;
						}
						env.defineFunc(tweakedName, false, f.type, f.args, f.region, data.expr, data.field, f.pos);
						tweakedSuperFuncFields.push({
							name: tweakedName,
							access: [AExtern, AOverload],
							kind: FFun({
								args: f.args.map(arg -> {
									final res:FunctionArg = {
										name: arg.name,
										type: arg.type.toComplexType()
									}
									res;
								}),
								ret: f.type.toComplexType()
							}),
							pos: f.pos,
							meta: [
								{
									name: ":noCompletion",
									pos: f.pos
								}
							]
						});
				}
			}

			// collect field definitions
			final dummyFuncFields:Array<Field> = [];
			for (field in fields) {
				final pos = field.pos;
				final name = field.name;
				final access = field.access;
				if (name.startsWith("_"))
					addError("field name must not start with \"_\"", pos);
				switch field.kind {
					case FVar(t, e):
						try {
							final isFinal = access.contains(AFinal);
							if (module) {
								final extraModifiers = access.filter(a -> !a.match(AFinal));
								if (!isFinal)
									throw error("variable in a module must be final", pos);
								if (extraModifiers.length > 0)
									throw error("no access modifier is allowed", pos);
								access.resize(0);
								access.push(AExtern);
								access.push(APublic);
								access.push(AStatic);
							} else {
								final extraModifiers = access.filter(a -> !a.match(AFinal));
								if (extraModifiers.length > 0)
									throw error("no access modifier is allowed", pos);
								access.resize(0);
								access.push(AExtern);
							}
							var isUniform = false;
							var varyingKind = null;
							var attribLoc = null;
							var colorLoc = null;
							for (meta in field.meta) {
								switch [meta.name, meta.params] {
									case ["uniform", []]:
										if (isUniform)
											addError("duplicate uniform metadata", meta.pos);
										isUniform = true;
									case ["varying", params]:
										if (varyingKind != null)
											addError("duplicate varying metadata", meta.pos);
										varyingKind = switch params {
											case []:
												Smooth;
											case [_.expr => EConst(CIdent("centroid"))]:
												Centroid;
											case [_.expr => EConst(CIdent("flat"))]:
												Flat;
											case _:
												throw error("invalid varying metadata parameter", meta.pos);
										}
									case ["attribute", params]:
										final loc = switch params {
											case []:
												Unspecified;
											case [_.expr => EConst(CInt(Std.parseInt(_) => i))] if (i >= 0):
												Specified(i);
											case _:
												throw error("invalid vertex attribute location", meta.pos);
										}
										if (attribLoc != null)
											addError("duplicate attribute metadata", meta.pos);
										attribLoc = loc;
									case ["color", params]:
										final loc = switch params {
											case []:
												Specified(0);
											case [_.expr => EConst(CInt(Std.parseInt(_) => i))] if (i >= 0):
												Specified(i);
											case _:
												throw error("invalid output color location", meta.pos);
										}
										if (colorLoc != null)
											throw error("duplicate color metadata", meta.pos);
										colorLoc = loc;
									case _:
										throw error("unsupported metadata", meta.pos);
								}
							}
							final UNIFORM_BIT = 1;
							final ATTRIB_BIT = 2;
							final COLOR_BIT = 4;
							final VARYING_BIT = 8;

							var qualCount = 0;
							var qualBit = 0;
							final quals = [];
							if (isUniform) {
								qualCount++;
								qualBit |= UNIFORM_BIT;
								quals.push("uniform");
							}
							if (attribLoc != null) {
								qualCount++;
								qualBit |= ATTRIB_BIT;
								quals.push("attribute");
							}
							if (colorLoc != null) {
								qualCount++;
								qualBit |= COLOR_BIT;
								quals.push("color");
							}
							if (varyingKind != null) {
								qualCount++;
								qualBit |= VARYING_BIT;
								quals.push("varying");
							}
							if (module) {
								if (qualCount > 0) {
									throw error("invalid type qualifier found: " + quals.join(", "), pos);
								}
							} else {
								if (qualCount > 1) {
									throw error("some type qualifiers conflict: " + quals.join(", "), pos);
								}
							}

							final type = t == null ? TVoid : t.toGType(pos);

							if (!isUniform && type.containsSampler()) {
								throw error("variables of sampler types can only be uniform", pos);
							}

							if (qualCount > 0) {
								if (isFinal) {
									throw error("this kind of variable cannot be final", pos);
								} else if (e != null) {
									throw error("cannot initialize variables", pos);
								} else if (t == null) {
									throw error("varable type must be explicitly given", pos);
								} else {
									if (isUniform) {
										env.defineVar(name, type, Uniform, field, pos);
									} else if (attribLoc != null) {
										env.defineVar(name, type, Attribute(attribLoc), field, pos);
									} else if (colorLoc != null) {
										env.defineVar(name, type, Color(colorLoc), field, pos);
									} else if (varyingKind != null) {
										env.defineVar(name, type, Varying(varyingKind), field, pos);
									} else {
										throw "internal error";
									}
								}
							} else {
								// global variable
								if (isFinal && e == null)
									throw error("initial value must be given for a const variable", pos);
								if (!isFinal && e != null)
									throw error("non-const variable cannot be given an initial value", pos);
								if (e == null && t == null)
									throw error("either initial value or type must be specified", pos);
								final varKind = if (isFinal) {
									field.meta.push({
										name: ":coreExpr",
										params: [e],
										pos: pos
									});
									GlobalConstUnparsed(e);
								} else {
									Global(Mutable);
								}
								env.defineVar(name, type, varKind, field, pos);
							}
							field.kind = FVar(t, null); // erase the initialization
						} catch (e:GError) {
							field.kind = FVar(TVoid.toComplexType(), null); // make it typed Void
							addError(e.message, e.pos);
						}
					case FFun(f):
						try {
							if (module) {
								final hasExtraModifiers = access.length > 0;
								if (hasExtraModifiers)
									addError("no access modifier is allowed", pos);
								access.resize(0);
								access.push(AOverload);
								access.push(AExtern);
								access.push(APublic);
								access.push(AStatic);
							} else {
								final hasExtraModifiers = access.length > 0;
								if (hasExtraModifiers)
									addError("no access modifier is allowed", pos);
								access.resize(0);
								access.push(AOverload);
								access.push(AExtern);
								access.push(AFinal);
							}
							if (f.ret == null) {
								addError("return type must be explicitly given", pos);
								f.ret = TVoid.toComplexType();
							}
							final type = f.ret.toGType(pos, true);

							final typeChanged = type.match(TStruct(_) | TArray(_));
							if (typeChanged)
								f.ret = type.toComplexType();

							final args = f.args.map(arg -> {
								if (arg.opt || arg.value != null)
									addError("optional parameters are not supported", pos);
								if (arg.type == null)
									throw error("argument type must be explicitly given", pos);
								final type = arg.type.toGType(pos);
								{
									name: arg.name,
									type: type,
									isRef: arg.meta.exists(meta -> meta.name == "ref")
								};
							});
							final region = switch name {
								case "vertex":
									Vertex;
								case "fragment":
									Fragment;
								case _:
									All;
							}

							final superFunc = supEnv.getGlobalFuncOfNameAndArgs(name, args);
							if (superFunc != null) {
								// override found, find and delete the super function from the local environment
								final localSuperFunc = env.getGlobalFuncOfNameAndArgs(name, args);
								env.deleteGlobalFunc(localSuperFunc);
							} else {
								if (supEnv.resolveField(name) != null)
									throw error("without overriding, cannot define a function whose name is used in the parent shader", pos);
							}

							final func = env.defineFunc(name, true, type, args, region, f.expr, field, pos);
							switch name {
								case "main":
									throw error("function name cannot be \"main\"", pos);
								case "vertex":
									if (module)
										throw error("shader module cannot define a vertex entry point", pos);
									if (args.length != 0)
										throw error("vertex entry point cannot have arguments", pos);
									if (type != TVoid) throw error("return type of a vertex entry point must be Void", pos);
								case "fragment":
									if (module)
										throw error("shader module cannot define a fragment entry point", pos);
									if (args.length != 0)
										throw error("fragment entry point cannot have arguments", pos);
									if (type != TVoid) throw error("return type of a fragment entry point must be Void", pos);
							}
							dummyFuncFields.push({
								name: env.tweakFunctionName(name),
								access: [AOverload, APrivate, AExtern, AInline, AFinal],
								kind: FFun({
									args: f.args,
									ret: f.ret,
									expr: f.expr
								}),
								pos: field.pos,
								meta: [
									{
										name: ":noCompletion",
										pos: field.pos
									},
									{
										name: ":deprecated",
										pos: field.pos
									}
								]
							});
							field.meta.push({
								name: ":coreExpr",
								params: [f.expr],
								pos: pos
							});
							f.expr = null;
						} catch (e:GError) {
							fields.remove(field); // TODO: is this appropriate?
							addError(e.message, e.pos);
						}
					case FProp(_):
						addError("properties are not supported", pos);
				}
			}

			final parseList = env.getGlobalFuncs();
			final vertex = switch env.getGlobalFuncsOfName("vertex") {
				case []:
					null;
				case [f]:
					f;
				case _:
					throw ierror(macro "multiple vertex entry point found");
			}
			final fragment = switch env.getGlobalFuncsOfName("fragment") {
				case []:
					null;
				case [f]:
					f;
				case _:
					throw ierror(macro "multiple fragment entry point found");
			}

			// add tweaked super functions for linters
			for (field in tweakedSuperFuncFields) {
				fields.push(field);
			}
			// add dummy functions for linters
			for (field in dummyFuncFields) {
				fields.push(field);
			}

			final structPool = new StructPool();

			// resolve array sizes and structs
			{
				final parser = new Parser(localClass.module, localClass.name, structPool, Module);
				env.resolveFieldTypes(parser);
			}

			// resolve global consts
			{
				final parser = new Parser(localClass.module, localClass.name, structPool, Module);
				for (v in env.getGlobalVars()) {
					switch v.kind {
						case GlobalConstUnparsed(_):
							final source = new Source();
							parser.parseExpr(macro $i{v.name}, source, env, false);
						case _:
					}
				}
			}

			// add uniform variables
			final globalVars = env.getGlobalVars();
			for (f in generateConstsFields(globalVars.filter(v -> v.kind.match(Global(Const(_))) && !v.type.match(TFunc(_)))))
				fields.push(f);
			if (!module) {
				for (f in generateUniformsFields(globalVars.filter(v -> v.kind == Uniform)))
					fields.push(f);
				for (f in generateAttributesFields(globalVars.filter(v -> v.kind.match(Attribute(_)))))
					fields.push(f);
			}

			if (module) {
				final parser = new Parser(localClass.module, localClass.name, structPool, Module);
				// compile functions
				for (f in parseList) {
					parser.parseEntryPoint(env, f);
				}
			} else {
				final vertexParser = new Parser(localClass.module, localClass.name, structPool, Vertex);
				var vertexSource = "";
				var fragmentSource = "";
				if (vertex == null) {
					addError("vertex entry point not found", Context.currentPos());
				} else {
					vertexParser.parseEntryPoint(env, vertex);
					vertexSource = vertexParser.generateSource(env);
					fields.push({
						name: "vertexSource",
						access: [APublic, AStatic, AFinal],
						kind: FVar(null, macro $v{vertexSource}),
						pos: vertex.pos
					});
				}
				final fragmentParser = new Parser(localClass.module, localClass.name, structPool, Fragment);
				if (fragment == null) {
					addError("fragment entry point not found", Context.currentPos());
				} else {
					fragmentParser.parseEntryPoint(env, fragment);
					fragmentSource = fragmentParser.generateSource(env);
					fields.push({
						name: "fragmentSource",
						access: [APublic, AStatic, AFinal],
						kind: FVar(null, macro $v{fragmentSource}),
						pos: fragment.pos
					});
				}

				// parse all functions at least once to convert exprs
				{
					final parser = new Parser(localClass.module, localClass.name, structPool, VertexOrFragment);
					for (f in parseList) {
						if (!f.parsed)
							parser.parseEntryPoint(env, f);
					}
				}

				fields.push({
					name: "source",
					access: [APublic, AStatic, AFinal],
					kind: FVar(TPath({
						pack: ["hgsl"],
						name: "Source"
					}), macro {
						vertex: $v{vertexSource},
						fragment: $v{fragmentSource}
					}),
					pos: Context.currentPos()
				});
			}
		});
	}

	static function replacePos(e:Expr, pos:Position):Expr {
		return {
			expr: e.map(e -> replacePos(e, pos)).expr,
			pos: e.pos
		}
	}

	static function getUniformTypeExpr(t:GType, pos:Position):Expr {
		return switch t {
			case TVoid:
				throw error("void cannot be used here", pos);
			case TFloat:
				macro Float;
			case TVec2:
				macro Vec(2);
			case TVec3:
				macro Vec(3);
			case TVec4:
				macro Vec(4);
			case TInt:
				macro Int;
			case TIVec2:
				macro IVec(2);
			case TIVec3:
				macro IVec(3);
			case TIVec4:
				macro IVec(4);
			case TUInt:
				macro UInt;
			case TUVec2:
				macro UVec(2);
			case TUVec3:
				macro UVec(3);
			case TUVec4:
				macro UVec(4);
			case TBool:
				macro Bool;
			case TBVec2:
				macro BVec(2);
			case TBVec3:
				macro BVec(3);
			case TBVec4:
				macro BVec(4);
			case TMat2x2:
				macro Mat(2, 2);
			case TMat3x3:
				macro Mat(3, 3);
			case TMat4x4:
				macro Mat(4, 4);
			case TMat2x3:
				macro Mat(2, 3);
			case TMat3x2:
				macro Mat(3, 2);
			case TMat2x4:
				macro Mat(2, 4);
			case TMat4x2:
				macro Mat(4, 2);
			case TMat3x4:
				macro Mat(3, 4);
			case TMat4x3:
				macro Mat(4, 3);
			case TSampler2D:
				macro Sampler(Sampler2D);
			case TSampler3D:
				macro Sampler(Sampler3D);
			case TSamplerCube:
				macro Sampler(SamplerCube);
			case TSamplerCubeShadow:
				macro Sampler(SamplerCubeShadow);
			case TSampler2DShadow:
				macro Sampler(Sampler2DShadow);
			case TSampler2DArray:
				macro Sampler(Sampler2DArray);
			case TSampler2DArrayShadow:
				macro Sampler(Sampler2DArrayShadow);
			case TISampler2D:
				macro Sampler(ISampler2D);
			case TISampler3D:
				macro Sampler(ISampler3D);
			case TISamplerCube:
				macro Sampler(ISamplerCube);
			case TISampler2DArray:
				macro Sampler(ISampler2DArray);
			case TUSampler2D:
				macro Sampler(USampler2D);
			case TUSampler3D:
				macro Sampler(USampler3D);
			case TUSamplerCube:
				macro Sampler(USamplerCube);
			case TUSampler2DArray:
				macro Sampler(USampler2DArray);
			case TStruct(_):
				macro Struct;
			case TArray(_):
				throw ierror(macro "unexpected array");
			case TFunc(_) | TFuncs(_):
				throw ierror(macro "unexpected function type");
		}
	}

	static function getAttributeTypeExpr(t:GType, pos:Position):Expr {
		return switch t {
			case TFloat:
				macro Float;
			case TVec2:
				macro Vec(2);
			case TVec3:
				macro Vec(3);
			case TVec4:
				macro Vec(4);
			case TInt:
				macro Int;
			case TIVec2:
				macro IVec(2);
			case TIVec3:
				macro IVec(3);
			case TIVec4:
				macro IVec(4);
			case TUInt:
				macro UInt;
			case TUVec2:
				macro UVec(2);
			case TUVec3:
				macro UVec(3);
			case TUVec4:
				macro UVec(4);
			case TMat2x2:
				macro Mat(2, 2);
			case TMat3x3:
				macro Mat(3, 3);
			case TMat4x4:
				macro Mat(4, 4);
			case TMat2x3:
				macro Mat(2, 3);
			case TMat3x2:
				macro Mat(3, 2);
			case TMat2x4:
				macro Mat(2, 4);
			case TMat4x2:
				macro Mat(4, 2);
			case TMat3x4:
				macro Mat(3, 4);
			case TMat4x3:
				macro Mat(4, 3);
			case _:
				throw error(t.toString() + " cannot be used here", pos);
		}
	}

	static function generateUniformExpr(type:GType, path:Expr, pos:Position, onlyName:Bool):Expr {
		final uniform:ComplexType = TPath({
			pack: BASE_PACK,
			name: "Uniform"
		});
		final uniformArrayType:TypePath = {
			pack: BASE_PACK,
			name: "UniformArray"
		}
		return switch type {
			case TStruct(fields):
				macro {
					final path = $path;
					${
						{
							expr: EObjectDecl(fields.map(f -> {
								field: f.name,
								expr: generateUniformExpr(f.type, macro path + $v{"." + f.name}, pos, onlyName),
								quotes: Unquoted
							})),
							pos: pos
						}
					}
				}
			case TArray(type, Resolved(count)):
				macro new $uniformArrayType([
					for (i in 0...$v{count}) {
						final path = $path + "[" + i + "]";
						${generateUniformExpr(type, macro path, pos, onlyName)}
					}
				], $path, ${getUniformTypeExpr(type, pos)});
			case TArray(_):
				throw ierror(macro "array size must be resolved here");
			case TVoid:
				throw error("void cannot be used here", pos);
			case _:
				if (onlyName) {
					path;
				} else {
					macro {
						final obj:$uniform = {
							name: $path,
							type: ${getUniformTypeExpr(type, pos)}
						}
						obj;
					}
				}
		}
	}

	static function generateAttributeExpr(v:GVar, onlyLocation:Bool):Expr {
		final attributeType:ComplexType = TPath({
			pack: BASE_PACK,
			name: "Attribute"
		});
		final location = macro ${
			switch v.kind {
				case Attribute(location):
					switch location {
						case Unspecified:
							macro null;
						case Specified(location):
							macro $v{location};
					}
				case _:
					throw ierror(macro "internal error");
			}
		}
		if (onlyLocation) {
			return location;
		} else {
			return macro {
				final obj:$attributeType = {
					name: $v{v.name},
					type: ${getAttributeTypeExpr(v.type, v.pos)},
					location: $location
				}
				obj;
			}
		}
	}

	static function generateConstExpr(v:GVar):Expr {
		return switch v.kind {
			case Global(Const(cvalue)):
				cvalue.toExpr();
			case _:
				throw ierror(macro "internal error");
		}
	}

	static function generateConstsFields(uniforms:Array<GVar>):Array<Field> {
		return [
			{
				name: "consts",
				access: [APublic, AStatic, AFinal],
				kind: FVar(null, {
					expr: EObjectDecl(uniforms.map(v -> {
						field: v.name,
						expr: replacePos(generateConstExpr(v), v.pos),
						quotes: Unquoted
					})),
					pos: Context.currentPos()
				}),
				pos: Context.currentPos()
			},
			{
				name: "c",
				doc: "shortcut for `consts`",
				access: [APublic, AStatic, AFinal],
				kind: FVar(null, {
					expr: EObjectDecl(uniforms.map(v -> {
						field: v.name,
						expr: replacePos(generateConstExpr(v), v.pos),
						quotes: Unquoted
					})),
					pos: Context.currentPos()
				}),
				pos: Context.currentPos()
			}
		];
	}

	static function generateUniformsFields(uniforms:Array<GVar>):Array<Field> {
		return [
			{
				name: "uniforms",
				access: [APublic, AStatic, AFinal],
				kind: FVar(null, {
					expr: EObjectDecl(uniforms.map(v -> {
						field: v.name,
						expr: replacePos(generateUniformExpr(v.type, macro $v{v.name}, v.pos, false), v.pos),
						quotes: Unquoted
					})),
					pos: Context.currentPos()
				}),
				pos: Context.currentPos()
			},
			{
				name: "u",
				doc: "shortcut for `uniforms.*.name`",
				access: [APublic, AStatic, AFinal],
				kind: FVar(null, {
					expr: EObjectDecl(uniforms.map(v -> {
						field: v.name,
						expr: replacePos(generateUniformExpr(v.type, macro $v{v.name}, v.pos, true), v.pos),
						quotes: Unquoted
					})),
					pos: Context.currentPos()
				}),
				pos: Context.currentPos()
			}
		];
	}

	static function generateAttributesFields(attributes:Array<GVar>):Array<Field> {
		return [
			{
				name: "attributes",
				access: [APublic, AStatic, AFinal],
				kind: FVar(null, {
					expr: EObjectDecl(attributes.map(v -> {
						field: v.name,
						expr: replacePos(generateAttributeExpr(v, false), v.pos),
						quotes: Unquoted
					})),
					pos: Context.currentPos()
				}),
				pos: Context.currentPos()
			},
			{
				name: "a",
				doc: "shortcut for `attributes.*.location`",
				access: [APublic, AStatic, AFinal],
				kind: FVar(null, {
					expr: EObjectDecl(attributes.map(v -> {
						field: v.name,
						expr: replacePos(generateAttributeExpr(v, true), v.pos),
						quotes: Unquoted
					})),
					pos: Context.currentPos()
				}),
				pos: Context.currentPos()
			}
		];
	}

	static final errorMap:Map<String, Bool> = [];

	static function tryToBuild(fieldsMutator:(fields:Array<Field>) -> Void):Array<Field> {
		final name = Context.getLocalClass().get().name;
		// trace("<" + name + ">");
		final st = Timer.stamp();
		final fields = Context.getBuildFields();
		try {
			fieldsMutator(fields);
		} catch (e:GError) {
			addError(e.message, e.pos);
		}
		final errors = errors.copy();
		errors.reverse();
		for (e in errors) {
			Context.onAfterTyping(_ -> {
				final key = e.pos + e.message;
				if (errorMap.exists(key)) // avoid massive errors shown in the same place
					return;
				errorMap[key] = true;
				Context.error(e.message, e.pos);
			});
		}
		final en = Timer.stamp();
		// trace("</" + name + " " + (en - st) * 1000 + " ms>");
		return fields;
	}
}
#end

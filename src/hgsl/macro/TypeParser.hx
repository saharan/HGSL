package hgsl.macro;

import haxe.macro.Context;

#if macro
private typedef TypeContext = {
	paths:Array<String>,
	inArray:Bool,
	inArrayDirect:Bool,
	inStruct:Bool
}

class TypeParser {
	static final cache:Map<String, GType> = [];

	static function makePathFull(t:ComplexType):ComplexType {
		return switch t {
			case TFunction(args, ret):
				return TFunction(args.map(makePathFull), makePathFull(ret));
			case TNamed(n, t):
				return TNamed(n, makePathFull(t));
			case TParent(t):
				return TParent(makePathFull(t));
			case TOptional(t):
				return TOptional(makePathFull(t));
			case _:
				return t.toType().toComplexType();
		}
	}

	public static function parseType(t:ComplexType, pos:Position, allowVoid:Bool = false, context:TypeContext = null):GType {
		if (context == null) {
			context = {
				paths: [],
				inArray: false,
				inArrayDirect: false,
				inStruct: false
			}
		}
		switch t {
			case TPath(p) if (p.params != null && p.params.length > 0):
				// avoid evaluating type parameters at this stage
				final nameInfo = switch Context.getType(p.pack.concat(p.sub != null ? [p.name, p.sub] : [p.name]).join(".")).follow() {
					case TInst(_.get() => t, _):
						{
							module: t.module,
							name: t.name
						}
					case TAbstract(_.get() => t, _):
						{
							module: t.module,
							name: t.name
						}
					case _:
						null;
				};
				if (nameInfo != null) {
					final path = nameInfo.module.split(".");
					final name = nameInfo.name;
					t = TPath({
						pack: path.slice(0, -1),
						name: path.last(),
						params: p.params,
						sub: name == path.last() ? null : name
					});
				}
			case _:
				t = makePathFull(t); // get a complete path
		}
		final str = t.toString();
		if (cache.exists(str))
			return cache[str];
		final res = switch t {
			case TPath(p):
				switch [p.pack.concat([p.name]).join("."), p.sub] {
					case [ARRAY_NAME, null]:
						addError("std.Array is not supported. use " + TYPES_MODULE_PATH + "." + ARRAY_NAME + " instead", pos);
						TVoid;
					case [STD_TYPES_MODULE, INT_NAME]:
						addError("StdTypes.Int is not supported. use " + TYPES_MODULE_PATH + "." + INT_NAME + " instead", pos);
						TVoid;
					case [UINT_NAME, null]:
						addError("std.UInt is not supported. use " + TYPES_MODULE_PATH + "." + UINT_NAME + " instead", pos);
						TVoid;
					case [STD_TYPES_MODULE, FLOAT_NAME]:
						addError("StdTypes.Float is not supported. use " + TYPES_MODULE_PATH + "." + FLOAT_NAME + " instead", pos);
						TVoid;
					case [STD_TYPES_MODULE, BOOL_NAME]:
						addError("StdTypes.Int is not supported. use " + TYPES_MODULE_PATH + "." + BOOL_NAME + " instead", pos);
						TVoid;
					case [STD_TYPES_MODULE, VOID_NAME]:
						if (!allowVoid)
							addError("Void is not allowed here", pos);
						TVoid;
					case [TYPES_MODULE_PATH, FLOAT_NAME]:
						TFloat;
					case [TYPES_MODULE_PATH, VEC2_NAME]:
						TVec2;
					case [TYPES_MODULE_PATH, VEC3_NAME]:
						TVec3;
					case [TYPES_MODULE_PATH, VEC4_NAME]:
						TVec4;
					case [TYPES_MODULE_PATH, INT_NAME]:
						TInt;
					case [TYPES_MODULE_PATH, IVEC2_NAME]:
						TIVec2;
					case [TYPES_MODULE_PATH, IVEC3_NAME]:
						TIVec3;
					case [TYPES_MODULE_PATH, IVEC4_NAME]:
						TIVec4;
					case [TYPES_MODULE_PATH, UINT_NAME]:
						TUInt;
					case [TYPES_MODULE_PATH, UVEC2_NAME]:
						TUVec2;
					case [TYPES_MODULE_PATH, UVEC3_NAME]:
						TUVec3;
					case [TYPES_MODULE_PATH, UVEC4_NAME]:
						TUVec4;
					case [TYPES_MODULE_PATH, BOOL_NAME]:
						TBool;
					case [TYPES_MODULE_PATH, BVEC2_NAME]:
						TBVec2;
					case [TYPES_MODULE_PATH, BVEC3_NAME]:
						TBVec3;
					case [TYPES_MODULE_PATH, BVEC4_NAME]:
						TBVec4;
					case [TYPES_MODULE_PATH, MAT2_NAME]:
						TMat2x2;
					case [TYPES_MODULE_PATH, MAT3_NAME]:
						TMat3x3;
					case [TYPES_MODULE_PATH, MAT4_NAME]:
						TMat4x4;
					case [TYPES_MODULE_PATH, MAT2X3_NAME]:
						TMat2x3;
					case [TYPES_MODULE_PATH, MAT3X2_NAME]:
						TMat3x2;
					case [TYPES_MODULE_PATH, MAT2X4_NAME]:
						TMat2x4;
					case [TYPES_MODULE_PATH, MAT4X2_NAME]:
						TMat4x2;
					case [TYPES_MODULE_PATH, MAT3X4_NAME]:
						TMat3x4;
					case [TYPES_MODULE_PATH, MAT4X3_NAME]:
						TMat4x3;
					case [TYPES_MODULE_PATH, SAMPLER2D_NAME]:
						TSampler2D;
					case [TYPES_MODULE_PATH, SAMPLER3D_NAME]:
						TSampler3D;
					case [TYPES_MODULE_PATH, SAMPLERCUBE_NAME]:
						TSamplerCube;
					case [TYPES_MODULE_PATH, SAMPLERCUBESHADOW_NAME]:
						TSamplerCubeShadow;
					case [TYPES_MODULE_PATH, SAMPLER2DSHADOW_NAME]:
						TSampler2DShadow;
					case [TYPES_MODULE_PATH, SAMPLER2DARRAY_NAME]:
						TSampler2DArray;
					case [TYPES_MODULE_PATH, SAMPLER2DARRAYSHADOW_NAME]:
						TSampler2DArrayShadow;
					case [TYPES_MODULE_PATH, ISAMPLER2D_NAME]:
						TISampler2D;
					case [TYPES_MODULE_PATH, ISAMPLER3D_NAME]:
						TISampler3D;
					case [TYPES_MODULE_PATH, ISAMPLERCUBE_NAME]:
						TISamplerCube;
					case [TYPES_MODULE_PATH, ISAMPLER2DARRAY_NAME]:
						TISampler2DArray;
					case [TYPES_MODULE_PATH, USAMPLER2D_NAME]:
						TUSampler2D;
					case [TYPES_MODULE_PATH, USAMPLER3D_NAME]:
						TUSampler3D;
					case [TYPES_MODULE_PATH, USAMPLERCUBE_NAME]:
						TUSamplerCube;
					case [TYPES_MODULE_PATH, USAMPLER2DARRAY_NAME]:
						TUSampler2DArray;
					case [TYPES_MODULE_PATH, ARRAY_NAME]:
						if (context.inArrayDirect)
							addError("multidimensional array is not supported", pos);
						final params = p.params;
						if (params.length != 2) {
							addError("invalid number of parameters", pos);
							TVoid;
						} else {
							final size:ArraySize = switch params[1] {
								case TPExpr(_.expr => EConst(CInt(Std.parseInt(_) => count))):
									if (count.checkArraySize(pos)) {
										Resolved(count);
									} else {
										null;
									}
								case TPType(TPath(p)):
									Delayed(p.toPath().toExpr(pos));
								case _:
									addError("invalid array size: " + params[1], pos);
									null;
							}
							if (size == null) {
								TVoid;
							} else {
								switch params[0] {
									case TPType(t):
										final type = parseType(t, pos, false, {
											paths: context.paths,
											inArray: true,
											inArrayDirect: true,
											inStruct: context.inStruct
										});
										TArray(type, size);
									case _:
										addError("invalid array type", pos);
										TVoid;
								}
							}
						}
					case _: // may be a struct
						final t = t.toType();
						final type = switch t {
							case TInst(_.get() => t, _) if (t.superClass != null && t.superClass.t.get().module == STRUCT_MODULE_PATH):
								switch t.fields.get() {
									case [{
										name: "struct",
										type: type
									}]:
										parseType(type.toComplexType(), t.pos, false, context);
									case _:
										addError("recursion in structure fields found", pos);
										TVoid;
								}
							case TType(_.get() => def, _): // typedef found, try following it
								switch t.follow() {
									case TAnonymous(_.get() => a):
										addError("typedef for anonymous structure is not supported; use " + STRUCT_MODULE_PATH +
											" instead", def.pos);
										TVoid;
									case type:
										parseType(type.toComplexType(), pos, false, context);
								}
							case _:
								null;
						}
						if (type == null) {
							addError("unsupported type: " + t.toString(), pos);
							TVoid;
						} else {
							type;
						}
				}
			case TAnonymous(fields):
				if (fields.length == 0) {
					addError("structure must not be empty", pos);
					TVoid;
				} else {
					// the order of the fields might be messed up, sort by actual positions
					fields.sort((a, b) -> Context.getPosInfos(a.pos).min - Context.getPosInfos(b.pos).min);
					final firstPos = Context.getPosInfos(fields[0].pos);
					final path = firstPos.file + ";" + firstPos.min + ";" + firstPos.max;
					if (context.paths.indexOf(path) != -1) {
						addError("recursion in structure fields found", pos);
						TVoid;
					} else {
						final anonFields = [];
						for (field in fields) {
							final pos = field.pos;
							switch field.kind {
								case FVar(t, _) | FProp("default", "default", t, _):
									if (t == null) {
										addError("type must be specified", pos);
									} else {
										final name = field.name;
										final type = parseType(t, field.pos, false, {
											paths: context.paths.concat([path]),
											inArray: context.inArray,
											inArrayDirect: false,
											inStruct: true
										});
										anonFields.push({
											name: name,
											type: type,
											pos: field.pos
										});
									}
								case FFun(_):
									addError("structure cannot have functions", pos);
								case FProp(_):
									addError("access modifiers must be default", pos);
							}
						}
						TStruct(anonFields);
					}
				}
			case TFunction(args, ret):
				if (context.inArray || context.inStruct) {
					addError("cannot use function type inside an array or struct", pos);
					TVoid;
				} else {
					try {
						TFunc({
							args: args.mapi((i, arg) -> switch arg {
								case TNamed(n, t):
									{
										name: n,
										type: parseType(t, pos, false, {
											paths: context.paths,
											inArray: context.inArray,
											inArrayDirect: false,
											inStruct: context.inStruct
										})
									}
								case _:
									{
										name: "arg" + i,
										type: parseType(arg, pos, false, {
											paths: context.paths,
											inArray: context.inArray,
											inArrayDirect: false,
											inStruct: context.inStruct
										})
									}
							}),
							ret: parseType(ret, pos, true, {
								paths: context.paths,
								inArray: context.inArray,
								inArrayDirect: false,
								inStruct: context.inStruct
							})
						});
					} catch (e:GError) {
						addError(e.message, e.pos);
						TVoid;
					}
				}
			case TParent(t):
				parseType(t, pos, allowVoid, context);
			case _:
				addError("unsupported type: " + t.toString(), pos);
				TVoid;
		}
		cache[str] = res;
		return res;
	}
}
#end

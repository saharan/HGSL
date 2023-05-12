package hgsl.macro;

import haxe.Exception;
import haxe.macro.Context;

#if macro
class Tools {
	public static function zip<A, B, C>(a:Array<A>, b:Array<B>, f:(a:A, b:B) -> C):Array<C> {
		final n = a.length;
		if (n != b.length)
			throw "array sizes must be the same";
		return [for (i in 0...n) f(a[i], b[i])];
	}

	public static function all(a:Array<Bool>):Bool {
		return a.foreach(x -> x);
	}

	public static function any(a:Array<Bool>):Bool {
		return a.exists(x -> x);
	}

	public static function repeat<A>(a:A, num:Int):Array<A> {
		return [for (i in 0...num) a];
	}

	public static function last<A>(a:Array<A>):A {
		final n = a.length;
		if (n == 0)
			throw "array is empty";
		return a[n - 1];
	}

	public static function toComplexType(t:GType):ComplexType {
		final params = switch t {
			case TArray(type, count):
				[TPType(type.toComplexType()), TPExpr(macro $v{count})];
			case _:
				null;
		}
		return switch t {
			case TVoid:
				TPath({pack: [], name: STD_TYPES_MODULE, sub: VOID_NAME});
			case TFloat:
				TPath({pack: BASE_PACK, name: TYPES_MODULE_NAME, sub: FLOAT_NAME});
			case TVec2:
				TPath({pack: BASE_PACK, name: TYPES_MODULE_NAME, sub: VEC2_NAME});
			case TVec3:
				TPath({pack: BASE_PACK, name: TYPES_MODULE_NAME, sub: VEC3_NAME});
			case TVec4:
				TPath({pack: BASE_PACK, name: TYPES_MODULE_NAME, sub: VEC4_NAME});
			case TInt:
				TPath({pack: BASE_PACK, name: TYPES_MODULE_NAME, sub: INT_NAME});
			case TIVec2:
				TPath({pack: BASE_PACK, name: TYPES_MODULE_NAME, sub: IVEC2_NAME});
			case TIVec3:
				TPath({pack: BASE_PACK, name: TYPES_MODULE_NAME, sub: IVEC3_NAME});
			case TIVec4:
				TPath({pack: BASE_PACK, name: TYPES_MODULE_NAME, sub: IVEC4_NAME});
			case TUInt:
				TPath({pack: BASE_PACK, name: TYPES_MODULE_NAME, sub: UINT_NAME});
			case TUVec2:
				TPath({pack: BASE_PACK, name: TYPES_MODULE_NAME, sub: UVEC2_NAME});
			case TUVec3:
				TPath({pack: BASE_PACK, name: TYPES_MODULE_NAME, sub: UVEC3_NAME});
			case TUVec4:
				TPath({pack: BASE_PACK, name: TYPES_MODULE_NAME, sub: UVEC4_NAME});
			case TBool:
				TPath({pack: BASE_PACK, name: TYPES_MODULE_NAME, sub: BOOL_NAME});
			case TBVec2:
				TPath({pack: BASE_PACK, name: TYPES_MODULE_NAME, sub: BVEC2_NAME});
			case TBVec3:
				TPath({pack: BASE_PACK, name: TYPES_MODULE_NAME, sub: BVEC3_NAME});
			case TBVec4:
				TPath({pack: BASE_PACK, name: TYPES_MODULE_NAME, sub: BVEC4_NAME});
			case TMat2x2:
				TPath({pack: BASE_PACK, name: TYPES_MODULE_NAME, sub: MAT2_NAME});
			case TMat3x3:
				TPath({pack: BASE_PACK, name: TYPES_MODULE_NAME, sub: MAT3_NAME});
			case TMat4x4:
				TPath({pack: BASE_PACK, name: TYPES_MODULE_NAME, sub: MAT4_NAME});
			case TMat2x3:
				TPath({pack: BASE_PACK, name: TYPES_MODULE_NAME, sub: MAT2X3_NAME});
			case TMat3x2:
				TPath({pack: BASE_PACK, name: TYPES_MODULE_NAME, sub: MAT3X2_NAME});
			case TMat2x4:
				TPath({pack: BASE_PACK, name: TYPES_MODULE_NAME, sub: MAT2X4_NAME});
			case TMat4x2:
				TPath({pack: BASE_PACK, name: TYPES_MODULE_NAME, sub: MAT4X2_NAME});
			case TMat3x4:
				TPath({pack: BASE_PACK, name: TYPES_MODULE_NAME, sub: MAT3X4_NAME});
			case TMat4x3:
				TPath({pack: BASE_PACK, name: TYPES_MODULE_NAME, sub: MAT4X3_NAME});
			case TSampler2D:
				TPath({pack: BASE_PACK, name: TYPES_MODULE_NAME, sub: SAMPLER2D_NAME});
			case TSampler3D:
				TPath({pack: BASE_PACK, name: TYPES_MODULE_NAME, sub: SAMPLER3D_NAME});
			case TSamplerCube:
				TPath({pack: BASE_PACK, name: TYPES_MODULE_NAME, sub: SAMPLERCUBE_NAME});
			case TSamplerCubeShadow:
				TPath({pack: BASE_PACK, name: TYPES_MODULE_NAME, sub: SAMPLERCUBESHADOW_NAME});
			case TSampler2DShadow:
				TPath({pack: BASE_PACK, name: TYPES_MODULE_NAME, sub: SAMPLER2DSHADOW_NAME});
			case TSampler2DArray:
				TPath({pack: BASE_PACK, name: TYPES_MODULE_NAME, sub: SAMPLER2DARRAY_NAME});
			case TSampler2DArrayShadow:
				TPath({pack: BASE_PACK, name: TYPES_MODULE_NAME, sub: SAMPLER2DARRAYSHADOW_NAME});
			case TISampler2D:
				TPath({pack: BASE_PACK, name: TYPES_MODULE_NAME, sub: ISAMPLER2D_NAME});
			case TISampler3D:
				TPath({pack: BASE_PACK, name: TYPES_MODULE_NAME, sub: ISAMPLER3D_NAME});
			case TISamplerCube:
				TPath({pack: BASE_PACK, name: TYPES_MODULE_NAME, sub: ISAMPLERCUBE_NAME});
			case TISampler2DArray:
				TPath({pack: BASE_PACK, name: TYPES_MODULE_NAME, sub: ISAMPLER2DARRAY_NAME});
			case TUSampler2D:
				TPath({pack: BASE_PACK, name: TYPES_MODULE_NAME, sub: USAMPLER2D_NAME});
			case TUSampler3D:
				TPath({pack: BASE_PACK, name: TYPES_MODULE_NAME, sub: USAMPLER3D_NAME});
			case TUSamplerCube:
				TPath({pack: BASE_PACK, name: TYPES_MODULE_NAME, sub: USAMPLERCUBE_NAME});
			case TUSampler2DArray:
				TPath({pack: BASE_PACK, name: TYPES_MODULE_NAME, sub: USAMPLER2DARRAY_NAME});
			case TStruct(fields):
				TAnonymous(fields.map(function(field:GStructField):Field {
					return {
						name: field.name,
						kind: FieldType.FVar(toComplexType(field.type)),
						pos: field.pos
					}
				}));
			case TArray(type, size):
				TPath({
					pack: BASE_PACK,
					name: TYPES_MODULE_NAME,
					sub: ARRAY_NAME,
					params: [TPType(toComplexType(type)), switch size {
						case Resolved(count):
							TPExpr(macro $v{count});
						case Delayed(path):
							TPExpr(path);
					}]
				});
			case TFunc(f):
				TFunction(f.args.map(arg -> TNamed(arg.name, toComplexType(arg.type))), toComplexType(f.ret));
			case TFuncs(_):
				throw ierror(macro "unexpected functions type");
		}
	}

	public static function toFuncsType(funcs:Array<GFunc>):GType {
		return TFuncs(funcs.map(f -> {
			args: f.args.map(arg -> {name: arg.name, type: arg.type}),
			ret: f.type
		}));
	}

	public static function toGLSLTypeOfName(type:GType, name:String, parser:Parser):String {
		final glslType = toGLSLType(type, parser);
		return glslType[0] + " " + name + glslType[1];
	}

	public static function toGLSLType(type:GType, parser:Parser):TypeStringPair {
		return switch type {
			case TVoid:
				["void", ""];
			case TFloat:
				["float", ""];
			case TVec2:
				["vec2", ""];
			case TVec3:
				["vec3", ""];
			case TVec4:
				["vec4", ""];
			case TInt:
				["int", ""];
			case TIVec2:
				["ivec2", ""];
			case TIVec3:
				["ivec3", ""];
			case TIVec4:
				["ivec4", ""];
			case TUInt:
				["uint", ""];
			case TUVec2:
				["uvec2", ""];
			case TUVec3:
				["uvec3", ""];
			case TUVec4:
				["uvec4", ""];
			case TBool:
				["bool", ""];
			case TBVec2:
				["bvec2", ""];
			case TBVec3:
				["bvec3", ""];
			case TBVec4:
				["bvec4", ""];
			case TMat2x2:
				["mat2", ""];
			case TMat3x3:
				["mat3", ""];
			case TMat4x4:
				["mat4", ""];
			case TMat2x3:
				["mat2x3", ""];
			case TMat3x2:
				["mat3x2", ""];
			case TMat2x4:
				["mat2x4", ""];
			case TMat4x2:
				["mat4x2", ""];
			case TMat3x4:
				["mat3x4", ""];
			case TMat4x3:
				["mat4x3", ""];
			case TSampler2D:
				["sampler2D", ""];
			case TSampler3D:
				["sampler3D", ""];
			case TSamplerCube:
				["samplerCube", ""];
			case TSamplerCubeShadow:
				["samplerCubeShadow", ""];
			case TSampler2DShadow:
				["sampler2DShadow", ""];
			case TSampler2DArray:
				["sampler2DArray", ""];
			case TSampler2DArrayShadow:
				["sampler2DArrayShadow", ""];
			case TISampler2D:
				["isampler2D", ""];
			case TISampler3D:
				["isampler3D", ""];
			case TISamplerCube:
				["isamplerCube", ""];
			case TISampler2DArray:
				["isampler2DArray", ""];
			case TUSampler2D:
				["usampler2D", ""];
			case TUSampler3D:
				["usampler3D", ""];
			case TUSamplerCube:
				["usamplerCube", ""];
			case TUSampler2DArray:
				["usampler2DArray", ""];
			case TStruct(fields):
				[parser.getUniqueStructName(fields), ""];
			case TArray(type, size):
				[switch toGLSLType(type, parser) {
					case [type, ""]:
						type;
					case [_, _]:
						throw ierror(macro "multidimensional array is not supported");
					case _:
						throw ierror(macro "internal error");
				}, "[" + (switch size {
					case Resolved(count):
						count;
					case Delayed(_):
						throw ierror(macro "array size must have been resolved");
				}) + "]"];
			case TFunc(_) | TFuncs(_):
				throw ierror(macro "function type cannot be converted into a GLSL type");
		}
	}

	overload extern public static inline function toPath(classType:ClassType):FieldChain {
		final path = classType.module.split(".");
		if (path.last() != classType.name) {
			path.push(classType.name);
		}
		return path;
	}

	overload extern public static inline function toPath(tp:TypePath):FieldChain {
		final path = tp.pack.copy();
		path.push(tp.name);
		if (tp.sub != null)
			path.push(tp.sub);
		return path;
	}

	public static function checkArraySize(count:Int, pos:Position):Bool {
		return if (count <= 0) {
			addError("array size must be positive", pos);
			false;
		} else if (count > MAX_ARRAY_SIZE) {
			addError("array size is too large", pos);
			false;
		} else {
			true;
		}
	}

	overload extern public static inline function toString(type:GType):String {
		return gtypeToString(type);
	}

	overload extern public static inline function toString(op:Unop):String {
		return unopToString(op);
	}

	overload extern public static inline function toString(op:Binop):String {
		return binopToString(op);
	}

	public static function isFunctionType(type:GType):Bool {
		return switch type {
			case TFunc(_) | TFuncs(_):
				true;
			case _:
				false;
		}
	}

	public static function match(type:GFuncType, func:GFunc):Bool {
		return type.args.length == func.args.length && type.args.zip(func.args, (a, b) -> a.type.equals(b.type))
			.all() && type.ret.equals(func.type);
	}

	static function gtypeToString(type:GType):String {
		return switch type {
			case TVoid:
				"void";
			case TFloat:
				"float";
			case TVec2:
				"vec2";
			case TVec3:
				"vec3";
			case TVec4:
				"vec4";
			case TInt:
				"int";
			case TIVec2:
				"ivec2";
			case TIVec3:
				"ivec3";
			case TIVec4:
				"ivec4";
			case TUInt:
				"uint";
			case TUVec2:
				"uvec2";
			case TUVec3:
				"uvec3";
			case TUVec4:
				"uvec4";
			case TBool:
				"bool";
			case TBVec2:
				"bvec2";
			case TBVec3:
				"bvec3";
			case TBVec4:
				"bvec4";
			case TMat2x2:
				"mat2";
			case TMat3x3:
				"mat3";
			case TMat4x4:
				"mat4";
			case TMat2x3:
				"mat2x3";
			case TMat3x2:
				"mat3x2";
			case TMat2x4:
				"mat2x4";
			case TMat4x2:
				"mat4x2";
			case TMat3x4:
				"mat3x4";
			case TMat4x3:
				"mat4x3";
			case TSampler2D:
				"sampler2D";
			case TSampler3D:
				"sampler3D";
			case TSamplerCube:
				"samplerCube";
			case TSamplerCubeShadow:
				"samplerCubeShadow";
			case TSampler2DShadow:
				"sampler2DShadow";
			case TSampler2DArray:
				"sampler2DArray";
			case TSampler2DArrayShadow:
				"sampler2DArrayShadow";
			case TISampler2D:
				"isampler2D";
			case TISampler3D:
				"isampler3D";
			case TISamplerCube:
				"isamplerCube";
			case TISampler2DArray:
				"isampler2DArray";
			case TUSampler2D:
				"usampler2D";
			case TUSampler3D:
				"usampler3D";
			case TUSamplerCube:
				"usamplerCube";
			case TUSampler2DArray:
				"usampler2DArray";
			case TStruct(fields):
				"{ " + fields.map(field -> field.name + ": " + gtypeToString(field.type)).join(", ") + " }";
			case TArray(type, size):
				gtypeToString(type) + "[" + (switch size {
					case Resolved(count):
						"" + count;
					case Delayed(_):
						"<unknown>";
				}) + "]";
			case TFunc(f):
				"(" + f.args.map(arg -> arg.name + ":" + gtypeToString(arg.type)).join(", ") + ") -> " + gtypeToString(f.ret);
			case TFuncs(fs):
				"[" + fs.map(f -> "(" + f.args.map(arg -> arg.name + ":" + gtypeToString(arg.type))
					.join(", ") + ") -> " + gtypeToString(f.ret))
					.join(", ") + "]";
		}
	}

	static function unopToString(op:Unop):String {
		return switch op {
			case OpIncrement:
				"++";
			case OpDecrement:
				"--";
			case OpNot:
				"!";
			case OpNeg:
				"-";
			case OpNegBits:
				"~";
			case OpSpread:
				"...";
		}
	}

	static function binopToString(op:Binop):String {
		return switch op {
			case OpAdd:
				"+";
			case OpMult:
				"*";
			case OpDiv:
				"/";
			case OpSub:
				"-";
			case OpAssign:
				"=";
			case OpEq:
				"==";
			case OpNotEq:
				"!=";
			case OpGt:
				">";
			case OpGte:
				">=";
			case OpLt:
				"<";
			case OpLte:
				"<=";
			case OpAnd:
				"&";
			case OpOr:
				"|";
			case OpXor:
				"^";
			case OpBoolAnd:
				"&&";
			case OpBoolOr:
				"||";
			case OpShl:
				"<<";
			case OpShr:
				">>";
			case OpUShr:
				">>>";
			case OpMod:
				"%";
			case OpAssignOp(op):
				binopToString(op) + "=";
			case OpInterval:
				"...";
			case OpArrow:
				"=>";
			case OpIn:
				"in";
			case OpNullCoal:
				"??";
		}
	}

	public static function isMatrix(type:GType):Bool {
		return switch type {
			case TMat2x2 | TMat3x3 | TMat4x4 | TMat2x3 | TMat3x2 | TMat2x4 | TMat4x2 | TMat3x4 | TMat4x3:
				true;
			case _:
				false;
		}
	}

	public static function numComponents(type:GType):Int {
		return switch type {
			case TFloat:
				1;
			case TVec2:
				2;
			case TVec3:
				3;
			case TVec4:
				4;
			case TInt:
				1;
			case TIVec2:
				2;
			case TIVec3:
				3;
			case TIVec4:
				4;
			case TUInt:
				1;
			case TUVec2:
				2;
			case TUVec3:
				3;
			case TUVec4:
				4;
			case TBool:
				1;
			case TBVec2:
				2;
			case TBVec3:
				3;
			case TBVec4:
				4;
			case TMat2x2:
				4;
			case TMat3x3:
				9;
			case TMat4x4:
				16;
			case TMat2x3:
				6;
			case TMat3x2:
				6;
			case TMat2x4:
				8;
			case TMat4x2:
				8;
			case TMat3x4:
				12;
			case TMat4x3:
				12;
			case _:
				0;
		}
	}

	static function replacePos(expr:Expr, pos:Position):Expr {
		var map:Expr -> Expr = null;
		map = e -> {
			final expr = e.map(map).expr;
			{
				expr: expr,
				pos: pos
			}
		}
		return map(expr);
	}

	static function typeExprAt(expr:Expr, pos:Position):TypedExpr {
		// trace("trying to type at " + pos);
		try {
			return Context.typeExpr(replacePos(expr, pos));
		} catch (e:Exception) {
			throw error(e.message, pos);
		}
	}

	static function resolveSwizzle(type:GInternalType, comps:String, pos:Position):GInternalType {
		final compList = switch comps.charAt(0) {
			case "x" | "y" | "z" | "w":
				"xyzw";
			case "r" | "g" | "b" | "a":
				"rgba";
			case "s" | "t" | "p" | "q":
				"stpq";
			case _:
				throw error("invalid swizzle component", pos);
		}
		var inDim = 0;
		final map = new Map<String, Bool>();
		final indices = [];
		var dupl = false;
		for (comp in comps.split("")) {
			if (map.exists(comp)) {
				dupl = true;
			} else {
				map[comp] = true;
			}
			final index = compList.indexOf(comp);
			if (index == -1)
				throw error("invalid swizzle component", pos);
			indices.push(index);
			final dim = index + 1;
			if (dim > inDim)
				inDim = dim;
		}
		final maxInDim = type.type.numComponents();
		if (inDim > maxInDim)
			throw error("invalid swizzling", pos);
		final outDim = comps.length;
		final outType = switch type.type {
			case TVec2 | TVec3 | TVec4:
				switch outDim {
					case 1:
						TFloat;
					case 2:
						TVec2;
					case 3:
						TVec3;
					case _:
						TVec4;
				}
			case TIVec2 | TIVec3 | TIVec4:
				switch outDim {
					case 1:
						TInt;
					case 2:
						TIVec2;
					case 3:
						TIVec3;
					case _:
						TIVec4;
				}
			case TUVec2 | TUVec3 | TUVec4:
				switch outDim {
					case 1:
						TUInt;
					case 2:
						TUVec2;
					case 3:
						TUVec3;
					case _:
						TUVec4;
				}
			case TBVec2 | TBVec3 | TBVec4:
				switch outDim {
					case 1:
						TBool;
					case 2:
						TBVec2;
					case 3:
						TBVec3;
					case _:
						TBVec4;
				}
			case _:
				throw error("swizzling is not supported for this type", pos);
		}
		final cvalue = switch type.cvalue {
			case null:
				null;
			case VVector(v):
				outDim == 1 ? VScalar(switch v {
					case VVec(v):
						VFloat(v.data[indices[0]]);
					case VIVec(v):
						VInt(v.data[indices[0]]);
					case VUVec(v):
						VUInt(v.data[indices[0]]);
					case VBVec(v):
						VBool(v.data[indices[0]]);
				}) : VVector(switch v {
					case VVec(v):
						VVec(v.getSwizzle(indices));
					case VIVec(v):
						VIVec(v.getSwizzle(indices));
					case VUVec(v):
						VUVec(v.getSwizzle(indices));
					case VBVec(v):
						VBVec(v.getSwizzle(indices));
				});
			case _:
				throw ierror(macro "constant types mismatch");
		}
		return {
			type: outType,
			lvalue: type.lvalue && !dupl,
			cvalue: cvalue
		}
	}

	public static function resolveFieldAccess(type:GInternalType, field:String, pos:Position):GInternalType {
		if (field == "length") {
			final fixedLength = switch type.type {
				case TVec2 | TIVec2 | TUVec2 | TBVec2 | TMat2x2 | TMat2x3 | TMat2x4:
					2;
				case TVec3 | TIVec3 | TUVec3 | TBVec3 | TMat3x3 | TMat3x2 | TMat3x4:
					3;
				case TVec4 | TIVec4 | TUVec4 | TBVec4 | TMat4x4 | TMat4x2 | TMat4x3:
					4;
				case TArray(_, Resolved(count)):
					count;
				case TArray(_, _):
					throw ierror(macro "array size must be resolved here");
				case _:
					null;
			}
			if (fixedLength != null)
				return {
					type: TInt,
					lvalue: false,
					cvalue: VScalar(VInt(fixedLength))
				}
		}
		switch type.type {
			case TVec2 | TVec3 | TVec4 | TIVec2 | TIVec3 | TIVec4 | TUVec2 | TUVec3 | TUVec4 | TBVec2 | TBVec3 | TBVec4:
				return resolveSwizzle(type, field, pos);
			case _:
		}
		final fieldNotFoundError = error("type " + type.type.toString() + " does not have field " + field, pos);
		return switch type.type {
			case TStruct(fields):
				switch fields.findIndex(f -> f.name == field) {
					case -1:
						throw fieldNotFoundError;
					case index:
						{
							type: fields[index].type,
							lvalue: type.lvalue,
							cvalue: switch type.cvalue {
								case null:
									null;
								case VStruct(_[index] => v):
									if (v.name != field)
										throw ierror(macro "constant struct field names mismatch");
									v.value;
								case _:
									throw ierror(macro "constant value types mismatch");
							}
						}
				}
			case _:
				throw fieldNotFoundError;
		}
	}

	public static function resolveArrayAccess(type1:GInternalType, type2:GInternalType, pos:Position):GInternalType {
		if (!type2.type.match(TInt | TUInt))
			throw error("only int and uint can be used for the index of an array access", pos);
		final cindex = switch type2.cvalue {
			case null:
				null;
			case VScalar(VInt(v)):
				v;
			case VScalar(VUInt(v)):
				v;
			case _:
				throw ierror(macro "constant value types mismatch");
		}
		final size = switch type1.type {
			case TVec2 | TIVec2 | TUVec2 | TBVec2:
				2;
			case TVec3 | TIVec3 | TUVec3 | TBVec3:
				3;
			case TVec4 | TIVec4 | TUVec4 | TBVec4:
				4;
			case TMat2x2 | TMat2x3 | TMat2x4:
				2;
			case TMat3x2 | TMat3x3 | TMat3x4:
				3;
			case TMat4x2 | TMat4x3 | TMat4x4:
				4;
			case TArray(_, Resolved(count)):
				count;
			case TArray(_):
				throw error("array size must be resolved before any access", pos);
			case _:
				throw error(type1.type.toString() + " cannot be accessed as an array", pos);
		}
		if (cindex != null && (cindex < 0 || cindex >= size)) {
			throw error("array index out of bounds, size: " + size + ", index: " + cindex, pos);
		}
		final resType = switch type1.type {
			case TVec2 | TVec3 | TVec4:
				TFloat;
			case TIVec2 | TIVec3 | TIVec4:
				TInt;
			case TUVec2 | TUVec3 | TUVec4:
				TUInt;
			case TBVec2 | TBVec3 | TBVec4:
				TBool;
			case TMat2x2 | TMat3x2 | TMat4x2:
				TVec2;
			case TMat2x3 | TMat3x3 | TMat4x3:
				TVec3;
			case TMat2x4 | TMat4x4 | TMat3x4:
				TVec4;
			case TArray(type, _):
				type;
			case _:
				throw ierror(macro "internal error");
		}
		final cvalue = if (cindex == null) {
			null;
		} else {
			switch type1.cvalue {
				case null:
					null;
				case VVector(v):
					VScalar(switch v {
						case VVec(v):
							VFloat(v.data[cindex]);
						case VIVec(v):
							VInt(v.data[cindex]);
						case VUVec(v):
							VUInt(v.data[cindex]);
						case VBVec(v):
							VBool(v.data[cindex]);
					});
				case VMatrix(VMat(v)):
					VVector(VVec(v.getCol(cindex)));
				case VArray(vs):
					vs[cindex];
				case _:
					throw ierror(macro "constant value types mismatch");
			}
		}
		return {
			type: resType,
			lvalue: type1.lvalue,
			cvalue: cvalue
		}
	}

	overload extern public static inline function toGType(type:ComplexType, pos:Position, allowVoid:Bool = false):GType {
		return TypeParser.parseType(type, pos, allowVoid);
	}

	overload extern public static inline function toGType(e:ElementType):GType {
		return switch e {
			case TFloat:
				TFloat;
			case TInt:
				TInt;
			case TUInt:
				TUInt;
			case TBool:
				TBool;
		}
	}

	public static function toFuncType(f:GFunc):GFuncType {
		return {
			args: f.args.map(arg -> {
				name: arg.name,
				type: arg.type
			}),
			ret: f.type
		}
	}

	public static function toType(f:GFunc):GType {
		return TFunc(f.toFuncType());
	}

	public static function funcTypeEquals(a:GFuncType, b:GFuncType):Bool {
		return a.args.length == b.args.length && a.args.zip(b.args, (a, b) -> a.type.equals(b.type)).all() && a.ret.equals(b.ret);
	}

	overload public extern static inline function canImplicitlyCast(src:GType, dst:GType):Bool {
		return canImplicitlyCastImpl(src, dst);
	}

	static function canImplicitlyCastImpl(src:GType, dst:GType):Bool {
		return src.equals(dst) || switch [src, dst] {
			case [TInt, TUInt] | [TIVec2, TUVec2] | [TIVec3, TUVec3] | [TIVec4, TUVec4]: // int -> uint
				true;
			case [TInt, TFloat] | [TIVec2, TVec2] | [TIVec3, TVec3] | [TIVec4, TVec4]: // int -> float
				true;
			case [TUInt, TFloat] | [TUVec2, TVec2] | [TUVec3, TVec3] | [TUVec4, TVec4]: // uint -> float
				true;
			case [_, TVoid]: // any -> void
				true;
			case [TFunc(srcf), TFunc(dstf)]:
				final retOk = canImplicitlyCastImpl(srcf.ret, dstf.ret); // covariant
				final argsOk = srcf.args.length == dstf.args.length && zip(srcf.args, dstf.args, (src,
						dst) -> canImplicitlyCastImpl(dst.type, src.type)).all(); // contravariant
				retOk && argsOk;
			case [TFuncs(fs), TFunc(dstf)]:
				fs.exists(srcf -> canImplicitlyCastImpl(TFunc(srcf), TFunc(dstf)));
			case _: // nope
				false;
		}
	}

	overload public extern static inline function canImplicitlyCast(src:GFuncType, dst:GFuncType):Bool {
		return canImplicitlyCastImpl(TFunc(src), TFunc(dst));
	}

	overload public extern static inline function canImplicitlyCast(src:GFunc, dst:GFuncType):Bool {
		return canImplicitlyCastImpl(TFunc(src.toFuncType()), TFunc(dst));
	}

	overload public extern static inline function canImplicitlyCast(src:GType, dst:GFuncArg):Bool {
		return if (dst.isRef) {
			src.equals(dst.type); // invariant
		} else {
			canImplicitlyCastImpl(src, dst.type);
		}
	}

	overload public extern static inline function canImplicitlyCast(src:GFuncArg, dst:GFuncArg):Bool {
		return if (src.isRef || dst.isRef) {
			src.type.equals(dst.type); // invariant
		} else {
			canImplicitlyCastImpl(src.type, dst.type);
		}
	}

	overload public extern static inline function canImplicitlyCast(src:Array<GType>, dst:Array<GType>):Bool {
		return if (src.length != dst.length) {
			false;
		} else {
			zip(src, dst, (s, d) -> canImplicitlyCast(s, d)).all();
		}
	}

	overload public extern static inline function canImplicitlyCast(src:Array<GType>, dst:Array<GFuncArg>):Bool {
		return if (src.length != dst.length) {
			false;
		} else {
			zip(src, dst, (s, d) -> canImplicitlyCast(s, d)).all();
		}
	}

	overload public extern static inline function canImplicitlyCast(src:Array<GFuncArg>, dst:Array<GFuncArg>):Bool {
		return if (src.length != dst.length) {
			false;
		} else {
			zip(src, dst, (s, d) -> canImplicitlyCast(s, d)).all();
		}
	}

	public static function computeOverloadCandidates(args:Array<GType>, candidates:Array<GFuncBase>):Array<Int> {
		final numArgs = args.length;
		final indieces = [for (i in 0...candidates.length) if (candidates[i].args.length == numArgs) i]; // filter by the number of args
		return switch indieces.find(i -> zip(args, candidates[i].args, (a, b) -> a.equals(b.type)).all()) { // check for an exact match
			case null:
				final possible = indieces.filter(i -> canImplicitlyCast(args, candidates[i].args));
				possible.filter(i -> possible.foreach(j -> {
					if (i == j) {
						true; // exclude self
					} else {
						!canImplicitlyCast(candidates[j].args, candidates[i].args); // i is no looser than j
					}
				}));
			case i:
				[i];
		}
	}

	public static function resolveOverload(args:Array<GType>, candidates:Array<GFuncBase>, pos:Position):Int {
		return switch computeOverloadCandidates(args, candidates) {
			case [f]:
				f;
			case []:
				var msg = "argument types: " + args.map(arg -> arg.toString()).join(", ");
				msg += "\ncandidates:\n" + candidates.map(f -> f.args.map(arg -> arg.type.toString()).join(", ")).join("\n");
				throw error("no suitable overload found\n" + msg, pos);
			case ambiguous:
				throw error("ambiguous overload, candidates: " + ambiguous.map(i -> "(" + candidates[i].args.map(arg -> arg.type.toString())
					.join(", ") + ")")
					.join(", "), pos);
		}
	}

	public static function toBuiltInFields(fields:Array<ClassField>):Array<GField> {
		final res:Array<GField> = [];
		for (field in fields.flatMap(field -> [field].concat(field.overloads.get()))) {
			final pos = field.pos;
			final meta = field.meta;
			final region = switch [meta.has(":vert"), meta.has(":frag")] {
				case [true, true]:
					throw error("invalid region specification", pos);
				case [true, false]:
					Vertex;
				case [false, true]:
					Fragment;
				case [false, false]:
					All;
			}
			if (meta.has(":ctor")) {
				switch field.type {
					case TFun(args, ret):
						res.push(FFunc({
							name: field.name,
							region: region,
							generic: false,
							type: ret.toComplexType().toGType(pos),
							args: [],
							kind: BuiltInConstructor,
							pos: pos,
							parsed: false
						}));
					case _:
						throw ierror(macro "internal error");
				}
				continue;
			}
			switch field.kind {
				case FVar(_):
					if (region == All) {
						throw error("invalid region specification", pos);
					}
					res.push(FVar({
						name: field.name,
						type: field.type.toComplexType().toGType(pos),
						kind: BuiltIn(switch region {
							case Vertex:
								field.isFinal ? VertexIn : VertexOut;
							case Fragment:
								field.isFinal ? FragmentIn : FragmentOut;
							case _:
								throw ierror(macro "internal error");
						}),
						pos: field.pos,
						field: null
					}));
				case FMethod(_):
					switch field.type {
						case TFun(args, ret):
							res.push(FFunc({
								name: field.name,
								region: region,
								generic: false,
								type: ret.toComplexType().toGType(pos, true),
								args: args.map(arg -> {
									if (arg.opt)
										addError("optional arguments are not supported", pos);
									{
										name: arg.name,
										type: arg.t.toComplexType().toGType(pos),
										isRef: false
									}
								}),
								kind: BuiltIn,
								pos: pos,
								parsed: false
							}));
						case _:
					}
			}
		}
		return res;
	}

	public static function implicitlyCastArguments(vs:Array<GInternalType>, args:Array<GFuncArg>):Array<GInternalType> {
		return zip(vs, args, (v, arg) -> if (v.type.equals(arg.type)) {
			v;
		} else {
			if (arg.isRef)
				throw ierror(macro "internal error");
			{
				type: arg.type,
				lvalue: false,
				cvalue: v.cvalue == null ? null : v.cvalue.castTo(arg.type.getElementType())
			}
		});
	}

	public static function evaluateConstValue(types:Array<GInternalType>, args:Array<GFuncArg>,
			constFunc:Null<(values:Array<ConstValue>) -> ConstValue>):Null<ConstValue> {
		return if (types.exists(t -> t.cvalue == null) || constFunc == null) {
			null;
		} else {
			constFunc(implicitlyCastArguments(types, args).map(t -> t.cvalue));
		}
	}

	static function resolveEquals(type1:GInternalType, type2:GInternalType, not:Bool,
			pos:Position):{args:Array<GFuncArg>, result:GInternalType} {
		final t1 = type1.type;
		final t2 = type2.type;
		final castToRhs = if (canImplicitlyCast(t1, t2)) {
			true;
		} else if (canImplicitlyCast(t2, t1)) {
			false;
		} else {
			throw error("cannot compare " + t1.toString() + " and " + t2.toString(), pos);
		}
		final args = [{
			name: "lhs",
			type: castToRhs ? t2 : t1,
			isRef: false
		}, {
			name: "rhs",
			type: castToRhs ? t2 : t1,
			isRef: false
		}];
		return {
			args: args,
			result: {
				type: TBool,
				lvalue: false,
				cvalue: evaluateConstValue([type1, type2], args, vs -> VScalar(VBool(vs[0].equals(vs[1]) != not)))
			}
		}
	}

	static function resolveAssign(type1:GInternalType, type2:GInternalType, pos:Position):{args:Array<GFuncArg>, result:GInternalType} {
		final t1 = type1.type;
		final t2 = type2.type;
		if (!type1.lvalue)
			throw error("cannot assign a value into a non-l-value", pos);
		if (!canImplicitlyCast(t2, t1))
			throw error("cannot assign " + t2.toString() + " to " + t1.toString(), pos);
		return {
			args: [{
				name: "lhs",
				type: t1,
				isRef: true
			}, {
				name: "rhs",
				type: t1,
				isRef: false
			}],
			result: type1
		}
	}

	public static function resolveBinop(type1:GInternalType, op:Binop, type2:GInternalType,
			pos:Position):{args:Array<GFuncArg>, result:GInternalType} {
		final t1 = type1.type;
		final t2 = type2.type;
		final isAssign = switch op {
			case OpEq | OpNotEq:
				return resolveEquals(type1, type2, op == OpNotEq, pos);
			case OpAssign:
				return resolveAssign(type1, type2, pos);
			case OpAssignOp(op2):
				op = op2;
				true;
			case _:
				false;
		}
		final bins = Operator.BIN_LIST.data.filter(bin -> bin.op == op);
		final bin = bins[resolveOverload([t1, t2], bins.map(bin -> bin.func), pos)];
		final func = bin.func;
		if (isAssign) {
			if (!type1.lvalue)
				throw error("cannot modify a non-l-value", pos);
			if (!canImplicitlyCast(func.type, t1))
				throw error("cannot assign " + func.type.toString() + " to " + t1.toString(), pos);
		}
		return {
			args: func.args,
			result: {
				type: func.type,
				lvalue: false,
				cvalue: evaluateConstValue([type1, type2], func.args, vs -> bin.constFunc(vs[0], vs[1]))
			}
		}
	}

	public static function resolveUnop(type:GInternalType, op:Unop, postFix:Bool, pos:Position):GInternalType {
		final t = type.type;
		final uns = Operator.UN_LIST.data.filter(un -> un.op == op && un.postFix == postFix);
		final un = uns[resolveOverload([t], uns.map(un -> un.func), pos)];
		final func = un.func;
		if (func.args[0].isRef && !type.lvalue) {
			throw error("cannot modify a non-l-value", pos);
		}
		return {
			type: func.type,
			lvalue: false,
			cvalue: evaluateConstValue([type], func.args, vs -> un.constFunc(vs[0]))
		}
	}

	public static function containsSampler(type:GType):Bool {
		return switch type {
			case TVoid | TFloat | TVec2 | TVec3 | TVec4 | TInt | TIVec2 | TIVec3 | TIVec4 | TUInt | TUVec2 | TUVec3 | TUVec4 | TBool |
				TBVec2 | TBVec3 | TBVec4 | TMat2x2 | TMat3x3 | TMat4x4 | TMat2x3 | TMat3x2 | TMat2x4 | TMat4x2 | TMat3x4 | TMat4x3:
				false;
			case TSampler2D | TSampler3D | TSamplerCube | TSamplerCubeShadow | TSampler2DShadow | TSampler2DArray |
				TSampler2DArrayShadow | TISampler2D | TISampler3D | TISamplerCube | TISampler2DArray | TUSampler2D | TUSampler3D |
				TUSamplerCube | TUSampler2DArray:
				true;
			case TStruct(fields):
				fields.map(f -> containsSampler(f.type)).has(true);
			case TArray(type, _):
				containsSampler(type);
			case TFunc(_) | TFuncs(_):
				false;
		}
	}

	public static function isOkayForAttribute(type:GType):Bool {
		return switch type {
			case TFloat | TVec2 | TVec3 | TVec4 | TInt | TIVec2 | TIVec3 | TIVec4 | TUInt | TUVec2 | TUVec3 | TUVec4 | TMat2x2 | TMat3x3 |
				TMat4x4 | TMat2x3 | TMat3x2 | TMat2x4 | TMat4x2 | TMat3x4 | TMat4x3:
				true;
			case _:
				false;
		}
	}

	public static function isOkayForVarying(type:GType):Bool {
		return switch type {
			case TFloat | TVec2 | TVec3 | TVec4 | TInt | TIVec2 | TIVec3 | TIVec4 | TUInt | TUVec2 | TUVec3 | TUVec4 | TMat2x2 | TMat3x3 |
				TMat4x4 | TMat2x3 | TMat3x2 | TMat2x4 | TMat4x2 | TMat3x4 | TMat4x3:
				true;
			case TStruct(fields):
				fields.map(f -> !f.type.match(TStruct(_) | TArray(_)) && isOkayForVarying(f.type)).all();
			case TArray(type, _):
				!type.match(TStruct(_) | TArray(_)) && isOkayForVarying(type);
			case _:
				false;
		}
	}

	public static function isOkayForColor(type:GType):Bool {
		return switch type {
			case TFloat | TVec2 | TVec3 | TVec4 | TInt | TIVec2 | TIVec3 | TIVec4 | TUInt | TUVec2 | TUVec3 | TUVec4:
				true;
			case TArray(type, _):
				!type.match(TArray(_)) && isOkayForColor(type);
			case _:
				false;
		}
	}

	public static function isOkayForReturn(type:GType):Bool {
		return !type.containsSampler();
	}

	public static function equals(a:GType, b:GType, sortFields:Bool = false):Bool {
		return switch [a, b] {
			case [
				TVoid | TFloat | TVec2 | TVec3 | TVec4 | TInt | TIVec2 | TIVec3 | TIVec4 | TUInt | TUVec2 | TUVec3 | TUVec4 | TBool | TBVec2 | TBVec3 | TBVec4 | TMat2x2 | TMat3x3 | TMat4x4 | TMat2x3 | TMat3x2 | TMat2x4 | TMat4x2 | TMat3x4 | TMat4x3 | TSampler2D | TSampler3D | TSamplerCube | TSamplerCubeShadow | TSampler2DShadow | TSampler2DArray | TSampler2DArrayShadow | TISampler2D | TISampler3D | TISamplerCube | TISampler2DArray | TUSampler2D | TUSampler3D | TUSamplerCube | TUSampler2DArray,
				TVoid | TFloat | TVec2 | TVec3 | TVec4 | TInt | TIVec2 | TIVec3 | TIVec4 | TUInt | TUVec2 | TUVec3 | TUVec4 | TBool | TBVec2 | TBVec3 | TBVec4 | TMat2x2 | TMat3x3 | TMat4x4 | TMat2x3 | TMat3x2 | TMat2x4 | TMat4x2 | TMat3x4 | TMat4x3 | TSampler2D | TSampler3D | TSamplerCube | TSamplerCubeShadow | TSampler2DShadow | TSampler2DArray | TSampler2DArrayShadow | TISampler2D | TISampler3D | TISamplerCube | TISampler2DArray | TUSampler2D | TUSampler3D | TUSamplerCube | TUSampler2DArray
			]:
				a == b;
			case [TStruct(a), TStruct(b)]: //
				if (sortFields) {
					a = a.copy();
					b = b.copy();
					a.sort((a, b) -> Reflect.compare(a.name, b.name));
					b.sort((a, b) -> Reflect.compare(a.name, b.name));
				}
				a.length == b.length && zip(a, b, (a, b) -> a.name == b.name && equals(a.type, b.type, sortFields)).all();
			case [TArray(ta, sizea), TArray(tb, sizeb)]: //
				sizea.equals(sizeb) && equals(ta, tb, sortFields);
			case [TFunc(fa), TFunc(fb)]: //
				fa.args.length == fb.args.length && zip(fa.args, fb.args, (a,
						b) -> equals(a.type, b.type, sortFields)).all() && equals(fa.ret, fb.ret, sortFields);
			case _:
				false;
		}
	}

	public static function getElementType(t:GType):Null<ElementType> {
		return switch t {
			case TFloat | TVec2 | TVec3 | TVec4 | TMat2x2 | TMat3x3 | TMat4x4 | TMat2x3 | TMat3x2 | TMat2x4 | TMat4x2 | TMat3x4 | TMat4x3:
				TFloat;
			case TInt | TIVec2 | TIVec3 | TIVec4:
				TInt;
			case TUInt | TUVec2 | TUVec3 | TUVec4:
				TUInt;
			case TBool | TBVec2 | TBVec3 | TBVec4:
				TBool;
			case _:
				null;
		}
	}

	public static function tweakIdentifier(name:String, checkIfOkay:(name:String) -> Bool, alwaysTweak:Bool):String {
		if (!alwaysTweak && checkIfOkay(name))
			return name;
		final regex = new EReg("^" + RESERVED_PREFIX + "(.*)_([0-9]+)?$", "");
		final origName = regex.match(name) ? regex.matched(1) : name;
		var count = -1;
		while (true) {
			final newName = RESERVED_PREFIX + origName + "_" + (count >= 0 ? "" + count : "");
			if (checkIfOkay(newName)) {
				return newName;
			}
			count++;
		}
	}
}
#end

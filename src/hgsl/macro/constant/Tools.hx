package hgsl.macro.constant;

import haxe.macro.Context;

#if macro
using hgsl.macro.Tools;
using Lambda;

class Tools {
	extern static inline function at(a:MatBase, col:Int, row:Int):Float {
		return a.data[col * a.rows + row];
	}

	overload extern public static inline function mul(a:MatBase, b:MatBase):MatBase {
		// confusingly, AxB * CxA = CxB
		if (a.cols != b.rows)
			throw "matrix sizes mismatch for multiplication";
		final axis = a.cols;
		final res = new MatBase(b.cols, a.rows);
		var i = 0;
		for (c in 0...b.cols) {
			for (r in 0...a.rows) {
				var dot = 0.0;
				for (k in 0...axis) {
					dot += at(a, k, r) * at(b, c, k);
				}
				res.data[i++] = dot;
			}
		}
		return res;
	}

	overload extern public static inline function mul(a:MatBase, b:VecBase<Float>):VecBase<Float> {
		// confusingly, AxB * A = B
		if (a.cols != b.dim)
			throw "matrix sizes mismatch for multiplication";
		final axis = a.cols;
		final res = new VecBase<Float>(a.rows);
		var i = 0;
		for (r in 0...a.rows) {
			var dot = 0.0;
			for (k in 0...axis) {
				dot += at(a, k, r) * b.data[k];
			}
			res.data[i++] = dot;
		}
		return res;
	}

	overload extern public static inline function mul(a:VecBase<Float>, b:MatBase):VecBase<Float> {
		// confusingly, A * BxA = B
		if (a.dim != b.rows)
			throw "matrix sizes mismatch for multiplication";
		final axis = a.dim;
		final res = new VecBase<Float>(b.cols);
		var i = 0;
		for (c in 0...b.cols) {
			var dot = 0.0;
			for (k in 0...axis) {
				dot += a.data[k] * at(b, c, k);
			}
			res.data[i++] = dot;
		}
		return res;
	}

	overload extern public static inline function toVector(v:ScalarConstValue, dim:Int):VectorConstValue {
		return switch v {
			case VFloat(v):
				return VVec(VecBase.of([for (i in 0...dim) v]));
			case VInt(v):
				return VIVec(VecBase.of([for (i in 0...dim) v]));
			case VUInt(v):
				return VUVec(VecBase.of([for (i in 0...dim) v]));
			case VBool(v):
				return VBVec(VecBase.of([for (i in 0...dim) v]));
		}
	}

	overload extern public static inline function toVector(v:MatrixConstValue):VectorConstValue {
		return switch v {
			case VMat(v):
				return VVec(v.toVec());
		}
	}

	overload extern public static inline function toVector(v:Array<ScalarConstValue>):VectorConstValue {
		if (v.length == 0)
			throw ierror(macro "cannot join an empty array");
		return switch v[0] {
			case VFloat(_):
				VVec(VecBase.of(v.map(v -> switch v {
					case VFloat(v):
						v;
					case _:
						throw ierror(macro "types mismatch");
				})));
			case VInt(_):
				VIVec(VecBase.of(v.map(v -> switch v {
					case VInt(v):
						v;
					case _:
						throw ierror(macro "types mismatch");
				})));
			case VUInt(_):
				VUVec(VecBase.of(v.map(v -> switch v {
					case VUInt(v):
						v;
					case _:
						throw ierror(macro "types mismatch");
				})));
			case VBool(_):
				VBVec(VecBase.of(v.map(v -> switch v {
					case VBool(v):
						v;
					case _:
						throw ierror(macro "types mismatch");
				})));
		}
	}

	public static function length(v:VectorConstValue):Int {
		return switch v {
			case VVec(v):
				v.dim;
			case VIVec(v):
				v.dim;
			case VUVec(v):
				v.dim;
			case VBVec(v):
				v.dim;
		}
	}

	public static function truncate(v:VectorConstValue, to:Int):VectorConstValue {
		if (to > v.length())
			throw ierror(macro "not enough data");
		return switch v {
			case VVec(v):
				VVec(v.resize(to, 0));
			case VIVec(v):
				VIVec(v.resize(to, 0));
			case VUVec(v):
				VUVec(v.resize(to, 0));
			case VBVec(v):
				VBVec(v.resize(to, false));
		}
	}

	overload extern public static inline function castTo(v:ScalarConstValue, etype:ElementType):ScalarConstValue {
		return switch [v, etype] {
			case [VFloat(v), TFloat]:
				VFloat(v);
			case [VFloat(v), TInt]:
				VInt(Std.int(v));
			case [VFloat(v), TUInt]:
				VUInt(Std.int(v));
			case [VFloat(v), TBool]:
				VBool(v != 0);
			case [VInt(v), TFloat]:
				VFloat(v);
			case [VInt(v), TInt]:
				VInt(v);
			case [VInt(v), TUInt]:
				VUInt(v);
			case [VInt(v), TBool]:
				VBool(v != 0);
			case [VUInt(v), TFloat]:
				VFloat(v);
			case [VUInt(v), TInt]:
				VInt(v);
			case [VUInt(v), TUInt]:
				VUInt(v);
			case [VUInt(v), TBool]:
				VBool(v != 0);
			case [VBool(v), TFloat]:
				VFloat(v ? 1 : 0);
			case [VBool(v), TInt]:
				VInt(v ? 1 : 0);
			case [VBool(v), TUInt]:
				VUInt(v ? 1 : 0);
			case [VBool(v), TBool]:
				VBool(v);
		}
	}

	overload extern public static inline function castTo(v:VectorConstValue, etype:ElementType):VectorConstValue {
		return v.toScalars().toVectorOf(etype);
	}

	overload extern public static inline function castTo(v:ConstValue, etype:ElementType):ConstValue {
		return switch v {
			case VScalar(v):
				VScalar(v.castTo(etype));
			case VVector(v):
				VVector(v.castTo(etype));
			case _:
				throw ierror(macro "cannot cast");
		}
	}

	public static function toScalars(v:VectorConstValue):Array<ScalarConstValue> {
		return switch v {
			case VVec(v):
				[for (v in v.data) VFloat(v)];
			case VIVec(v):
				[for (v in v.data) VInt(v)];
			case VUVec(v):
				[for (v in v.data) VUInt(v)];
			case VBVec(v):
				[for (v in v.data) VBool(v)];
		}
	}

	public static function toVectorOf(v:Array<ScalarConstValue>, etype:ElementType):VectorConstValue {
		return v.map(v -> v.castTo(etype)).toVector();
	}

	public static function toMatrixOf(v:Array<ScalarConstValue>, cols:Int, rows:Int):MatrixConstValue {
		return switch v.map(v -> v.castTo(TFloat)).toVector() {
			case VVec(v):
				VMat(MatBase.fromVector(v, cols, rows));
			case _:
				throw ierror(macro "internal error");
		};
	}

	overload extern public static inline function extractFirst(v:VectorConstValue):ScalarConstValue {
		return switch v {
			case VVec(v):
				return VFloat(v.data[0]);
			case VIVec(v):
				return VInt(v.data[0]);
			case VUVec(v):
				return VUInt(v.data[0]);
			case VBVec(v):
				return VBool(v.data[0]);
		}
	}

	overload extern public static inline function extractFirst(v:MatrixConstValue):ScalarConstValue {
		return switch v {
			case VMat(v):
				return VFloat(v.data[0]);
		}
	}

	static inline function getType(v:ConstValue):GType {
		return switch v {
			case VScalar(v):
				switch v {
					case VFloat(_):
						TFloat;
					case VInt(_):
						TInt;
					case VUInt(_):
						TUInt;
					case VBool(_):
						TBool;
				}
			case VVector(v):
				switch v {
					case VVec(_.dim => 2):
						TVec2;
					case VVec(_.dim => 3):
						TVec3;
					case VVec(_.dim => 4):
						TVec4;
					case VIVec(_.dim => 2):
						TIVec2;
					case VIVec(_.dim => 3):
						TIVec3;
					case VIVec(_.dim => 4):
						TIVec4;
					case VUVec(_.dim => 2):
						TUVec2;
					case VUVec(_.dim => 3):
						TUVec3;
					case VUVec(_.dim => 4):
						TUVec4;
					case VBVec(_.dim => 2):
						TBVec2;
					case VBVec(_.dim => 3):
						TBVec3;
					case VBVec(_.dim => 4):
						TBVec4;
					case _:
						throw ierror(macro "invalid vector value");
				}
			case VMatrix(VMat([_.cols, _.rows] => [2, 2])):
				TMat2x2;
			case VMatrix(VMat([_.cols, _.rows] => [2, 3])):
				TMat2x3;
			case VMatrix(VMat([_.cols, _.rows] => [2, 4])):
				TMat2x4;
			case VMatrix(VMat([_.cols, _.rows] => [3, 2])):
				TMat3x2;
			case VMatrix(VMat([_.cols, _.rows] => [3, 3])):
				TMat3x3;
			case VMatrix(VMat([_.cols, _.rows] => [3, 4])):
				TMat3x4;
			case VMatrix(VMat([_.cols, _.rows] => [4, 2])):
				TMat4x2;
			case VMatrix(VMat([_.cols, _.rows] => [4, 3])):
				TMat4x3;
			case VMatrix(VMat([_.cols, _.rows] => [4, 4])):
				TMat4x4;
			case VMatrix(_):
				throw ierror(macro "invalid matrix value");
			case VStruct(v):
				TStruct(v.map(v -> {name: v.name, type: getType(v.value), pos: Context.currentPos()}));
			case VArray(v):
				TArray(getType(v[0]), Resolved(v.length));
			case VFunc(_):
				throw ierror(macro "unexpected function type");
		}
	}

	public static inline function toSource(v:ConstValue, parser:Parser):String {
		return switch v {
			case VScalar(v):
				switch v {
					case VFloat(v):
						final s = Std.string(v);
						if (~/^-?[0-9]+$/.match(s)) {
							s + ".0";
						} else {
							s;
						}
					case VInt(v):
						Std.string(v);
					case VUInt(v):
						"uint(" + v + ")";
					case VBool(v):
						Std.string(v);
				}
			case VVector(v):
				inline function vec<T>(name:String, v:VecBase<T>):String {
					final first = v.data[0];
					final same = v.data.toArray().foreach(a -> a == first);
					return name + v.dim + "(" + (same ? Std.string(first) : v.data.join(", ")) + ")";
				}
				switch v {
					case VVec(v):
						vec("vec", v);
					case VIVec(v):
						vec("ivec", v);
					case VUVec(v):
						vec("uvec", v);
					case VBVec(v):
						vec("bvec", v);
				}
			case VMatrix(VMat(v)):
				"mat" + v.cols + "x" + v.rows + "(" + (switch v.isDiag() {
					case null:
						v.data.join(", ");
					case d:
						Std.string(d);
				}) + ")";
			case VStruct(vs):
				v.getType().toGLSLType(parser).join("") + "(" + vs.map(f -> f.value.toSource(parser)).join(", ") + ")";
			case VArray(vs):
				v.getType().toGLSLType(parser).join("") + "(" + vs.map(v -> toSource(v, parser)).join(", ") + ")";
			case VFunc(_):
				throw ierror(macro "cannot transform function types to source");
		}
	}

	public static function equals(a:ConstValue, b:ConstValue):Bool {
		return switch [a, b] {
			case [VScalar(a), VScalar(b)]:
				eqScalar(a, b);
			case [VVector(a), VVector(b)]:
				eqVector(a, b);
			case [VMatrix(a), VMatrix(b)]:
				eqMatrix(a, b);
			case [VStruct(a), VStruct(b)]:
				a.zip(b, (a, b) -> a.name == b.name && equals(a.value, b.value)).all();
			case [VArray(a), VArray(b)]:
				a.zip(b, equals).all();
			case _:
				throw ierror(macro "invalid comparison");
		}
	}

	static function eqScalar(a:ScalarConstValue, b:ScalarConstValue):Bool {
		return switch [a, b] {
			case [VFloat(a), VFloat(b)]:
				a == b;
			case [VInt(a), VInt(b)]:
				a == b;
			case [VUInt(a), VUInt(b)]:
				a == b;
			case [VBool(a), VBool(b)]:
				a == b;
			case _:
				throw ierror(macro "invalid comparison");
		}
	}

	static function eqVector(a:VectorConstValue, b:VectorConstValue):Bool {
		return switch [a, b] {
			case [VVec(a), VVec(b)]:
				a.equals(b);
			case [VIVec(a), VIVec(b)]:
				a.equals(b);
			case [VUVec(a), VUVec(b)]:
				a.equals(b);
			case [VBVec(a), VBVec(b)]:
				a.equals(b);
			case _:
				throw ierror(macro "invalid comparison");
		}
	}

	static function eqMatrix(a:MatrixConstValue, b:MatrixConstValue):Bool {
		return switch [a, b] {
			case [VMat(a), VMat(b)]:
				a.equals(b);
			case _:
				throw ierror(macro "invalid comparison");
		}
	}

	public static function shape(v:MatrixConstValue):Array<Int> {
		return switch v {
			case VMat(v):
				[v.cols, v.rows];
		}
	}

	overload extern public static inline function getElementType(v:ScalarConstValue):ElementType {
		return switch v {
			case VFloat(_):
				TFloat;
			case VInt(_):
				TInt;
			case VUInt(_):
				TUInt;
			case VBool(_):
				TBool;
		}
	}

	overload extern public static inline function getElementType(v:VectorConstValue):ElementType {
		return switch v {
			case VVec(_):
				TFloat;
			case VIVec(_):
				TInt;
			case VUVec(_):
				TUInt;
			case VBVec(_):
				TBool;
		}
	}

	overload extern public static inline function getElementType(m:MatrixConstValue):ElementType {
		return switch m {
			case VMat(_):
				return TFloat;
		}
	}

	overload extern public static inline function getElementType(v:ConstValue):Null<ElementType> {
		return switch v {
			case VScalar(v):
				v.getElementType();
			case VVector(v):
				v.getElementType();
			case VMatrix(v):
				v.getElementType();
			case _:
				null;
		}
	}

	public static function toExpr(v:ConstValue):Expr {
		return switch v {
			case VScalar(v):
				switch v {
					case VFloat(v):
						macro {
							final v:std.StdTypes.Float = $v{v};
							v;
						}
					case VInt(v):
						macro {
							final v:std.StdTypes.Int = $v{v};
							v;
						}
					case VUInt(v):
						macro {
							final v:std.UInt = $v{v};
							v;
						}
					case VBool(v):
						macro {
							final v:std.StdTypes.Bool = $v{v};
							v;
						}
				}
			case VVector(v):
				switch v {
					case VVec(v):
						macro {
							final v:std.Array<std.StdTypes.Float> = $a{v.data.toArray().map(v -> macro $v{v})};
							v;
						}
					case VIVec(v):
						macro {
							final v:std.Array<std.StdTypes.Int> = $a{v.data.toArray().map(v -> macro $v{v})};
							v;
						}
					case VUVec(v):
						macro {
							final v:std.Array<std.UInt> = $a{v.data.toArray().map(v -> macro $v{v})};
							v;
						}
					case VBVec(v):
						macro {
							final v:std.Array<std.Bool> = $a{v.data.toArray().map(v -> macro $v{v})};
							v;
						}
				}
			case VMatrix(VMat(v)):
				macro {
					cols: $v{v.cols},
					rows: $v{v.rows},
					elements: $a{v.data.toArray().map(v -> macro $v{v})}
				}
			case VStruct(v):
				final fields:Array<ObjectField> = v.map(v -> {
					field: v.name,
					expr: v.value.toExpr(),
					quotes: Unquoted
				});
				{
					expr: EObjectDecl(fields),
					pos: (macro 0).pos
				}
			case VArray(vs):
				return macro $a{vs.map(v -> v.toExpr())};
			case VFunc(_):
				throw ierror(macro "unexpected function type");
		}
	}
}
#end

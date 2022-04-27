package hgsl.macro;

#if macro
private typedef BinLifter = (fint:(a:Int, b:Int) -> Int, fuint:(a:UInt, b:UInt) -> UInt, ffloat:(a:Float, b:Float) -> Float,
	fbool:(a:Bool, b:Bool) -> Bool) -> ((a:ConstValue, b:ConstValue) -> ConstValue);

private typedef BinLifterBool = (fint:(a:Int, b:Int) -> Bool, fuint:(a:UInt, b:UInt) -> Bool, ffloat:(a:Float, b:Float) -> Bool,
	fbool:(a:Bool, b:Bool) -> Bool) -> ((a:ConstValue, b:ConstValue) -> ConstValue);

private typedef UnLifter = (fint:(a:Int) -> Int, fuint:(a:UInt) -> UInt, ffloat:(a:Float) -> Float,
	fbool:(a:Bool) -> Bool) -> ((a:ConstValue) -> ConstValue);

class Operator {
	static final BIN_SCALAR_NUM:Array<Array<GType>> = [ //
		[TInt, TInt, TInt], //
		[TUInt, TUInt, TUInt], //
		[TFloat, TFloat, TFloat] //
	];
	static final BIN_SCALAR_INT:Array<Array<GType>> = [ //
		[TInt, TInt, TInt], //
		[TUInt, TUInt, TUInt] //
	];
	static final BIN_SCALAR_BITSHIFT:Array<Array<GType>> = [ //
		[TInt, TInt, TInt], //
		[TInt, TUInt, TInt], //
		[TUInt, TInt, TUInt], //
		[TUInt, TUInt, TUInt] //
	];
	static final BIN_SCALAR_BOOL:Array<Array<GType>> = [ //
		[TBool, TBool, TBool] //
	];
	static final BIN_SCALAR_COMP:Array<Array<GType>> = [ //
		[TInt, TInt, TBool], //
		[TUInt, TUInt, TBool], //
		[TFloat, TFloat, TBool] //
	];
	static final BIN_VECTOR_NUM:Array<Array<GType>> = [
		[TIVec2, TIVec2, TIVec2],
		[TIVec3, TIVec3, TIVec3],
		[TIVec4, TIVec4, TIVec4],
		[TIVec2, TInt, TIVec2],
		[TIVec3, TInt, TIVec3],
		[TIVec4, TInt, TIVec4],
		[TInt, TIVec2, TIVec2],
		[TInt, TIVec3, TIVec3],
		[TInt, TIVec4, TIVec4],
		[TUVec2, TUVec2, TUVec2],
		[TUVec3, TUVec3, TUVec3],
		[TUVec4, TUVec4, TUVec4],
		[TUVec2, TUInt, TUVec2],
		[TUVec3, TUInt, TUVec3],
		[TUVec4, TUInt, TUVec4],
		[TUInt, TUVec2, TUVec2],
		[TUInt, TUVec3, TUVec3],
		[TUInt, TUVec4, TUVec4],
		[TVec2, TVec2, TVec2],
		[TVec3, TVec3, TVec3],
		[TVec4, TVec4, TVec4],
		[TVec2, TFloat, TVec2],
		[TVec3, TFloat, TVec3],
		[TVec4, TFloat, TVec4],
		[TFloat, TVec2, TVec2],
		[TFloat, TVec3, TVec3],
		[TFloat, TVec4, TVec4],
	];
	static final BIN_VECTOR_INT:Array<Array<GType>> = [
		[TIVec2, TIVec2, TIVec2],
		[TIVec3, TIVec3, TIVec3],
		[TIVec4, TIVec4, TIVec4],
		[TIVec2, TInt, TIVec2],
		[TIVec3, TInt, TIVec3],
		[TIVec4, TInt, TIVec4],
		[TInt, TIVec2, TIVec2],
		[TInt, TIVec3, TIVec3],
		[TInt, TIVec4, TIVec4],
		[TUVec2, TUVec2, TUVec2],
		[TUVec3, TUVec3, TUVec3],
		[TUVec4, TUVec4, TUVec4],
		[TUVec2, TUInt, TUVec2],
		[TUVec3, TUInt, TUVec3],
		[TUVec4, TUInt, TUVec4],
		[TUInt, TUVec2, TUVec2],
		[TUInt, TUVec3, TUVec3],
		[TUInt, TUVec4, TUVec4],
	];
	static final BIN_VECTOR_BITSHIFT:Array<Array<GType>> = [
		[TIVec2, TIVec2, TIVec2],
		[TIVec3, TIVec3, TIVec3],
		[TIVec4, TIVec4, TIVec4],
		[TIVec2, TInt, TIVec2],
		[TIVec3, TInt, TIVec3],
		[TIVec4, TInt, TIVec4],
		[TIVec2, TUVec2, TIVec2],
		[TIVec3, TUVec3, TIVec3],
		[TIVec4, TUVec4, TIVec4],
		[TIVec2, TUInt, TIVec2],
		[TIVec3, TUInt, TIVec3],
		[TIVec4, TUInt, TIVec4],
		[TUVec2, TIVec2, TUVec2],
		[TUVec3, TIVec3, TUVec3],
		[TUVec4, TIVec4, TUVec4],
		[TUVec2, TInt, TUVec2],
		[TUVec3, TInt, TUVec3],
		[TUVec4, TInt, TUVec4],
		[TUVec2, TUVec2, TUVec2],
		[TUVec3, TUVec3, TUVec3],
		[TUVec4, TUVec4, TUVec4],
		[TUVec2, TUInt, TUVec2],
		[TUVec3, TUInt, TUVec3],
		[TUVec4, TUInt, TUVec4]
	];
	static final BIN_MATRIX_NUM:Array<Array<GType>> = [
		[TMat2x2, TMat2x2, TMat2x2],
		[TMat3x3, TMat3x3, TMat3x3],
		[TMat4x4, TMat4x4, TMat4x4],
		[TMat2x3, TMat2x3, TMat2x3],
		[TMat3x2, TMat3x2, TMat3x2],
		[TMat2x4, TMat2x4, TMat2x4],
		[TMat4x2, TMat4x2, TMat4x2],
		[TMat3x4, TMat3x4, TMat3x4],
		[TMat4x3, TMat4x3, TMat4x3],
		[TMat2x2, TFloat, TMat2x2],
		[TMat3x3, TFloat, TMat3x3],
		[TMat4x4, TFloat, TMat4x4],
		[TMat2x3, TFloat, TMat2x3],
		[TMat3x2, TFloat, TMat3x2],
		[TMat2x4, TFloat, TMat2x4],
		[TMat4x2, TFloat, TMat4x2],
		[TMat3x4, TFloat, TMat3x4],
		[TMat4x3, TFloat, TMat4x3],
		[TFloat, TMat2x2, TMat2x2],
		[TFloat, TMat3x3, TMat3x3],
		[TFloat, TMat4x4, TMat4x4],
		[TFloat, TMat2x3, TMat2x3],
		[TFloat, TMat3x2, TMat3x2],
		[TFloat, TMat2x4, TMat2x4],
		[TFloat, TMat4x2, TMat4x2],
		[TFloat, TMat3x4, TMat3x4],
		[TFloat, TMat4x3, TMat4x3]
	];
	static final BIN_MATRIX_MULT_SCALAR:Array<Array<GType>> = [
		[TMat2x2, TFloat, TMat2x2],
		[TMat3x3, TFloat, TMat3x3],
		[TMat4x4, TFloat, TMat4x4],
		[TMat2x3, TFloat, TMat2x3],
		[TMat3x2, TFloat, TMat3x2],
		[TMat2x4, TFloat, TMat2x4],
		[TMat4x2, TFloat, TMat4x2],
		[TMat3x4, TFloat, TMat3x4],
		[TMat4x3, TFloat, TMat4x3],
		[TFloat, TMat2x2, TMat2x2],
		[TFloat, TMat3x3, TMat3x3],
		[TFloat, TMat4x4, TMat4x4],
		[TFloat, TMat2x3, TMat2x3],
		[TFloat, TMat3x2, TMat3x2],
		[TFloat, TMat2x4, TMat2x4],
		[TFloat, TMat4x2, TMat4x2],
		[TFloat, TMat3x4, TMat3x4],
		[TFloat, TMat4x3, TMat4x3]
	];
	static final BIN_LA_MULTIPLY:Array<Array<GType>> = [
		[TMat2x2, TMat2x2, TMat2x2],
		[TMat2x2, TMat3x2, TMat3x2],
		[TMat2x2, TMat4x2, TMat4x2],
		[TMat2x3, TMat2x2, TMat2x3],
		[TMat2x3, TMat3x2, TMat3x3],
		[TMat2x3, TMat4x2, TMat4x3],
		[TMat2x4, TMat2x2, TMat2x4],
		[TMat2x4, TMat3x2, TMat3x4],
		[TMat2x4, TMat4x2, TMat4x4],
		[TMat3x2, TMat2x3, TMat2x2],
		[TMat3x2, TMat3x3, TMat3x2],
		[TMat3x2, TMat4x3, TMat4x2],
		[TMat3x3, TMat2x3, TMat2x3],
		[TMat3x3, TMat3x3, TMat3x3],
		[TMat3x3, TMat4x3, TMat4x3],
		[TMat3x4, TMat2x3, TMat2x4],
		[TMat3x4, TMat3x3, TMat3x4],
		[TMat3x4, TMat4x3, TMat4x4],
		[TMat4x2, TMat2x4, TMat2x2],
		[TMat4x2, TMat3x4, TMat3x2],
		[TMat4x2, TMat4x4, TMat4x2],
		[TMat4x3, TMat2x4, TMat2x3],
		[TMat4x3, TMat3x4, TMat3x3],
		[TMat4x3, TMat4x4, TMat4x3],
		[TMat4x4, TMat2x4, TMat2x4],
		[TMat4x4, TMat3x4, TMat3x4],
		[TMat4x4, TMat4x4, TMat4x4],
		[TMat2x2, TVec2, TVec2],
		[TMat2x3, TVec2, TVec3],
		[TMat2x4, TVec2, TVec4],
		[TMat3x2, TVec3, TVec2],
		[TMat3x3, TVec3, TVec3],
		[TMat3x4, TVec3, TVec4],
		[TMat4x2, TVec4, TVec2],
		[TMat4x3, TVec4, TVec3],
		[TMat4x4, TVec4, TVec4],
		[TVec2, TMat2x2, TVec2],
		[TVec3, TMat2x3, TVec2],
		[TVec4, TMat2x4, TVec2],
		[TVec2, TMat3x2, TVec3],
		[TVec3, TMat3x3, TVec3],
		[TVec4, TMat3x4, TVec3],
		[TVec2, TMat4x2, TVec4],
		[TVec3, TMat4x3, TVec4],
		[TVec4, TMat4x4, TVec4],
	];

	public static final BIN_LIST:Lazy<Array<BinopType>> = () -> [
		makeBinop(OpAdd, BIN_SCALAR_NUM, add(binScalar)),
		makeBinop(OpSub, BIN_SCALAR_NUM, sub(binScalar)),
		makeBinop(OpMult, BIN_SCALAR_NUM, mul(binScalar)),
		makeBinop(OpDiv, BIN_SCALAR_NUM, div(binScalar)),
		makeBinop(OpMod, BIN_SCALAR_INT, mod(binScalar)),
		makeBinop(OpAnd, BIN_SCALAR_INT, and(binScalar)),
		makeBinop(OpOr, BIN_SCALAR_INT, or(binScalar)),
		makeBinop(OpXor, BIN_SCALAR_INT, xor(binScalar)),
		makeBinop(OpShl, BIN_SCALAR_BITSHIFT, shlScalar),
		makeBinop(OpShr, BIN_SCALAR_BITSHIFT, shrScalar),
		makeBinop(OpBoolAnd, BIN_SCALAR_BOOL, land(binScalar)),
		makeBinop(OpBoolOr, BIN_SCALAR_BOOL, lor(binScalar)),
		//
		makeBinop(OpLt, BIN_SCALAR_COMP, lt(binScalarBool)),
		makeBinop(OpGt, BIN_SCALAR_COMP, gt(binScalarBool)),
		makeBinop(OpLte, BIN_SCALAR_COMP, lte(binScalarBool)),
		makeBinop(OpGte, BIN_SCALAR_COMP, gte(binScalarBool)),
		//
		makeBinop(OpAdd, BIN_VECTOR_NUM, add(binVector)),
		makeBinop(OpSub, BIN_VECTOR_NUM, sub(binVector)),
		makeBinop(OpMult, BIN_VECTOR_NUM, mul(binVector)),
		makeBinop(OpDiv, BIN_VECTOR_NUM, div(binVector)),
		makeBinop(OpMod, BIN_VECTOR_INT, mod(binVector)),
		makeBinop(OpAnd, BIN_VECTOR_INT, and(binVector)),
		makeBinop(OpOr, BIN_VECTOR_INT, or(binVector)),
		makeBinop(OpXor, BIN_VECTOR_INT, xor(binVector)),
		makeBinop(OpShl, BIN_VECTOR_BITSHIFT, shlVector),
		makeBinop(OpShr, BIN_VECTOR_BITSHIFT, shrVector),
		//
		makeBinop(OpAdd, BIN_MATRIX_NUM, add(binMatrix)),
		makeBinop(OpSub, BIN_MATRIX_NUM, sub(binMatrix)),
		makeBinop(OpDiv, BIN_MATRIX_NUM, div(binMatrix)),
		//
		makeBinop(OpMult, BIN_MATRIX_MULT_SCALAR, mul(binMatrix)),
		makeBinop(OpMult, BIN_LA_MULTIPLY, laMul)
	].flatten();

	static final UN_SCALAR_NUM:Array<Array<GType>> = [ //
		[TInt, TInt], //
		[TUInt, TUInt], //
		[TFloat, TFloat] //
	];
	static final UN_SCALAR_INT:Array<Array<GType>> = [ //
		[TInt, TInt], //
		[TUInt, TUInt] //
	];
	static final UN_SCALAR_BOOL:Array<Array<GType>> = [ //
		[TBool, TBool] //
	];
	static final UN_VECTOR_NUM:Array<Array<GType>> = [
		[TVec2, TVec2],
		[TVec3, TVec3],
		[TVec4, TVec4],
		[TIVec2, TIVec2],
		[TIVec3, TIVec3],
		[TIVec4, TIVec4],
		[TUVec2, TUVec2],
		[TUVec3, TUVec3],
		[TUVec4, TUVec4]
	];
	static final UN_VECTOR_INT:Array<Array<GType>> = [ //
		[TIVec2, TIVec2], //
		[TIVec3, TIVec3], //
		[TIVec4, TIVec4], //
		[TUVec2, TUVec2], //
		[TUVec3, TUVec3], //
		[TUVec4, TUVec4] //
	];
	static final UN_MATRIX_NUM:Array<Array<GType>> = [
		[TMat2x2, TMat2x2],
		[TMat3x3, TMat3x3],
		[TMat4x4, TMat4x4],
		[TMat2x3, TMat2x3],
		[TMat3x2, TMat3x2],
		[TMat2x4, TMat2x4],
		[TMat4x2, TMat4x2],
		[TMat3x4, TMat3x4],
		[TMat4x3, TMat4x3]
	];

	public static final UN_LIST:Lazy<Array<UnopType>> = () -> [
		makeUnop(OpIncrement, UN_SCALAR_NUM, false, true, null),
		makeUnop(OpIncrement, UN_SCALAR_NUM, true, true, null),
		makeUnop(OpDecrement, UN_SCALAR_NUM, false, true, null),
		makeUnop(OpDecrement, UN_SCALAR_NUM, true, true, null),
		makeUnop(OpIncrement, UN_VECTOR_NUM, false, true, null),
		makeUnop(OpIncrement, UN_VECTOR_NUM, true, true, null),
		makeUnop(OpDecrement, UN_VECTOR_NUM, false, true, null),
		makeUnop(OpDecrement, UN_VECTOR_NUM, true, true, null),
		makeUnop(OpIncrement, UN_MATRIX_NUM, false, true, null),
		makeUnop(OpIncrement, UN_MATRIX_NUM, true, true, null),
		makeUnop(OpDecrement, UN_MATRIX_NUM, false, true, null),
		makeUnop(OpDecrement, UN_MATRIX_NUM, true, true, null),
		//
		makeUnop(OpNeg, UN_SCALAR_NUM, false, false, neg(unScalar)),
		makeUnop(OpNegBits, UN_SCALAR_INT, false, false, not(unScalar)),
		makeUnop(OpNot, UN_SCALAR_BOOL, false, false, lnot(unVector)),
		//
		makeUnop(OpNeg, UN_VECTOR_NUM, false, false, neg(unVector)),
		makeUnop(OpNegBits, UN_VECTOR_INT, false, false, not(unVector)),
		//
		makeUnop(OpNeg, UN_MATRIX_NUM, false, false, neg(unMatrix))
	].flatten();

	static function makeBinop(op:Binop, types:Array<Array<GType>>, func:(a:ConstValue, b:ConstValue) -> ConstValue):Array<BinopType> {
		return types.map(type -> {
			op: op,
			func: switch type {
				case [a, b, ret]:
					{
						type: ret,
						args: [{
							name: "a",
							type: a,
							isRef: false
						}, {
							name: "b",
							type: b,
							isRef: false
						}]
					}
				case _:
					throw ierror(macro "internal error");
			},
			constFunc: func
		});
	}

	static function makeUnop(op:Unop, types:Array<Array<GType>>, postFix:Bool, needLValue:Bool,
			func:(a:ConstValue) -> ConstValue):Array<UnopType> {
		return types.map(type -> {
			op: op,
			func: switch type {
				case [a, ret]:
					{
						type: ret,
						args: [{
							name: "a",
							type: a,
							isRef: needLValue
						}]
					}
				case _:
					throw ierror(macro "internal error");
			},
			postFix: postFix,
			constFunc: func
		});
	}

	static function shlVector(a:ConstValue, b:ConstValue):ConstValue {
		return VVector(switch broadcastSecond(a, b) {
			case [VVector(VIVec(a)), VVector(VIVec(b))]:
				VIVec(a.map(b, (a, b) -> a << b));
			case [VVector(VIVec(a)), VVector(VUVec(b))]:
				VIVec(a.map(b, (a, b) -> a << b));
			case [VVector(VUVec(a)), VVector(VIVec(b))]:
				VUVec(a.map(b, (a, b) -> a << b));
			case [VVector(VUVec(a)), VVector(VUVec(b))]:
				VUVec(a.map(b, (a, b) -> a << b));
			case _:
				throw ierror(macro "constant types mismatch");
		});
	}

	static function shrVector(a:ConstValue, b:ConstValue):ConstValue {
		return VVector(switch broadcastSecond(a, b) {
			case [VVector(VIVec(a)), VVector(VIVec(b))]:
				VIVec(a.map(b, (a, b) -> a << b));
			case [VVector(VIVec(a)), VVector(VUVec(b))]:
				VIVec(a.map(b, (a, b) -> a << b));
			case [VVector(VUVec(a)), VVector(VIVec(b))]:
				VUVec(a.map(b, (a, b) -> a >>> b));
			case [VVector(VUVec(a)), VVector(VUVec(b))]:
				VUVec(a.map(b, (a, b) -> a >>> b));
			case _:
				throw ierror(macro "constant types mismatch");
		});
	}

	static function laMul(a:ConstValue, b:ConstValue):ConstValue {
		return switch [a, b] {
			case [VMatrix(VMat(a)), VMatrix(VMat(b))]:
				VMatrix(VMat(a.mul(b)));
			case [VMatrix(VMat(a)), VVector(VVec(b))]:
				VVector(VVec(a.mul(b)));
			case [VVector(VVec(a)), VMatrix(VMat(b))]:
				VVector(VVec(a.mul(b)));
			case _:
				throw ierror(macro "constant types mismatch");
		}
	}

	static function shlScalar(a:ConstValue, b:ConstValue):ConstValue {
		return VScalar(switch [a, b] {
			case [VScalar(VInt(a)), VScalar(VInt(b))]:
				VInt(a << b);
			case [VScalar(VInt(a)), VScalar(VUInt(b))]:
				VInt(a << b);
			case [VScalar(VUInt(a)), VScalar(VInt(b))]:
				VUInt(a << b);
			case [VScalar(VUInt(a)), VScalar(VUInt(b))]:
				VUInt(a << b);
			case _:
				throw ierror(macro "constant types mismatch");
		});
	}

	static function shrScalar(a:ConstValue, b:ConstValue):ConstValue {
		return VScalar(switch [a, b] {
			case [VScalar(VInt(a)), VScalar(VInt(b))]:
				VInt(a >> b);
			case [VScalar(VInt(a)), VScalar(VUInt(b))]:
				VInt(a >> b);
			case [VScalar(VUInt(a)), VScalar(VInt(b))]:
				VUInt(a >>> b);
			case [VScalar(VUInt(a)), VScalar(VUInt(b))]:
				VUInt(a >>> b);
			case _:
				throw ierror(macro "constant types mismatch");
		});
	}

	static function add(lifter:BinLifter):(a:ConstValue, b:ConstValue) -> ConstValue {
		return lifter((a, b) -> a + b, (a, b) -> a + b, (a, b) -> a + b, null);
	}

	static function sub(lifter:BinLifter):(a:ConstValue, b:ConstValue) -> ConstValue {
		return lifter((a, b) -> a - b, (a, b) -> a - b, (a, b) -> a - b, null);
	}

	static function mul(lifter:BinLifter):(a:ConstValue, b:ConstValue) -> ConstValue {
		return lifter((a, b) -> a * b, (a, b) -> a * b, (a, b) -> a * b, null);
	}

	static function div(lifter:BinLifter):(a:ConstValue, b:ConstValue) -> ConstValue {
		return lifter((a, b) -> Std.int(a / b), (a, b) -> Std.int(a / b), (a, b) -> a / b, null);
	}

	static function mod(lifter:BinLifter):(a:ConstValue, b:ConstValue) -> ConstValue {
		return lifter((a, b) -> a % b, (a, b) -> a % b, null, null);
	}

	static function and(lifter:BinLifter):(a:ConstValue, b:ConstValue) -> ConstValue {
		return lifter((a, b) -> a & b, (a, b) -> a & b, null, null);
	}

	static function or(lifter:BinLifter):(a:ConstValue, b:ConstValue) -> ConstValue {
		return lifter((a, b) -> a | b, (a, b) -> a | b, null, null);
	}

	static function xor(lifter:BinLifter):(a:ConstValue, b:ConstValue) -> ConstValue {
		return lifter((a, b) -> a ^ b, (a, b) -> a ^ b, null, null);
	}

	static function land(lifter:BinLifter):(a:ConstValue, b:ConstValue) -> ConstValue {
		return lifter(null, null, null, (a, b) -> a && b);
	}

	static function lor(lifter:BinLifter):(a:ConstValue, b:ConstValue) -> ConstValue {
		return lifter(null, null, null, (a, b) -> a || b);
	}

	static function lt(lifter:BinLifterBool):(a:ConstValue, b:ConstValue) -> ConstValue {
		return lifter((a, b) -> a < b, (a, b) -> a < b, (a, b) -> a < b, null);
	}

	static function gt(lifter:BinLifterBool):(a:ConstValue, b:ConstValue) -> ConstValue {
		return lifter((a, b) -> a > b, (a, b) -> a > b, (a, b) -> a > b, null);
	}

	static function lte(lifter:BinLifterBool):(a:ConstValue, b:ConstValue) -> ConstValue {
		return lifter((a, b) -> a <= b, (a, b) -> a <= b, (a, b) -> a <= b, null);
	}

	static function gte(lifter:BinLifterBool):(a:ConstValue, b:ConstValue) -> ConstValue {
		return lifter((a, b) -> a >= b, (a, b) -> a >= b, (a, b) -> a >= b, null);
	}

	static function neg(lifter:UnLifter):(a:ConstValue) -> ConstValue {
		return lifter(a -> -a, a -> -a, a -> -a, null);
	}

	static function not(lifter:UnLifter):(a:ConstValue) -> ConstValue {
		return lifter(a -> ~a, a -> ~a, null, null);
	}

	static function lnot(lifter:UnLifter):(a:ConstValue) -> ConstValue {
		return lifter(null, null, null, a -> !a);
	}

	static function broadcast(a:ConstValue, b:ConstValue):Array<ConstValue> {
		return switch broadcastFirst(a, b) {
			case [a, b]:
				broadcastSecond(a, b);
			case _:
				throw ierror(macro "internal error");
		}
	}

	static function broadcastFirst(a:ConstValue, b:ConstValue):Array<ConstValue> {
		return switch [a, b] {
			case [VScalar(a), VVector(b)]:
				[VVector(a.toVector(b.length())), VVector(b)];
			case [VScalar(a), VMatrix(b)]:
				final shape = b.shape();
				[VMatrix(a.repeat(shape[0] * shape[1]).toMatrixOf(shape[0], shape[1])), VMatrix(b)];
			case _:
				[a, b];
		}
	}

	static function broadcastSecond(a:ConstValue, b:ConstValue):Array<ConstValue> {
		return switch broadcastFirst(b, a) {
			case [b, a]:
				[a, b];
			case _:
				throw ierror(macro "internal error");
		}
	}

	static function binScalar(fint:(a:Int, b:Int) -> Int, fuint:(a:UInt, b:UInt) -> UInt, ffloat:(a:Float, b:Float) -> Float,
			fbool:(a:Bool, b:Bool) -> Bool):(a:ConstValue, b:ConstValue) -> ConstValue {
		return (a, b) -> VScalar(switch [a, b] {
			case [VScalar(VInt(a)), VScalar(VInt(b))] if (fint != null):
				VInt(fint(a, b));
			case [VScalar(VUInt(a)), VScalar(VUInt(b))] if (fuint != null):
				VUInt(fuint(a, b));
			case [VScalar(VFloat(a)), VScalar(VFloat(b))] if (ffloat != null):
				VFloat(ffloat(a, b));
			case [VScalar(VBool(a)), VScalar(VBool(b))] if (fbool != null):
				VBool(fbool(a, b));
			case _:
				final msg = "constant types mismatch " + a + " " + b;
				throw ierror(macro $v{msg});
		});
	}

	static function binScalarBool(fint:(a:Int, b:Int) -> Bool, fuint:(a:UInt, b:UInt) -> Bool, ffloat:(a:Float, b:Float) -> Bool,
			fbool:(a:Bool, b:Bool) -> Bool):(a:ConstValue, b:ConstValue) -> ConstValue {
		return (a, b) -> VScalar(switch [a, b] {
			case [VScalar(VInt(a)), VScalar(VInt(b))] if (fint != null):
				VBool(fint(a, b));
			case [VScalar(VUInt(a)), VScalar(VUInt(b))] if (fuint != null):
				VBool(fuint(a, b));
			case [VScalar(VFloat(a)), VScalar(VFloat(b))] if (ffloat != null):
				VBool(ffloat(a, b));
			case [VScalar(VBool(a)), VScalar(VBool(b))] if (fbool != null):
				VBool(fbool(a, b));
			case _:
				final msg = "constant types mismatch " + a + " " + b;
				throw ierror(macro $v{msg});
		});
	}

	static function binVector(fint:(a:Int, b:Int) -> Int, fuint:(a:UInt, b:UInt) -> UInt, ffloat:(a:Float, b:Float) -> Float,
			fbool:(a:Bool, b:Bool) -> Bool):(a:ConstValue, b:ConstValue) -> ConstValue {
		return (a, b) -> VVector(switch broadcast(a, b) {
			case [VVector(VIVec(a)), VVector(VIVec(b))] if (fint != null):
				VIVec(a.map(b, fint));
			case [VVector(VUVec(a)), VVector(VUVec(b))] if (fuint != null):
				VUVec(a.map(b, fuint));
			case [VVector(VVec(a)), VVector(VVec(b))] if (ffloat != null):
				VVec(a.map(b, ffloat));
			case [VVector(VBVec(a)), VVector(VBVec(b))] if (fbool != null):
				VBVec(a.map(b, fbool));
			case _:
				final msg = "constant types mismatch " + a + " " + b;
				throw ierror(macro $v{msg});
		});
	}

	static function binMatrix(fint:(a:Int, b:Int) -> Int, fuint:(a:UInt, b:UInt) -> UInt, ffloat:(a:Float, b:Float) -> Float,
			fbool:(a:Bool, b:Bool) -> Bool):(a:ConstValue, b:ConstValue) -> ConstValue {
		return (a, b) -> VMatrix(switch broadcast(a, b) {
			case [VMatrix(VMat(a)), VMatrix(VMat(b))] if (ffloat != null):
				VMat(a.map(b, ffloat));
			case _:
				final msg = "constant types mismatch " + a + " " + b;
				throw ierror(macro $v{msg});
		});
	}

	static function unScalar(fint:(a:Int) -> Int, fuint:(a:UInt) -> UInt, ffloat:(a:Float) -> Float,
			fbool:(a:Bool) -> Bool):(a:ConstValue) -> ConstValue {
		return a -> VScalar(switch a {
			case VScalar(VInt(a)) if (fint != null):
				VInt(fint(a));
			case VScalar(VUInt(a)) if (fuint != null):
				VUInt(fuint(a));
			case VScalar(VFloat(a)) if (ffloat != null):
				VFloat(ffloat(a));
			case VScalar(VBool(a)) if (fbool != null):
				VBool(fbool(a));
			case _:
				throw ierror(macro "constant types mismatch");
		});
	}

	static function unVector(fint:(a:Int) -> Int, fuint:(a:UInt) -> UInt, ffloat:(a:Float) -> Float,
			fbool:(a:Bool) -> Bool):(a:ConstValue) -> ConstValue {
		return a -> VVector(switch a {
			case VVector(VIVec(a)) if (fint != null):
				VIVec(a.map(fint));
			case VVector(VUVec(a)) if (fuint != null):
				VUVec(a.map(fuint));
			case VVector(VVec(a)) if (ffloat != null):
				VVec(a.map(ffloat));
			case VVector(VBVec(a)) if (fbool != null):
				VBVec(a.map(fbool));
			case _:
				throw ierror(macro "constant types mismatch");
		});
	}

	static function unMatrix(fint:(a:Int) -> Int, fuint:(a:UInt) -> UInt, ffloat:(a:Float) -> Float,
			fbool:(a:Bool) -> Bool):(a:ConstValue) -> ConstValue {
		return a -> VMatrix(switch a {
			case VMatrix(VMat(a)) if (ffloat != null):
				VMat(a.map(ffloat));
			case _:
				throw ierror(macro "constant types mismatch");
		});
	}

	// this is way too much heavy, just use it for pre-computation
	static function traceAllPossibleBinopTypes(listWithoutImplicitCast:Array<BinopType>):Void {
		final possibleTypes = [
			TFloat,
			TVec2,
			TVec3,
			TVec4,
			TInt,
			TIVec2,
			TIVec3,
			TIVec4,
			TUInt,
			TUVec2,
			TUVec3,
			TUVec4,
			TBool,
			TBVec2,
			TBVec3,
			TBVec4,
			TMat2x2,
			TMat3x3,
			TMat4x4,
			TMat2x3,
			TMat3x2,
			TMat2x4,
			TMat4x2,
			TMat3x4,
			TMat4x3
		];

		final objs = [];
		for (op in Binop.createAll()) {
			final candidates = listWithoutImplicitCast.filter(f -> f.op == op).map(f -> f.func);
			if (candidates.length == 0)
				continue;
			final types = [];
			for (lhs in possibleTypes) {
				for (rhs in possibleTypes) {
					switch [lhs, rhs].computeOverloadCandidates(candidates) {
						case []:
						case [i]:
							types.push([lhs, rhs, candidates[i].type]);
						case ambiguous:
							throw "ambiguous binop found: " + lhs.getName() + " " + op.getName() + " " + rhs.getName();
					}
				}
			}

			// do a topological sort for haxe operator overloading
			final num = types.length;
			final sorted = [];
			final visited = [for (i in 0...num) false];
			var f:(i:Int) -> Void;
			f = i -> {
				if (visited[i])
					return;
				visited[i] = true;
				final argTo = [types[i][0], types[i][1]];
				for (j in 0...num) {
					if (i == j)
						continue;
					final argFrom = [types[j][0], types[j][1]];
					if (Tools.canImplicitlyCast(argFrom, argTo))
						f(j);
				}
				sorted.push(types[i]);
			}
			for (i in 0...num) {
				f(i);
			}

			objs.push({
				op: op,
				types: sorted
			});
		}
		trace(objs);
	}

	public static final ALL_POSSIBLE_BINOP_TYPES = [{
		types: [
			[TInt, TInt, TInt],
			[TUInt, TInt, TUInt],
			[TFloat, TInt, TFloat],
			[TInt, TUInt, TUInt],
			[TUInt, TUInt, TUInt],
			[TFloat, TUInt, TFloat],
			[TInt, TFloat, TFloat],
			[TUInt, TFloat, TFloat],
			[TFloat, TFloat, TFloat],
			[TInt, TIVec2, TIVec2],
			[TUInt, TIVec2, TUVec2],
			[TFloat, TIVec2, TVec2],
			[TInt, TUVec2, TUVec2],
			[TUInt, TUVec2, TUVec2],
			[TFloat, TUVec2, TVec2],
			[TInt, TVec2, TVec2],
			[TUInt, TVec2, TVec2],
			[TFloat, TVec2, TVec2],
			[TInt, TIVec3, TIVec3],
			[TUInt, TIVec3, TUVec3],
			[TFloat, TIVec3, TVec3],
			[TInt, TUVec3, TUVec3],
			[TUInt, TUVec3, TUVec3],
			[TFloat, TUVec3, TVec3],
			[TInt, TVec3, TVec3],
			[TUInt, TVec3, TVec3],
			[TFloat, TVec3, TVec3],
			[TInt, TIVec4, TIVec4],
			[TUInt, TIVec4, TUVec4],
			[TFloat, TIVec4, TVec4],
			[TInt, TUVec4, TUVec4],
			[TUInt, TUVec4, TUVec4],
			[TFloat, TUVec4, TVec4],
			[TInt, TVec4, TVec4],
			[TUInt, TVec4, TVec4],
			[TFloat, TVec4, TVec4],
			[TInt, TMat2x2, TMat2x2],
			[TUInt, TMat2x2, TMat2x2],
			[TFloat, TMat2x2, TMat2x2],
			[TInt, TMat3x3, TMat3x3],
			[TUInt, TMat3x3, TMat3x3],
			[TFloat, TMat3x3, TMat3x3],
			[TInt, TMat4x4, TMat4x4],
			[TUInt, TMat4x4, TMat4x4],
			[TFloat, TMat4x4, TMat4x4],
			[TInt, TMat2x3, TMat2x3],
			[TUInt, TMat2x3, TMat2x3],
			[TFloat, TMat2x3, TMat2x3],
			[TInt, TMat3x2, TMat3x2],
			[TUInt, TMat3x2, TMat3x2],
			[TFloat, TMat3x2, TMat3x2],
			[TInt, TMat2x4, TMat2x4],
			[TUInt, TMat2x4, TMat2x4],
			[TFloat, TMat2x4, TMat2x4],
			[TInt, TMat4x2, TMat4x2],
			[TUInt, TMat4x2, TMat4x2],
			[TFloat, TMat4x2, TMat4x2],
			[TInt, TMat3x4, TMat3x4],
			[TUInt, TMat3x4, TMat3x4],
			[TFloat, TMat3x4, TMat3x4],
			[TInt, TMat4x3, TMat4x3],
			[TUInt, TMat4x3, TMat4x3],
			[TFloat, TMat4x3, TMat4x3],
			[TIVec2, TInt, TIVec2],
			[TUVec2, TInt, TUVec2],
			[TVec2, TInt, TVec2],
			[TIVec2, TUInt, TUVec2],
			[TUVec2, TUInt, TUVec2],
			[TVec2, TUInt, TVec2],
			[TIVec2, TFloat, TVec2],
			[TUVec2, TFloat, TVec2],
			[TVec2, TFloat, TVec2],
			[TIVec2, TIVec2, TIVec2],
			[TUVec2, TIVec2, TUVec2],
			[TVec2, TIVec2, TVec2],
			[TIVec2, TUVec2, TUVec2],
			[TUVec2, TUVec2, TUVec2],
			[TVec2, TUVec2, TVec2],
			[TIVec2, TVec2, TVec2],
			[TUVec2, TVec2, TVec2],
			[TVec2, TVec2, TVec2],
			[TIVec3, TInt, TIVec3],
			[TUVec3, TInt, TUVec3],
			[TVec3, TInt, TVec3],
			[TIVec3, TUInt, TUVec3],
			[TUVec3, TUInt, TUVec3],
			[TVec3, TUInt, TVec3],
			[TIVec3, TFloat, TVec3],
			[TUVec3, TFloat, TVec3],
			[TVec3, TFloat, TVec3],
			[TIVec3, TIVec3, TIVec3],
			[TUVec3, TIVec3, TUVec3],
			[TVec3, TIVec3, TVec3],
			[TIVec3, TUVec3, TUVec3],
			[TUVec3, TUVec3, TUVec3],
			[TVec3, TUVec3, TVec3],
			[TIVec3, TVec3, TVec3],
			[TUVec3, TVec3, TVec3],
			[TVec3, TVec3, TVec3],
			[TIVec4, TInt, TIVec4],
			[TUVec4, TInt, TUVec4],
			[TVec4, TInt, TVec4],
			[TIVec4, TUInt, TUVec4],
			[TUVec4, TUInt, TUVec4],
			[TVec4, TUInt, TVec4],
			[TIVec4, TFloat, TVec4],
			[TUVec4, TFloat, TVec4],
			[TVec4, TFloat, TVec4],
			[TIVec4, TIVec4, TIVec4],
			[TUVec4, TIVec4, TUVec4],
			[TVec4, TIVec4, TVec4],
			[TIVec4, TUVec4, TUVec4],
			[TUVec4, TUVec4, TUVec4],
			[TVec4, TUVec4, TVec4],
			[TIVec4, TVec4, TVec4],
			[TUVec4, TVec4, TVec4],
			[TVec4, TVec4, TVec4],
			[TMat2x2, TInt, TMat2x2],
			[TMat2x2, TUInt, TMat2x2],
			[TMat2x2, TFloat, TMat2x2],
			[TMat2x2, TMat2x2, TMat2x2],
			[TMat3x3, TInt, TMat3x3],
			[TMat3x3, TUInt, TMat3x3],
			[TMat3x3, TFloat, TMat3x3],
			[TMat3x3, TMat3x3, TMat3x3],
			[TMat4x4, TInt, TMat4x4],
			[TMat4x4, TUInt, TMat4x4],
			[TMat4x4, TFloat, TMat4x4],
			[TMat4x4, TMat4x4, TMat4x4],
			[TMat2x3, TInt, TMat2x3],
			[TMat2x3, TUInt, TMat2x3],
			[TMat2x3, TFloat, TMat2x3],
			[TMat2x3, TMat2x3, TMat2x3],
			[TMat3x2, TInt, TMat3x2],
			[TMat3x2, TUInt, TMat3x2],
			[TMat3x2, TFloat, TMat3x2],
			[TMat3x2, TMat3x2, TMat3x2],
			[TMat2x4, TInt, TMat2x4],
			[TMat2x4, TUInt, TMat2x4],
			[TMat2x4, TFloat, TMat2x4],
			[TMat2x4, TMat2x4, TMat2x4],
			[TMat4x2, TInt, TMat4x2],
			[TMat4x2, TUInt, TMat4x2],
			[TMat4x2, TFloat, TMat4x2],
			[TMat4x2, TMat4x2, TMat4x2],
			[TMat3x4, TInt, TMat3x4],
			[TMat3x4, TUInt, TMat3x4],
			[TMat3x4, TFloat, TMat3x4],
			[TMat3x4, TMat3x4, TMat3x4],
			[TMat4x3, TInt, TMat4x3],
			[TMat4x3, TUInt, TMat4x3],
			[TMat4x3, TFloat, TMat4x3],
			[TMat4x3, TMat4x3, TMat4x3]
		],
		op: OpAdd
	}, {
		types: [
			[TInt, TInt, TInt],
			[TUInt, TInt, TUInt],
			[TFloat, TInt, TFloat],
			[TInt, TUInt, TUInt],
			[TUInt, TUInt, TUInt],
			[TFloat, TUInt, TFloat],
			[TInt, TFloat, TFloat],
			[TUInt, TFloat, TFloat],
			[TFloat, TFloat, TFloat],
			[TInt, TIVec2, TIVec2],
			[TUInt, TIVec2, TUVec2],
			[TFloat, TIVec2, TVec2],
			[TInt, TUVec2, TUVec2],
			[TUInt, TUVec2, TUVec2],
			[TFloat, TUVec2, TVec2],
			[TInt, TVec2, TVec2],
			[TUInt, TVec2, TVec2],
			[TFloat, TVec2, TVec2],
			[TInt, TIVec3, TIVec3],
			[TUInt, TIVec3, TUVec3],
			[TFloat, TIVec3, TVec3],
			[TInt, TUVec3, TUVec3],
			[TUInt, TUVec3, TUVec3],
			[TFloat, TUVec3, TVec3],
			[TInt, TVec3, TVec3],
			[TUInt, TVec3, TVec3],
			[TFloat, TVec3, TVec3],
			[TInt, TIVec4, TIVec4],
			[TUInt, TIVec4, TUVec4],
			[TFloat, TIVec4, TVec4],
			[TInt, TUVec4, TUVec4],
			[TUInt, TUVec4, TUVec4],
			[TFloat, TUVec4, TVec4],
			[TInt, TVec4, TVec4],
			[TUInt, TVec4, TVec4],
			[TFloat, TVec4, TVec4],
			[TInt, TMat2x2, TMat2x2],
			[TUInt, TMat2x2, TMat2x2],
			[TFloat, TMat2x2, TMat2x2],
			[TInt, TMat3x3, TMat3x3],
			[TUInt, TMat3x3, TMat3x3],
			[TFloat, TMat3x3, TMat3x3],
			[TInt, TMat4x4, TMat4x4],
			[TUInt, TMat4x4, TMat4x4],
			[TFloat, TMat4x4, TMat4x4],
			[TInt, TMat2x3, TMat2x3],
			[TUInt, TMat2x3, TMat2x3],
			[TFloat, TMat2x3, TMat2x3],
			[TInt, TMat3x2, TMat3x2],
			[TUInt, TMat3x2, TMat3x2],
			[TFloat, TMat3x2, TMat3x2],
			[TInt, TMat2x4, TMat2x4],
			[TUInt, TMat2x4, TMat2x4],
			[TFloat, TMat2x4, TMat2x4],
			[TInt, TMat4x2, TMat4x2],
			[TUInt, TMat4x2, TMat4x2],
			[TFloat, TMat4x2, TMat4x2],
			[TInt, TMat3x4, TMat3x4],
			[TUInt, TMat3x4, TMat3x4],
			[TFloat, TMat3x4, TMat3x4],
			[TInt, TMat4x3, TMat4x3],
			[TUInt, TMat4x3, TMat4x3],
			[TFloat, TMat4x3, TMat4x3],
			[TIVec2, TInt, TIVec2],
			[TUVec2, TInt, TUVec2],
			[TVec2, TInt, TVec2],
			[TIVec2, TUInt, TUVec2],
			[TUVec2, TUInt, TUVec2],
			[TVec2, TUInt, TVec2],
			[TIVec2, TFloat, TVec2],
			[TUVec2, TFloat, TVec2],
			[TVec2, TFloat, TVec2],
			[TIVec2, TIVec2, TIVec2],
			[TUVec2, TIVec2, TUVec2],
			[TVec2, TIVec2, TVec2],
			[TIVec2, TUVec2, TUVec2],
			[TUVec2, TUVec2, TUVec2],
			[TVec2, TUVec2, TVec2],
			[TIVec2, TVec2, TVec2],
			[TUVec2, TVec2, TVec2],
			[TVec2, TVec2, TVec2],
			[TIVec2, TMat2x2, TVec2],
			[TUVec2, TMat2x2, TVec2],
			[TVec2, TMat2x2, TVec2],
			[TIVec2, TMat3x2, TVec3],
			[TUVec2, TMat3x2, TVec3],
			[TVec2, TMat3x2, TVec3],
			[TIVec2, TMat4x2, TVec4],
			[TUVec2, TMat4x2, TVec4],
			[TVec2, TMat4x2, TVec4],
			[TIVec3, TInt, TIVec3],
			[TUVec3, TInt, TUVec3],
			[TVec3, TInt, TVec3],
			[TIVec3, TUInt, TUVec3],
			[TUVec3, TUInt, TUVec3],
			[TVec3, TUInt, TVec3],
			[TIVec3, TFloat, TVec3],
			[TUVec3, TFloat, TVec3],
			[TVec3, TFloat, TVec3],
			[TIVec3, TIVec3, TIVec3],
			[TUVec3, TIVec3, TUVec3],
			[TVec3, TIVec3, TVec3],
			[TIVec3, TUVec3, TUVec3],
			[TUVec3, TUVec3, TUVec3],
			[TVec3, TUVec3, TVec3],
			[TIVec3, TVec3, TVec3],
			[TUVec3, TVec3, TVec3],
			[TVec3, TVec3, TVec3],
			[TIVec3, TMat3x3, TVec3],
			[TUVec3, TMat3x3, TVec3],
			[TVec3, TMat3x3, TVec3],
			[TIVec3, TMat2x3, TVec2],
			[TUVec3, TMat2x3, TVec2],
			[TVec3, TMat2x3, TVec2],
			[TIVec3, TMat4x3, TVec4],
			[TUVec3, TMat4x3, TVec4],
			[TVec3, TMat4x3, TVec4],
			[TIVec4, TInt, TIVec4],
			[TUVec4, TInt, TUVec4],
			[TVec4, TInt, TVec4],
			[TIVec4, TUInt, TUVec4],
			[TUVec4, TUInt, TUVec4],
			[TVec4, TUInt, TVec4],
			[TIVec4, TFloat, TVec4],
			[TUVec4, TFloat, TVec4],
			[TVec4, TFloat, TVec4],
			[TIVec4, TIVec4, TIVec4],
			[TUVec4, TIVec4, TUVec4],
			[TVec4, TIVec4, TVec4],
			[TIVec4, TUVec4, TUVec4],
			[TUVec4, TUVec4, TUVec4],
			[TVec4, TUVec4, TVec4],
			[TIVec4, TVec4, TVec4],
			[TUVec4, TVec4, TVec4],
			[TVec4, TVec4, TVec4],
			[TIVec4, TMat4x4, TVec4],
			[TUVec4, TMat4x4, TVec4],
			[TVec4, TMat4x4, TVec4],
			[TIVec4, TMat2x4, TVec2],
			[TUVec4, TMat2x4, TVec2],
			[TVec4, TMat2x4, TVec2],
			[TIVec4, TMat3x4, TVec3],
			[TUVec4, TMat3x4, TVec3],
			[TVec4, TMat3x4, TVec3],
			[TMat2x2, TInt, TMat2x2],
			[TMat2x2, TUInt, TMat2x2],
			[TMat2x2, TFloat, TMat2x2],
			[TMat2x2, TIVec2, TVec2],
			[TMat2x2, TUVec2, TVec2],
			[TMat2x2, TVec2, TVec2],
			[TMat2x2, TMat2x2, TMat2x2],
			[TMat2x2, TMat3x2, TMat3x2],
			[TMat2x2, TMat4x2, TMat4x2],
			[TMat3x3, TInt, TMat3x3],
			[TMat3x3, TUInt, TMat3x3],
			[TMat3x3, TFloat, TMat3x3],
			[TMat3x3, TIVec3, TVec3],
			[TMat3x3, TUVec3, TVec3],
			[TMat3x3, TVec3, TVec3],
			[TMat3x3, TMat3x3, TMat3x3],
			[TMat3x3, TMat2x3, TMat2x3],
			[TMat3x3, TMat4x3, TMat4x3],
			[TMat4x4, TInt, TMat4x4],
			[TMat4x4, TUInt, TMat4x4],
			[TMat4x4, TFloat, TMat4x4],
			[TMat4x4, TIVec4, TVec4],
			[TMat4x4, TUVec4, TVec4],
			[TMat4x4, TVec4, TVec4],
			[TMat4x4, TMat4x4, TMat4x4],
			[TMat4x4, TMat2x4, TMat2x4],
			[TMat4x4, TMat3x4, TMat3x4],
			[TMat2x3, TInt, TMat2x3],
			[TMat2x3, TUInt, TMat2x3],
			[TMat2x3, TFloat, TMat2x3],
			[TMat2x3, TIVec2, TVec3],
			[TMat2x3, TUVec2, TVec3],
			[TMat2x3, TVec2, TVec3],
			[TMat2x3, TMat2x2, TMat2x3],
			[TMat2x3, TMat3x2, TMat3x3],
			[TMat2x3, TMat4x2, TMat4x3],
			[TMat3x2, TInt, TMat3x2],
			[TMat3x2, TUInt, TMat3x2],
			[TMat3x2, TFloat, TMat3x2],
			[TMat3x2, TIVec3, TVec2],
			[TMat3x2, TUVec3, TVec2],
			[TMat3x2, TVec3, TVec2],
			[TMat3x2, TMat3x3, TMat3x2],
			[TMat3x2, TMat2x3, TMat2x2],
			[TMat3x2, TMat4x3, TMat4x2],
			[TMat2x4, TInt, TMat2x4],
			[TMat2x4, TUInt, TMat2x4],
			[TMat2x4, TFloat, TMat2x4],
			[TMat2x4, TIVec2, TVec4],
			[TMat2x4, TUVec2, TVec4],
			[TMat2x4, TVec2, TVec4],
			[TMat2x4, TMat2x2, TMat2x4],
			[TMat2x4, TMat3x2, TMat3x4],
			[TMat2x4, TMat4x2, TMat4x4],
			[TMat4x2, TInt, TMat4x2],
			[TMat4x2, TUInt, TMat4x2],
			[TMat4x2, TFloat, TMat4x2],
			[TMat4x2, TIVec4, TVec2],
			[TMat4x2, TUVec4, TVec2],
			[TMat4x2, TVec4, TVec2],
			[TMat4x2, TMat4x4, TMat4x2],
			[TMat4x2, TMat2x4, TMat2x2],
			[TMat4x2, TMat3x4, TMat3x2],
			[TMat3x4, TInt, TMat3x4],
			[TMat3x4, TUInt, TMat3x4],
			[TMat3x4, TFloat, TMat3x4],
			[TMat3x4, TIVec3, TVec4],
			[TMat3x4, TUVec3, TVec4],
			[TMat3x4, TVec3, TVec4],
			[TMat3x4, TMat3x3, TMat3x4],
			[TMat3x4, TMat2x3, TMat2x4],
			[TMat3x4, TMat4x3, TMat4x4],
			[TMat4x3, TInt, TMat4x3],
			[TMat4x3, TUInt, TMat4x3],
			[TMat4x3, TFloat, TMat4x3],
			[TMat4x3, TIVec4, TVec3],
			[TMat4x3, TUVec4, TVec3],
			[TMat4x3, TVec4, TVec3],
			[TMat4x3, TMat4x4, TMat4x3],
			[TMat4x3, TMat2x4, TMat2x3],
			[TMat4x3, TMat3x4, TMat3x3]
		],
		op: OpMult
	}, {
		types: [
			[TInt, TInt, TInt],
			[TUInt, TInt, TUInt],
			[TFloat, TInt, TFloat],
			[TInt, TUInt, TUInt],
			[TUInt, TUInt, TUInt],
			[TFloat, TUInt, TFloat],
			[TInt, TFloat, TFloat],
			[TUInt, TFloat, TFloat],
			[TFloat, TFloat, TFloat],
			[TInt, TIVec2, TIVec2],
			[TUInt, TIVec2, TUVec2],
			[TFloat, TIVec2, TVec2],
			[TInt, TUVec2, TUVec2],
			[TUInt, TUVec2, TUVec2],
			[TFloat, TUVec2, TVec2],
			[TInt, TVec2, TVec2],
			[TUInt, TVec2, TVec2],
			[TFloat, TVec2, TVec2],
			[TInt, TIVec3, TIVec3],
			[TUInt, TIVec3, TUVec3],
			[TFloat, TIVec3, TVec3],
			[TInt, TUVec3, TUVec3],
			[TUInt, TUVec3, TUVec3],
			[TFloat, TUVec3, TVec3],
			[TInt, TVec3, TVec3],
			[TUInt, TVec3, TVec3],
			[TFloat, TVec3, TVec3],
			[TInt, TIVec4, TIVec4],
			[TUInt, TIVec4, TUVec4],
			[TFloat, TIVec4, TVec4],
			[TInt, TUVec4, TUVec4],
			[TUInt, TUVec4, TUVec4],
			[TFloat, TUVec4, TVec4],
			[TInt, TVec4, TVec4],
			[TUInt, TVec4, TVec4],
			[TFloat, TVec4, TVec4],
			[TInt, TMat2x2, TMat2x2],
			[TUInt, TMat2x2, TMat2x2],
			[TFloat, TMat2x2, TMat2x2],
			[TInt, TMat3x3, TMat3x3],
			[TUInt, TMat3x3, TMat3x3],
			[TFloat, TMat3x3, TMat3x3],
			[TInt, TMat4x4, TMat4x4],
			[TUInt, TMat4x4, TMat4x4],
			[TFloat, TMat4x4, TMat4x4],
			[TInt, TMat2x3, TMat2x3],
			[TUInt, TMat2x3, TMat2x3],
			[TFloat, TMat2x3, TMat2x3],
			[TInt, TMat3x2, TMat3x2],
			[TUInt, TMat3x2, TMat3x2],
			[TFloat, TMat3x2, TMat3x2],
			[TInt, TMat2x4, TMat2x4],
			[TUInt, TMat2x4, TMat2x4],
			[TFloat, TMat2x4, TMat2x4],
			[TInt, TMat4x2, TMat4x2],
			[TUInt, TMat4x2, TMat4x2],
			[TFloat, TMat4x2, TMat4x2],
			[TInt, TMat3x4, TMat3x4],
			[TUInt, TMat3x4, TMat3x4],
			[TFloat, TMat3x4, TMat3x4],
			[TInt, TMat4x3, TMat4x3],
			[TUInt, TMat4x3, TMat4x3],
			[TFloat, TMat4x3, TMat4x3],
			[TIVec2, TInt, TIVec2],
			[TUVec2, TInt, TUVec2],
			[TVec2, TInt, TVec2],
			[TIVec2, TUInt, TUVec2],
			[TUVec2, TUInt, TUVec2],
			[TVec2, TUInt, TVec2],
			[TIVec2, TFloat, TVec2],
			[TUVec2, TFloat, TVec2],
			[TVec2, TFloat, TVec2],
			[TIVec2, TIVec2, TIVec2],
			[TUVec2, TIVec2, TUVec2],
			[TVec2, TIVec2, TVec2],
			[TIVec2, TUVec2, TUVec2],
			[TUVec2, TUVec2, TUVec2],
			[TVec2, TUVec2, TVec2],
			[TIVec2, TVec2, TVec2],
			[TUVec2, TVec2, TVec2],
			[TVec2, TVec2, TVec2],
			[TIVec3, TInt, TIVec3],
			[TUVec3, TInt, TUVec3],
			[TVec3, TInt, TVec3],
			[TIVec3, TUInt, TUVec3],
			[TUVec3, TUInt, TUVec3],
			[TVec3, TUInt, TVec3],
			[TIVec3, TFloat, TVec3],
			[TUVec3, TFloat, TVec3],
			[TVec3, TFloat, TVec3],
			[TIVec3, TIVec3, TIVec3],
			[TUVec3, TIVec3, TUVec3],
			[TVec3, TIVec3, TVec3],
			[TIVec3, TUVec3, TUVec3],
			[TUVec3, TUVec3, TUVec3],
			[TVec3, TUVec3, TVec3],
			[TIVec3, TVec3, TVec3],
			[TUVec3, TVec3, TVec3],
			[TVec3, TVec3, TVec3],
			[TIVec4, TInt, TIVec4],
			[TUVec4, TInt, TUVec4],
			[TVec4, TInt, TVec4],
			[TIVec4, TUInt, TUVec4],
			[TUVec4, TUInt, TUVec4],
			[TVec4, TUInt, TVec4],
			[TIVec4, TFloat, TVec4],
			[TUVec4, TFloat, TVec4],
			[TVec4, TFloat, TVec4],
			[TIVec4, TIVec4, TIVec4],
			[TUVec4, TIVec4, TUVec4],
			[TVec4, TIVec4, TVec4],
			[TIVec4, TUVec4, TUVec4],
			[TUVec4, TUVec4, TUVec4],
			[TVec4, TUVec4, TVec4],
			[TIVec4, TVec4, TVec4],
			[TUVec4, TVec4, TVec4],
			[TVec4, TVec4, TVec4],
			[TMat2x2, TInt, TMat2x2],
			[TMat2x2, TUInt, TMat2x2],
			[TMat2x2, TFloat, TMat2x2],
			[TMat2x2, TMat2x2, TMat2x2],
			[TMat3x3, TInt, TMat3x3],
			[TMat3x3, TUInt, TMat3x3],
			[TMat3x3, TFloat, TMat3x3],
			[TMat3x3, TMat3x3, TMat3x3],
			[TMat4x4, TInt, TMat4x4],
			[TMat4x4, TUInt, TMat4x4],
			[TMat4x4, TFloat, TMat4x4],
			[TMat4x4, TMat4x4, TMat4x4],
			[TMat2x3, TInt, TMat2x3],
			[TMat2x3, TUInt, TMat2x3],
			[TMat2x3, TFloat, TMat2x3],
			[TMat2x3, TMat2x3, TMat2x3],
			[TMat3x2, TInt, TMat3x2],
			[TMat3x2, TUInt, TMat3x2],
			[TMat3x2, TFloat, TMat3x2],
			[TMat3x2, TMat3x2, TMat3x2],
			[TMat2x4, TInt, TMat2x4],
			[TMat2x4, TUInt, TMat2x4],
			[TMat2x4, TFloat, TMat2x4],
			[TMat2x4, TMat2x4, TMat2x4],
			[TMat4x2, TInt, TMat4x2],
			[TMat4x2, TUInt, TMat4x2],
			[TMat4x2, TFloat, TMat4x2],
			[TMat4x2, TMat4x2, TMat4x2],
			[TMat3x4, TInt, TMat3x4],
			[TMat3x4, TUInt, TMat3x4],
			[TMat3x4, TFloat, TMat3x4],
			[TMat3x4, TMat3x4, TMat3x4],
			[TMat4x3, TInt, TMat4x3],
			[TMat4x3, TUInt, TMat4x3],
			[TMat4x3, TFloat, TMat4x3],
			[TMat4x3, TMat4x3, TMat4x3]
		],
		op: OpDiv
	}, {
		types: [
			[TInt, TInt, TInt],
			[TUInt, TInt, TUInt],
			[TFloat, TInt, TFloat],
			[TInt, TUInt, TUInt],
			[TUInt, TUInt, TUInt],
			[TFloat, TUInt, TFloat],
			[TInt, TFloat, TFloat],
			[TUInt, TFloat, TFloat],
			[TFloat, TFloat, TFloat],
			[TInt, TIVec2, TIVec2],
			[TUInt, TIVec2, TUVec2],
			[TFloat, TIVec2, TVec2],
			[TInt, TUVec2, TUVec2],
			[TUInt, TUVec2, TUVec2],
			[TFloat, TUVec2, TVec2],
			[TInt, TVec2, TVec2],
			[TUInt, TVec2, TVec2],
			[TFloat, TVec2, TVec2],
			[TInt, TIVec3, TIVec3],
			[TUInt, TIVec3, TUVec3],
			[TFloat, TIVec3, TVec3],
			[TInt, TUVec3, TUVec3],
			[TUInt, TUVec3, TUVec3],
			[TFloat, TUVec3, TVec3],
			[TInt, TVec3, TVec3],
			[TUInt, TVec3, TVec3],
			[TFloat, TVec3, TVec3],
			[TInt, TIVec4, TIVec4],
			[TUInt, TIVec4, TUVec4],
			[TFloat, TIVec4, TVec4],
			[TInt, TUVec4, TUVec4],
			[TUInt, TUVec4, TUVec4],
			[TFloat, TUVec4, TVec4],
			[TInt, TVec4, TVec4],
			[TUInt, TVec4, TVec4],
			[TFloat, TVec4, TVec4],
			[TInt, TMat2x2, TMat2x2],
			[TUInt, TMat2x2, TMat2x2],
			[TFloat, TMat2x2, TMat2x2],
			[TInt, TMat3x3, TMat3x3],
			[TUInt, TMat3x3, TMat3x3],
			[TFloat, TMat3x3, TMat3x3],
			[TInt, TMat4x4, TMat4x4],
			[TUInt, TMat4x4, TMat4x4],
			[TFloat, TMat4x4, TMat4x4],
			[TInt, TMat2x3, TMat2x3],
			[TUInt, TMat2x3, TMat2x3],
			[TFloat, TMat2x3, TMat2x3],
			[TInt, TMat3x2, TMat3x2],
			[TUInt, TMat3x2, TMat3x2],
			[TFloat, TMat3x2, TMat3x2],
			[TInt, TMat2x4, TMat2x4],
			[TUInt, TMat2x4, TMat2x4],
			[TFloat, TMat2x4, TMat2x4],
			[TInt, TMat4x2, TMat4x2],
			[TUInt, TMat4x2, TMat4x2],
			[TFloat, TMat4x2, TMat4x2],
			[TInt, TMat3x4, TMat3x4],
			[TUInt, TMat3x4, TMat3x4],
			[TFloat, TMat3x4, TMat3x4],
			[TInt, TMat4x3, TMat4x3],
			[TUInt, TMat4x3, TMat4x3],
			[TFloat, TMat4x3, TMat4x3],
			[TIVec2, TInt, TIVec2],
			[TUVec2, TInt, TUVec2],
			[TVec2, TInt, TVec2],
			[TIVec2, TUInt, TUVec2],
			[TUVec2, TUInt, TUVec2],
			[TVec2, TUInt, TVec2],
			[TIVec2, TFloat, TVec2],
			[TUVec2, TFloat, TVec2],
			[TVec2, TFloat, TVec2],
			[TIVec2, TIVec2, TIVec2],
			[TUVec2, TIVec2, TUVec2],
			[TVec2, TIVec2, TVec2],
			[TIVec2, TUVec2, TUVec2],
			[TUVec2, TUVec2, TUVec2],
			[TVec2, TUVec2, TVec2],
			[TIVec2, TVec2, TVec2],
			[TUVec2, TVec2, TVec2],
			[TVec2, TVec2, TVec2],
			[TIVec3, TInt, TIVec3],
			[TUVec3, TInt, TUVec3],
			[TVec3, TInt, TVec3],
			[TIVec3, TUInt, TUVec3],
			[TUVec3, TUInt, TUVec3],
			[TVec3, TUInt, TVec3],
			[TIVec3, TFloat, TVec3],
			[TUVec3, TFloat, TVec3],
			[TVec3, TFloat, TVec3],
			[TIVec3, TIVec3, TIVec3],
			[TUVec3, TIVec3, TUVec3],
			[TVec3, TIVec3, TVec3],
			[TIVec3, TUVec3, TUVec3],
			[TUVec3, TUVec3, TUVec3],
			[TVec3, TUVec3, TVec3],
			[TIVec3, TVec3, TVec3],
			[TUVec3, TVec3, TVec3],
			[TVec3, TVec3, TVec3],
			[TIVec4, TInt, TIVec4],
			[TUVec4, TInt, TUVec4],
			[TVec4, TInt, TVec4],
			[TIVec4, TUInt, TUVec4],
			[TUVec4, TUInt, TUVec4],
			[TVec4, TUInt, TVec4],
			[TIVec4, TFloat, TVec4],
			[TUVec4, TFloat, TVec4],
			[TVec4, TFloat, TVec4],
			[TIVec4, TIVec4, TIVec4],
			[TUVec4, TIVec4, TUVec4],
			[TVec4, TIVec4, TVec4],
			[TIVec4, TUVec4, TUVec4],
			[TUVec4, TUVec4, TUVec4],
			[TVec4, TUVec4, TVec4],
			[TIVec4, TVec4, TVec4],
			[TUVec4, TVec4, TVec4],
			[TVec4, TVec4, TVec4],
			[TMat2x2, TInt, TMat2x2],
			[TMat2x2, TUInt, TMat2x2],
			[TMat2x2, TFloat, TMat2x2],
			[TMat2x2, TMat2x2, TMat2x2],
			[TMat3x3, TInt, TMat3x3],
			[TMat3x3, TUInt, TMat3x3],
			[TMat3x3, TFloat, TMat3x3],
			[TMat3x3, TMat3x3, TMat3x3],
			[TMat4x4, TInt, TMat4x4],
			[TMat4x4, TUInt, TMat4x4],
			[TMat4x4, TFloat, TMat4x4],
			[TMat4x4, TMat4x4, TMat4x4],
			[TMat2x3, TInt, TMat2x3],
			[TMat2x3, TUInt, TMat2x3],
			[TMat2x3, TFloat, TMat2x3],
			[TMat2x3, TMat2x3, TMat2x3],
			[TMat3x2, TInt, TMat3x2],
			[TMat3x2, TUInt, TMat3x2],
			[TMat3x2, TFloat, TMat3x2],
			[TMat3x2, TMat3x2, TMat3x2],
			[TMat2x4, TInt, TMat2x4],
			[TMat2x4, TUInt, TMat2x4],
			[TMat2x4, TFloat, TMat2x4],
			[TMat2x4, TMat2x4, TMat2x4],
			[TMat4x2, TInt, TMat4x2],
			[TMat4x2, TUInt, TMat4x2],
			[TMat4x2, TFloat, TMat4x2],
			[TMat4x2, TMat4x2, TMat4x2],
			[TMat3x4, TInt, TMat3x4],
			[TMat3x4, TUInt, TMat3x4],
			[TMat3x4, TFloat, TMat3x4],
			[TMat3x4, TMat3x4, TMat3x4],
			[TMat4x3, TInt, TMat4x3],
			[TMat4x3, TUInt, TMat4x3],
			[TMat4x3, TFloat, TMat4x3],
			[TMat4x3, TMat4x3, TMat4x3]
		],
		op: OpSub
	}, {
		types: [
			[TInt, TInt, TBool],
			[TUInt, TInt, TBool],
			[TFloat, TInt, TBool],
			[TInt, TUInt, TBool],
			[TUInt, TUInt, TBool],
			[TFloat, TUInt, TBool],
			[TInt, TFloat, TBool],
			[TUInt, TFloat, TBool],
			[TFloat, TFloat, TBool]
		],
		op: OpGt
	}, {
		types: [
			[TInt, TInt, TBool],
			[TUInt, TInt, TBool],
			[TFloat, TInt, TBool],
			[TInt, TUInt, TBool],
			[TUInt, TUInt, TBool],
			[TFloat, TUInt, TBool],
			[TInt, TFloat, TBool],
			[TUInt, TFloat, TBool],
			[TFloat, TFloat, TBool]
		],
		op: OpGte
	}, {
		types: [
			[TInt, TInt, TBool],
			[TUInt, TInt, TBool],
			[TFloat, TInt, TBool],
			[TInt, TUInt, TBool],
			[TUInt, TUInt, TBool],
			[TFloat, TUInt, TBool],
			[TInt, TFloat, TBool],
			[TUInt, TFloat, TBool],
			[TFloat, TFloat, TBool]
		],
		op: OpLt
	}, {
		types: [
			[TInt, TInt, TBool],
			[TUInt, TInt, TBool],
			[TFloat, TInt, TBool],
			[TInt, TUInt, TBool],
			[TUInt, TUInt, TBool],
			[TFloat, TUInt, TBool],
			[TInt, TFloat, TBool],
			[TUInt, TFloat, TBool],
			[TFloat, TFloat, TBool]
		],
		op: OpLte
	}, {
		types: [
			[TInt, TInt, TInt],
			[TInt, TIVec2, TIVec2],
			[TInt, TIVec3, TIVec3],
			[TInt, TIVec4, TIVec4],
			[TInt, TUInt, TUInt],
			[TInt, TUVec2, TUVec2],
			[TInt, TUVec3, TUVec3],
			[TInt, TUVec4, TUVec4],
			[TIVec2, TInt, TIVec2],
			[TIVec2, TIVec2, TIVec2],
			[TIVec2, TUInt, TUVec2],
			[TIVec2, TUVec2, TUVec2],
			[TIVec3, TInt, TIVec3],
			[TIVec3, TIVec3, TIVec3],
			[TIVec3, TUInt, TUVec3],
			[TIVec3, TUVec3, TUVec3],
			[TIVec4, TInt, TIVec4],
			[TIVec4, TIVec4, TIVec4],
			[TIVec4, TUInt, TUVec4],
			[TIVec4, TUVec4, TUVec4],
			[TUInt, TInt, TUInt],
			[TUInt, TIVec2, TUVec2],
			[TUInt, TIVec3, TUVec3],
			[TUInt, TIVec4, TUVec4],
			[TUInt, TUInt, TUInt],
			[TUInt, TUVec2, TUVec2],
			[TUInt, TUVec3, TUVec3],
			[TUInt, TUVec4, TUVec4],
			[TUVec2, TInt, TUVec2],
			[TUVec2, TIVec2, TUVec2],
			[TUVec2, TUInt, TUVec2],
			[TUVec2, TUVec2, TUVec2],
			[TUVec3, TInt, TUVec3],
			[TUVec3, TIVec3, TUVec3],
			[TUVec3, TUInt, TUVec3],
			[TUVec3, TUVec3, TUVec3],
			[TUVec4, TInt, TUVec4],
			[TUVec4, TIVec4, TUVec4],
			[TUVec4, TUInt, TUVec4],
			[TUVec4, TUVec4, TUVec4]
		],
		op: OpAnd
	}, {
		types: [
			[TInt, TInt, TInt],
			[TInt, TIVec2, TIVec2],
			[TInt, TIVec3, TIVec3],
			[TInt, TIVec4, TIVec4],
			[TInt, TUInt, TUInt],
			[TInt, TUVec2, TUVec2],
			[TInt, TUVec3, TUVec3],
			[TInt, TUVec4, TUVec4],
			[TIVec2, TInt, TIVec2],
			[TIVec2, TIVec2, TIVec2],
			[TIVec2, TUInt, TUVec2],
			[TIVec2, TUVec2, TUVec2],
			[TIVec3, TInt, TIVec3],
			[TIVec3, TIVec3, TIVec3],
			[TIVec3, TUInt, TUVec3],
			[TIVec3, TUVec3, TUVec3],
			[TIVec4, TInt, TIVec4],
			[TIVec4, TIVec4, TIVec4],
			[TIVec4, TUInt, TUVec4],
			[TIVec4, TUVec4, TUVec4],
			[TUInt, TInt, TUInt],
			[TUInt, TIVec2, TUVec2],
			[TUInt, TIVec3, TUVec3],
			[TUInt, TIVec4, TUVec4],
			[TUInt, TUInt, TUInt],
			[TUInt, TUVec2, TUVec2],
			[TUInt, TUVec3, TUVec3],
			[TUInt, TUVec4, TUVec4],
			[TUVec2, TInt, TUVec2],
			[TUVec2, TIVec2, TUVec2],
			[TUVec2, TUInt, TUVec2],
			[TUVec2, TUVec2, TUVec2],
			[TUVec3, TInt, TUVec3],
			[TUVec3, TIVec3, TUVec3],
			[TUVec3, TUInt, TUVec3],
			[TUVec3, TUVec3, TUVec3],
			[TUVec4, TInt, TUVec4],
			[TUVec4, TIVec4, TUVec4],
			[TUVec4, TUInt, TUVec4],
			[TUVec4, TUVec4, TUVec4]
		],
		op: OpOr
	}, {
		types: [
			[TInt, TInt, TInt],
			[TInt, TIVec2, TIVec2],
			[TInt, TIVec3, TIVec3],
			[TInt, TIVec4, TIVec4],
			[TInt, TUInt, TUInt],
			[TInt, TUVec2, TUVec2],
			[TInt, TUVec3, TUVec3],
			[TInt, TUVec4, TUVec4],
			[TIVec2, TInt, TIVec2],
			[TIVec2, TIVec2, TIVec2],
			[TIVec2, TUInt, TUVec2],
			[TIVec2, TUVec2, TUVec2],
			[TIVec3, TInt, TIVec3],
			[TIVec3, TIVec3, TIVec3],
			[TIVec3, TUInt, TUVec3],
			[TIVec3, TUVec3, TUVec3],
			[TIVec4, TInt, TIVec4],
			[TIVec4, TIVec4, TIVec4],
			[TIVec4, TUInt, TUVec4],
			[TIVec4, TUVec4, TUVec4],
			[TUInt, TInt, TUInt],
			[TUInt, TIVec2, TUVec2],
			[TUInt, TIVec3, TUVec3],
			[TUInt, TIVec4, TUVec4],
			[TUInt, TUInt, TUInt],
			[TUInt, TUVec2, TUVec2],
			[TUInt, TUVec3, TUVec3],
			[TUInt, TUVec4, TUVec4],
			[TUVec2, TInt, TUVec2],
			[TUVec2, TIVec2, TUVec2],
			[TUVec2, TUInt, TUVec2],
			[TUVec2, TUVec2, TUVec2],
			[TUVec3, TInt, TUVec3],
			[TUVec3, TIVec3, TUVec3],
			[TUVec3, TUInt, TUVec3],
			[TUVec3, TUVec3, TUVec3],
			[TUVec4, TInt, TUVec4],
			[TUVec4, TIVec4, TUVec4],
			[TUVec4, TUInt, TUVec4],
			[TUVec4, TUVec4, TUVec4]
		],
		op: OpXor
	}, {
		types: [[TBool, TBool, TBool]],
		op: OpBoolAnd
	}, {
		types: [[TBool, TBool, TBool]],
		op: OpBoolOr
	}, {
		types: [
			[TInt, TInt, TInt],
			[TInt, TUInt, TInt],
			[TIVec2, TInt, TIVec2],
			[TIVec2, TIVec2, TIVec2],
			[TIVec2, TUInt, TIVec2],
			[TIVec2, TUVec2, TIVec2],
			[TIVec3, TInt, TIVec3],
			[TIVec3, TIVec3, TIVec3],
			[TIVec3, TUInt, TIVec3],
			[TIVec3, TUVec3, TIVec3],
			[TIVec4, TInt, TIVec4],
			[TIVec4, TIVec4, TIVec4],
			[TIVec4, TUInt, TIVec4],
			[TIVec4, TUVec4, TIVec4],
			[TUInt, TInt, TUInt],
			[TUInt, TUInt, TUInt],
			[TUVec2, TInt, TUVec2],
			[TUVec2, TIVec2, TUVec2],
			[TUVec2, TUInt, TUVec2],
			[TUVec2, TUVec2, TUVec2],
			[TUVec3, TInt, TUVec3],
			[TUVec3, TIVec3, TUVec3],
			[TUVec3, TUInt, TUVec3],
			[TUVec3, TUVec3, TUVec3],
			[TUVec4, TInt, TUVec4],
			[TUVec4, TIVec4, TUVec4],
			[TUVec4, TUInt, TUVec4],
			[TUVec4, TUVec4, TUVec4]
		],
		op: OpShl
	}, {
		types: [
			[TInt, TInt, TInt],
			[TInt, TUInt, TInt],
			[TIVec2, TInt, TIVec2],
			[TIVec2, TIVec2, TIVec2],
			[TIVec2, TUInt, TIVec2],
			[TIVec2, TUVec2, TIVec2],
			[TIVec3, TInt, TIVec3],
			[TIVec3, TIVec3, TIVec3],
			[TIVec3, TUInt, TIVec3],
			[TIVec3, TUVec3, TIVec3],
			[TIVec4, TInt, TIVec4],
			[TIVec4, TIVec4, TIVec4],
			[TIVec4, TUInt, TIVec4],
			[TIVec4, TUVec4, TIVec4],
			[TUInt, TInt, TUInt],
			[TUInt, TUInt, TUInt],
			[TUVec2, TInt, TUVec2],
			[TUVec2, TIVec2, TUVec2],
			[TUVec2, TUInt, TUVec2],
			[TUVec2, TUVec2, TUVec2],
			[TUVec3, TInt, TUVec3],
			[TUVec3, TIVec3, TUVec3],
			[TUVec3, TUInt, TUVec3],
			[TUVec3, TUVec3, TUVec3],
			[TUVec4, TInt, TUVec4],
			[TUVec4, TIVec4, TUVec4],
			[TUVec4, TUInt, TUVec4],
			[TUVec4, TUVec4, TUVec4]
		],
		op: OpShr
	}, {
		types: [
			[TInt, TInt, TInt],
			[TInt, TIVec2, TIVec2],
			[TInt, TIVec3, TIVec3],
			[TInt, TIVec4, TIVec4],
			[TInt, TUInt, TUInt],
			[TInt, TUVec2, TUVec2],
			[TInt, TUVec3, TUVec3],
			[TInt, TUVec4, TUVec4],
			[TIVec2, TInt, TIVec2],
			[TIVec2, TIVec2, TIVec2],
			[TIVec2, TUInt, TUVec2],
			[TIVec2, TUVec2, TUVec2],
			[TIVec3, TInt, TIVec3],
			[TIVec3, TIVec3, TIVec3],
			[TIVec3, TUInt, TUVec3],
			[TIVec3, TUVec3, TUVec3],
			[TIVec4, TInt, TIVec4],
			[TIVec4, TIVec4, TIVec4],
			[TIVec4, TUInt, TUVec4],
			[TIVec4, TUVec4, TUVec4],
			[TUInt, TInt, TUInt],
			[TUInt, TIVec2, TUVec2],
			[TUInt, TIVec3, TUVec3],
			[TUInt, TIVec4, TUVec4],
			[TUInt, TUInt, TUInt],
			[TUInt, TUVec2, TUVec2],
			[TUInt, TUVec3, TUVec3],
			[TUInt, TUVec4, TUVec4],
			[TUVec2, TInt, TUVec2],
			[TUVec2, TIVec2, TUVec2],
			[TUVec2, TUInt, TUVec2],
			[TUVec2, TUVec2, TUVec2],
			[TUVec3, TInt, TUVec3],
			[TUVec3, TIVec3, TUVec3],
			[TUVec3, TUInt, TUVec3],
			[TUVec3, TUVec3, TUVec3],
			[TUVec4, TInt, TUVec4],
			[TUVec4, TIVec4, TUVec4],
			[TUVec4, TUInt, TUVec4],
			[TUVec4, TUVec4, TUVec4]
		],
		op: OpMod
	}];
}
#end

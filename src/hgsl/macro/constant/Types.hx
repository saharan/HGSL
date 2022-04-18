package hgsl.macro.constant;

#if macro
enum ConstValue {
	VScalar(v:ScalarConstValue);
	VVector(v:VectorConstValue);
	VMatrix(v:MatrixConstValue);
	VStruct(v:Array<{name:String, value:ConstValue}>);
	VArray(vs:Array<ConstValue>);
	VFunc(funcs:Array<GFunc>, sideEffectSource:Null<Source>);
}

enum ScalarConstValue {
	VFloat(v:Float);
	VInt(v:Int);
	VUInt(v:UInt);
	VBool(v:Bool);
}

enum VectorConstValue {
	VVec(v:VecBase<Float>);
	VIVec(v:VecBase<Int>);
	VUVec(v:VecBase<UInt>);
	VBVec(v:VecBase<Bool>);
}

enum MatrixConstValue {
	VMat(v:MatBase);
}
#end

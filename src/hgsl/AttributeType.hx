package hgsl;

enum AttributeType {
	Float;
	Int;
	UInt;
	Vec(dim:Int);
	IVec(dim:Int);
	UVec(dim:Int);
	Mat(cols:Int, rows:Int);
}

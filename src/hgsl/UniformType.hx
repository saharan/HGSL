package hgsl;

enum UniformType {
	Float;
	Int;
	UInt;
	Bool;
	Vec(dim:Int);
	IVec(dim:Int);
	UVec(dim:Int);
	BVec(dim:Int);
	Mat(cols:Int, rows:Int);
	Sampler(type:SamplerType);
	Array(type:UniformType, size:Int);
	Struct;
}

enum SamplerType {
	Sampler2D;
	Sampler3D;
	SamplerCube;
	SamplerCubeShadow;
	Sampler2DShadow;
	Sampler2DArray;
	Sampler2DArrayShadow;
	ISampler2D;
	ISampler3D;
	ISamplerCube;
	ISampler2DArray;
	USampler2D;
	USampler3D;
	USamplerCube;
	USampler2DArray;
}

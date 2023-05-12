package hgsl.macro;

import hgsl.macro.ParsedFunction;

#if macro
final RESERVED_PREFIX = "hg_";
final BASE_PATH = "hgsl";
final BASE_PACK = BASE_PATH.split(".");
final STRUCT_MODULE_NAME = "ShaderStruct";
final STRUCT_MODULE_PATH = BASE_PATH + "." + STRUCT_MODULE_NAME;
final TYPES_MODULE_NAME = "Types";
final TYPES_MODULE_PATH = BASE_PATH + "." + TYPES_MODULE_NAME;
final STD_TYPES_MODULE = "StdTypes";
final GLOBAL_MODULE_NAME = "Global";
final GLOBAL_MODULE_PATH = BASE_PATH + "." + GLOBAL_MODULE_NAME;
final SHADER_MAIN_MODULE_NAME = "ShaderMain";
final SHADER_MAIN_MODULE_PATH = BASE_PATH + "." + SHADER_MAIN_MODULE_NAME;
final SHADER_MODULE_MODULE_NAME = "ShaderModule";
final SHADER_MODULE_MODULE_PATH = BASE_PATH + "." + SHADER_MODULE_MODULE_NAME;
final SHADER_STRUCT_MODULE_NAME = "ShaderStruct";
final SHADER_STRUCT_MODULE_PATH = BASE_PATH + "." + SHADER_STRUCT_MODULE_NAME;
final VOID_NAME = "Void";
final FLOAT_NAME = "Float";
final VEC2_NAME = "Vec2";
final VEC3_NAME = "Vec3";
final VEC4_NAME = "Vec4";
final INT_NAME = "Int";
final IVEC2_NAME = "IVec2";
final IVEC3_NAME = "IVec3";
final IVEC4_NAME = "IVec4";
final UINT_NAME = "UInt";
final UVEC2_NAME = "UVec2";
final UVEC3_NAME = "UVec3";
final UVEC4_NAME = "UVec4";
final BOOL_NAME = "Bool";
final BVEC2_NAME = "BVec2";
final BVEC3_NAME = "BVec3";
final BVEC4_NAME = "BVec4";
final MAT2_NAME = "Mat2x2";
final MAT3_NAME = "Mat3x3";
final MAT4_NAME = "Mat4x4";
final MAT2X3_NAME = "Mat2x3";
final MAT3X2_NAME = "Mat3x2";
final MAT2X4_NAME = "Mat2x4";
final MAT4X2_NAME = "Mat4x2";
final MAT3X4_NAME = "Mat3x4";
final MAT4X3_NAME = "Mat4x3";
final SAMPLER2D_NAME = "Sampler2D";
final SAMPLER3D_NAME = "Sampler3D";
final SAMPLERCUBE_NAME = "SamplerCube";
final SAMPLERCUBESHADOW_NAME = "SamplerCubeShadow";
final SAMPLER2DSHADOW_NAME = "Sampler2DShadow";
final SAMPLER2DARRAY_NAME = "Sampler2DArray";
final SAMPLER2DARRAYSHADOW_NAME = "Sampler2DArrayShadow";
final ISAMPLER2D_NAME = "ISampler2D";
final ISAMPLER3D_NAME = "ISampler3D";
final ISAMPLERCUBE_NAME = "ISamplerCube";
final ISAMPLER2DARRAY_NAME = "ISampler2DArray";
final USAMPLER2D_NAME = "USampler2D";
final USAMPLER3D_NAME = "USampler3D";
final USAMPLERCUBE_NAME = "USamplerCube";
final USAMPLER2DARRAY_NAME = "USampler2DArray";
final ARRAY_NAME = "Array";
final MAX_ARRAY_SIZE = 65536;

typedef GStructField = NamedType & {
	pos:Position
}

@:forward(iterator, length, map, copy, sort)
abstract GStructFields(Array<GStructField>) to Array<GStructField> {
	function new(fields:Array<GStructField>) {
		this = fields;
		final map:Map<String, Bool> = new Map();
		for (field in this) {
			if (map.exists(field.name))
				addError("duplicate field name: " + field.name, field.pos);
			map[field.name] = true;
		}
	}

	@:from
	static function fromArray(fields:Array<GStructField>):GStructFields {
		return new GStructFields(fields);
	}
}

enum GType {
	TVoid;
	TFloat;
	TVec2;
	TVec3;
	TVec4;
	TInt;
	TIVec2;
	TIVec3;
	TIVec4;
	TUInt;
	TUVec2;
	TUVec3;
	TUVec4;
	TBool;
	TBVec2;
	TBVec3;
	TBVec4;
	TMat2x2;
	TMat3x3;
	TMat4x4;
	TMat2x3;
	TMat3x2;
	TMat2x4;
	TMat4x2;
	TMat3x4;
	TMat4x3;
	TSampler2D;
	TSampler3D;
	TSamplerCube;
	TSamplerCubeShadow;
	TSampler2DShadow;
	TSampler2DArray;
	TSampler2DArrayShadow;
	TISampler2D;
	TISampler3D;
	TISamplerCube;
	TISampler2DArray;
	TUSampler2D;
	TUSampler3D;
	TUSamplerCube;
	TUSampler2DArray;
	TStruct(fields:GStructFields);
	TArray(type:GType, size:ArraySize);
	TFunc(f:GFuncType);
	TFuncs(fs:Array<GFuncType>);
}

typedef NamedType = {
	name:String,
	type:GType
}

typedef GFuncType = {
	args:Array<NamedType>,
	ret:GType
}

enum ArraySize {
	Resolved(count:Int);
	Delayed(path:Expr);
}

enum ElementType {
	TFloat;
	TInt;
	TUInt;
	TBool;
}

typedef GInternalType = {
	type:GType,
	lvalue:Bool,
	cvalue:Null<ConstValue>
}

enum LocalVarKind {
	Mutable;
	Immutable;
	Const(cvalue:ConstValue);
}

enum ArgumentVarKind {
	In;
	InOut;
}

typedef GArgumentVar = {
	kind:ArgumentVarKind,
	turnedGlobal:Bool,
	namePlaceholder:Placeholder,
	functionHead:Source
}

enum GGlobalVarKind {
	Mutable;
	Const(cvalue:ConstValue);
}

enum VariableLocation {
	Unspecified;
	Specified(location:Int);
}

enum VaryingKind {
	Centroid;
	Smooth;
	Flat;
}

typedef Placeholder = {
	str:String
}

typedef GLocalVar = {
	kind:LocalVarKind,
	turnedGlobal:Bool,
	typeBeforeNameAndSpacePlaceholder:Placeholder,
	namePlaceholder:Placeholder,
	typeAfterNamePlaceholder:Placeholder
}

@:forward(join, length)
abstract TypeStringPair(Array<String>) from Array<String> {
	@:arrayAccess
	public function at(i:Int):String {
		return this[i];
	}

	@:commutative
	@:op(A + B)
	static function addString(a:TypeStringPair, b:String):Void {
		throw ierror(macro "possibly unintended cast");
	}
}

enum GVarKind {
	Uniform;
	Attribute(location:VariableLocation);
	Color(location:VariableLocation);
	Varying(kind:VaryingKind);
	BuiltIn(kind:GBuiltInVariableKind);
	Global(kind:GGlobalVarKind);
	GlobalConstUnparsed(e:Expr);
	GlobalConstParsing();
	Local(v:GLocalVar);
	Argument(v:GArgumentVar);
}

typedef GeneratedFunctionEntry = {
	names:Array<String>,
	cvalue:Null<ConstValue>
}

typedef FunctionParseResult = {
	generatedName:String,
	cvalue:Null<ConstValue>
}

enum VariableAccessResult {
	RGlobal;
	RGlobalGenerated(v:GVar);
	RLocal;
	RFunc;
}

enum GBuiltInVariableKind {
	VertexIn;
	VertexOut;
	FragmentIn;
	FragmentOut;
}

typedef GVar = NamedType & {
	kind:GVarKind,
	field:Null<Field>,
	pos:Position
}

typedef GFuncArg = NamedType & {
	isRef:Bool
}

enum GFuncRegion {
	All;
	Vertex;
	Fragment;
}

typedef GFuncBase = {
	type:GType,
	args:Array<GFuncArg>,
}

enum GFuncKind {
	BuiltIn;
	BuiltInConstructor;
	User(data:UserFuncData);
}

typedef UserFuncData = {
	expr:Expr,
	field:Field,
	env:Environment
}

typedef GFunc = GFuncBase & {
	name:String,
	region:GFuncRegion,
	generic:Bool,
	kind:GFuncKind,
	pos:Position,
	parsed:Bool
}

enum GField {
	FVar(v:GVar);
	FFunc(f:GFunc);
}

enum GShaderKind {
	Vertex;
	Fragment;
	Module;
	VertexOrFragment; // used to parse unvisited functions in non-module shaders
}

enum CalleeType {
	CExpr;
	CFunc(name:String, funcs:Array<GFunc>);
}

enum ConstructorKind {
	Scalar;
	Vec(dim:Int);
	Mat(cols:Int, rows:Int);
}

enum ConstructorMode {
	Scalar;
	VecFromScalar;
	VecFromMat;
	VecFromVecTruncate;
	VecFromVecs;
	MatFromScalar(cols:Int, rows:Int);
	MatFromVecs(cols:Int, rows:Int);
	MatFromMat(cols:Int, rows:Int);
}

typedef BinopType = {
	op:Binop,
	func:GFuncBase,
	constFunc:(a:ConstValue, b:ConstValue) -> ConstValue
}

typedef UnopType = {
	op:Unop,
	func:GFuncBase,
	postFix:Bool,
	constFunc:(a:ConstValue) -> ConstValue
}
#end

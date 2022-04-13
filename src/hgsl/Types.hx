package hgsl;

// ints

@:coreType
@:build(hgsl.macro.Builder.buildBaseType())
extern abstract Int from StdTypes.Int to StdTypes.Int to UInt to Float {
	private function dummy():Void;
}

@:coreType
@:build(hgsl.macro.Builder.buildBaseType())
extern abstract IVec2 to UVec2 to Vec2 {
	var length(get, never):Int;

	private function get_length():Int;

	@:op([])
	private function get(i:Int):Int;

	@:op([])
	private function set(i:Int, v:Int):Int;
}

@:coreType
@:build(hgsl.macro.Builder.buildBaseType())
extern abstract IVec3 to UVec3 to Vec3 {
	var length(get, never):Int;

	private function get_length():Int;

	@:op([])
	private function get(i:Int):Int;

	@:op([])
	private function set(i:Int, v:Int):Int;
}

@:coreType
@:build(hgsl.macro.Builder.buildBaseType())
extern abstract IVec4 to UVec4 to Vec4 {
	var length(get, never):Int;

	private function get_length():Int;

	@:op([])
	private function get(i:Int):Int;

	@:op([])
	private function set(i:Int, v:Int):Int;
}

// uints

@:coreType
@:build(hgsl.macro.Builder.buildBaseType())
extern abstract UInt from StdTypes.Int to Float {
	private function dummy():Void;
}

@:coreType
@:build(hgsl.macro.Builder.buildBaseType())
extern abstract UVec2 to Vec2 {
	var length(get, never):Int;

	private function get_length():Int;

	@:op([])
	private function get(i:Int):UInt;

	@:op([])
	private function set(i:Int, v:UInt):UInt;
}

@:coreType
@:build(hgsl.macro.Builder.buildBaseType())
extern abstract UVec3 to Vec3 {
	var length(get, never):Int;

	private function get_length():Int;

	@:op([])
	private function get(i:Int):UInt;

	@:op([])
	private function set(i:Int, v:UInt):UInt;
}

@:coreType
@:build(hgsl.macro.Builder.buildBaseType())
extern abstract UVec4 to Vec4 {
	var length(get, never):Int;

	private function get_length():Int;

	@:op([])
	private function get(i:Int):UInt;

	@:op([])
	private function set(i:Int, v:UInt):UInt;
}

// floats

@:coreType
@:build(hgsl.macro.Builder.buildBaseType())
extern abstract Float from StdTypes.Float {
	private function dummy():Void;
}

@:coreType
@:build(hgsl.macro.Builder.buildBaseType())
extern abstract Vec2 {
	var length(get, never):Int;

	private function get_length():Int;

	@:op([])
	private function get(i:Int):Float;

	@:op([])
	private function set(i:Int, v:Float):Float;
}

@:coreType
@:build(hgsl.macro.Builder.buildBaseType())
extern abstract Vec3 {
	var length(get, never):Int;

	private function get_length():Int;

	@:op([])
	private function get(i:Int):Float;

	@:op([])
	private function set(i:Int, v:Float):Float;
}

@:coreType
@:build(hgsl.macro.Builder.buildBaseType())
extern abstract Vec4 {
	var length(get, never):Int;

	private function get_length():Int;

	@:op([])
	private function get(i:Int):Float;

	@:op([])
	private function set(i:Int, v:Float):Float;
}

// bools

@:coreType
@:build(hgsl.macro.Builder.buildBaseType())
extern abstract Bool from StdTypes.Bool to StdTypes.Bool {
	private function dummy():Void;
}

@:coreType
@:build(hgsl.macro.Builder.buildBaseType())
extern abstract BVec2 {
	var length(get, never):Int;

	private function get_length():Int;

	@:op([])
	private function get(i:Int):Bool;

	@:op([])
	private function set(i:Int, v:Bool):Bool;
}

@:coreType
@:build(hgsl.macro.Builder.buildBaseType())
extern abstract BVec3 {
	var length(get, never):Int;

	private function get_length():Int;

	@:op([])
	private function get(i:Int):Bool;

	@:op([])
	private function set(i:Int, v:Bool):Bool;
}

@:coreType
@:build(hgsl.macro.Builder.buildBaseType())
extern abstract BVec4 {
	var length(get, never):Int;

	private function get_length():Int;

	@:op([])
	private function get(i:Int):Bool;

	@:op([])
	private function set(i:Int, v:Bool):Bool;
}

// mats

typedef Mat2 = Mat2x2;
typedef Mat3 = Mat3x3;
typedef Mat4 = Mat4x4;

@:coreType
@:build(hgsl.macro.Builder.buildBaseType())
extern abstract Mat2x2 {
	var length(get, never):Int;

	private function get_length():Int;

	@:op([])
	private function get(i:Int):Vec2;

	@:op([])
	private function set(i:Int, v:Vec2):Vec2;
}

@:coreType
@:build(hgsl.macro.Builder.buildBaseType())
extern abstract Mat3x3 {
	var length(get, never):Int;

	private function get_length():Int;

	@:op([])
	private function get(i:Int):Vec3;

	@:op([])
	private function set(i:Int, v:Vec3):Vec3;
}

@:coreType
@:build(hgsl.macro.Builder.buildBaseType())
extern abstract Mat4x4 {
	var length(get, never):Int;

	private function get_length():Int;

	@:op([])
	private function get(i:Int):Vec4;

	@:op([])
	private function set(i:Int, v:Vec4):Vec4;
}

@:coreType
@:build(hgsl.macro.Builder.buildBaseType())
extern abstract Mat2x3 {
	var length(get, never):Int;

	private function get_length():Int;

	@:op([])
	private function get(i:Int):Vec3;

	@:op([])
	private function set(i:Int, v:Vec3):Vec3;
}

@:coreType
@:build(hgsl.macro.Builder.buildBaseType())
extern abstract Mat3x2 {
	var length(get, never):Int;

	private function get_length():Int;

	@:op([])
	private function get(i:Int):Vec2;

	@:op([])
	private function set(i:Int, v:Vec2):Vec2;
}

@:coreType
@:build(hgsl.macro.Builder.buildBaseType())
extern abstract Mat2x4 {
	var length(get, never):Int;

	private function get_length():Int;

	@:op([])
	private function get(i:Int):Vec4;

	@:op([])
	private function set(i:Int, v:Vec4):Vec4;
}

@:coreType
@:build(hgsl.macro.Builder.buildBaseType())
extern abstract Mat4x2 {
	var length(get, never):Int;

	private function get_length():Int;

	@:op([])
	private function get(i:Int):Vec2;

	@:op([])
	private function set(i:Int, v:Vec2):Vec2;
}

@:coreType
@:build(hgsl.macro.Builder.buildBaseType())
extern abstract Mat3x4 {
	var length(get, never):Int;

	private function get_length():Int;

	@:op([])
	private function get(i:Int):Vec4;

	@:op([])
	private function set(i:Int, v:Vec4):Vec4;
}

@:coreType
@:build(hgsl.macro.Builder.buildBaseType())
extern abstract Mat4x3 {
	var length(get, never):Int;

	private function get_length():Int;

	@:op([])
	private function get(i:Int):Vec3;

	@:op([])
	private function set(i:Int, v:Vec3):Vec3;
}

// samplers

@:coreType
extern abstract Sampler2D {
}

@:coreType
extern abstract Sampler3D {
}

@:coreType
extern abstract SamplerCube {
}

@:coreType
extern abstract SamplerCubeShadow {
}

@:coreType
extern abstract Sampler2DShadow {
}

@:coreType
extern abstract Sampler2DArray {
}

@:coreType
extern abstract Sampler2DArrayShadow {
}

// isamplers

@:coreType
extern abstract ISampler2D {
}

@:coreType
extern abstract ISampler3D {
}

@:coreType
extern abstract ISamplerCube {
}

@:coreType
extern abstract ISampler2DArray {
}

// usamplers

@:coreType
extern abstract USampler2D {
}

@:coreType
extern abstract USampler3D {
}

@:coreType
extern abstract USamplerCube {
}

@:coreType
extern abstract USampler2DArray {
}

@:coreType
extern abstract Array<T, @:const N:StdTypes.Int> from std.Array<T> {
	var length(get, never):Int;

	private function get_length():Int;

	@:noCompletion
	function iterator():Iterator<T>;

	@:op([])
	private function get(i:Int):T;

	@:op([])
	private function set(i:Int, a:T):T;
}

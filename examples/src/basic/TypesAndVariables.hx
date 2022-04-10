package basic;

import hgsl.Global.*;
import hgsl.Types;
import hgsl.ShaderMain;
import hgsl.ShaderModule;
import hgsl.ShaderStruct;

// define a named structure
private class NamedStruct extends ShaderStruct {
	var a:Float;
	var b:{foo:Int, bar:Bool}; // anonymous structures can also be used
	var c:Mat2;
}

class TypesAndVariables extends ShaderMain {
	@attribute var vFloat:Float; // vertex attribute without location, NOT equivalent to @attribute(0)
	@attribute(1) var vVec2:Vec2; // vertex attribute with location

	@varying var vVec3:Vec3; // smooth varying
	@varying(centroid) var vVec4:Vec4; // smooth varying with centroid
	@varying(flat) var vInt:Int; // integer varyings must be specified flat

	@color var vIVec2:IVec2; // output color wihtout location, equivalent to @color(0)
	@color(1) var vIVec3:IVec3; // output color with location
	@color(2) var vIVec4:IVec4;

	var vUInt:UInt;
	var vUVec2:UVec2;
	var vUVec3:UVec3;
	var vUVec4:UVec4;
	var vBool:Bool;
	var vBVec2:BVec2;
	var vBVec3:BVec3;
	var vBVec4:BVec4;
	var vMat2x2:Mat2x2; // Mat2 can be used as an alias of Mat2x2
	var vMat3x3:Mat3x3; // Mat3 can be used as an alias of Mat3x3
	var vMat4x4:Mat4x4; // Mat4 can be used as an alias of Mat4x4
	var vMat2x3:Mat2x3;
	var vMat3x2:Mat3x2;
	var vMat2x4:Mat2x4;
	var vMat4x2:Mat4x2;
	var vMat3x4:Mat3x4;
	var vMat4x3:Mat4x3;

	@uniform var vSampler2D:Sampler2D; // samplers must be uniform
	@uniform var vSampler3D:Sampler3D;
	@uniform var vSamplerCube:SamplerCube;
	@uniform var vSamplerCubeShadow:SamplerCubeShadow;
	@uniform var vSampler2DShadow:Sampler2DShadow;
	@uniform var vSampler2DArray:Sampler2DArray;
	@uniform var vSampler2DArrayShadow:Sampler2DArrayShadow;
	@uniform var vISampler2D:ISampler2D;
	@uniform var vISampler3D:ISampler3D;
	@uniform var vISamplerCube:ISamplerCube;
	@uniform var vISampler2DArray:ISampler2DArray;
	@uniform var vUSampler2D:USampler2D;
	@uniform var vUSampler3D:USampler3D;
	@uniform var vUSamplerCube:USamplerCube;
	@uniform var vUSampler2DArray:USampler2DArray;

	var vNamedStruct:NamedStruct; // structure defined above
	var vStruct:{a:Int, b:Mat3, c:IVec4}; // anonymous structures can be used
	var vNestedStruct:{some:Int, nested:{structure:NamedStruct}}; // structures can be nested

	var vArray:Array<Vec3, 16>; // array size must be explicitly specified

	// var vNestedArray:Array<Array<Float, 2>, 2>; // ERROR! multidimensional array is not supported
	// vertex shader entry point
	function vertex():Void {
		vNestedStruct.nested.structure.b.bar; // field access
	}

	// fragment shader entry point
	function fragment():Void {
		vArray[3]; // array access
	}
}

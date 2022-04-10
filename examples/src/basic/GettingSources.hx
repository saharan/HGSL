package basic;

import hgsl.Global.*;
import hgsl.Types;
import hgsl.ShaderMain;
import hgsl.ShaderModule;

class SomeModule extends ShaderModule {
	final CONST1 = 1;
	final CONST2 = 2;
	final CONST3 = vec3(1, 2, 3);
}

private class SimpleShader extends ShaderMain {
	@uniform var transform:Mat4;
	@uniform var transformNormal:Mat3;
	@uniform var tex:Sampler2D;

	@attribute(0) var aPos:Vec4;
	@attribute(1) var aNormal:Vec3;
	@attribute(2) var aColor:Vec4;
	@attribute(3) var aTexCoord:Vec2;

	@varying var normal:Vec3;
	@varying var color:Vec4;
	@varying(centroid) var texCoord:Vec2;

	@color var outColor:Vec4;

	function vertex():Void {
		gl_Position = aPos * transform;
		normal = aNormal * transformNormal;
		color = aColor;
		texCoord = aTexCoord;
	}

	function fragment():Void {
		final texColor = texture(tex, texCoord); // "final" means immutable, not necesarrily compile-time constant
		final mulColor = texColor * color;
		final lightDir = normalize(vec3(1, 2, 3));
		final lightDot = max(0, dot(lightDir, -normal));
		outColor = vec4(mulColor.rgb * lightDot, mulColor.a);
	}
}

class GettingSources { // this is NOT a shader class
	public static function printData():Void {
		trace(SimpleShader.vertexSource); // print vertex shader source code
		trace(SimpleShader.fragmentSource); // print fragment shader source code

		final attribColor = SimpleShader.attributes.aColor; // you can access vertex attributes in a type-safe manner
		trace(attribColor.location); // print the location
		trace(attribColor.name); // and the name

		final uniformTransform = SimpleShader.uniforms.transform; // uniforms as well
		trace(uniformTransform.name); // print the name
		switch uniformTransform.type {
			case Float:
			case Int:
			case UInt:
			case Bool:
			case Vec(dim):
			case IVec(dim):
			case UVec(dim):
			case BVec(dim):
			case Mat(cols, rows): // this case matches! cols = 4, rows = 4
				trace("matrix of cols = " + cols + ", rows = " + rows);
			case Sampler(type):
			case Array(type, size):
			case Struct:
		}

		trace(SomeModule.consts.CONST1); // you can access module constants from outside shaders through consts field
		trace(SomeModule.consts.CONST2);
		trace(SomeModule.consts.CONST3);
	}
}

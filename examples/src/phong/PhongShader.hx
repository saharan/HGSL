package phong;

import hgsl.ShaderMain;
import hgsl.Global.*;
import hgsl.Types;

class PhongShader extends ShaderMain {
	@attribute(0) var aPosition:Vec4;
	@attribute(1) var aColor:Vec4;
	@attribute(2) var aNormal:Vec3;
	@attribute(3) var aTexCoord:Vec2;

	@uniform var matrix:Matrix;
	@uniform var material:Material;

	@uniform var numLights:Int;
	@uniform var lights:Array<Light, Consts.MAX_LIGHTS>;

	@varying var vColor:Vec4;
	@varying var vPosition:Vec3;
	@varying var vNormal:Vec3;
	@varying var vTexCoord:Vec2;

	@color var oColor:Vec4;

	function vertex():Void {
		gl_Position = matrix.transform * aPosition;

		vColor = aColor;
		vPosition = (matrix.modelview * aPosition).xyz;
		vNormal = matrix.normal * aNormal;
		vTexCoord = aTexCoord;
	}

	// normalize without NaN
	function safeNormalize(v:Vec3):Vec3 {
		return dot(v, v) > 0 ? normalize(v) : vec3(0);
	}

	function computeBaseColor():Vec4 {
		return vColor;
	}

	function fragment():Void {
		final baseColor = computeBaseColor();
		if (baseColor.w == 0) {
			discard();
		}
		if (numLights == 0) {
			oColor = baseColor;
			return;
		}
		final eye = safeNormalize(vPosition);
		var n = safeNormalize(vNormal);
		if (!gl_FrontFacing) {
			n = -n;
		}
		var color = baseColor.xyz;
		var ambientTotal = vec3(0);
		var diffuseTotal = vec3(0);
		var specularTotal = vec3(0);
		var emissionTotal = color * material.emission;
		for (i in 0...numLights) {
			final light = lights[i];
			switch light.kind {
				case Consts.LIGHT_AMBIENT:
					ambientTotal += light.color * color * material.ambient;
				case Consts.LIGHT_DIRECTIONAL | Consts.LIGHT_POINT:
					final isDirectional = light.kind == Consts.LIGHT_DIRECTIONAL;
					final lightNormal = isDirectional ? light.normal : safeNormalize(vPosition - light.position);

					// diffuse
					final ldot = max(-dot(lightNormal, n), 0);
					diffuseTotal += light.color * color * ldot * material.diffuse;

					// specular
					if (ldot > 0) {
						final reflEye = eye - 2 * n * dot(eye, n);
						final rdot = max(-dot(reflEye, lightNormal), 0);
						specularTotal += light.color * pow(rdot, material.shininess) * material.specular;
					}
			}
		}
		oColor = vec4(ambientTotal + diffuseTotal + specularTotal + emissionTotal, baseColor.w);
	}
}

#version 300 es
precision highp int;
precision highp float;
precision highp sampler2D;
precision highp sampler3D;
precision highp samplerCube;
precision highp samplerCubeShadow;
precision highp sampler2DShadow;
precision highp sampler2DArray;
precision highp sampler2DArrayShadow;
precision highp isampler2D;
precision highp isampler3D;
precision highp isamplerCube;
precision highp isampler2DArray;
precision highp usampler2D;
precision highp usampler3D;
precision highp usamplerCube;
precision highp usampler2DArray;

struct Struct0 {
	mat4 transform;
	mat4 modelview;
	mat3 normal;
};
struct Struct1 {
	float ambient;
	float diffuse;
	float specular;
	float shininess;
	float emission;
};
struct Struct2 {
	int kind;
	vec3 position;
	vec3 color;
	vec3 normal;
};

uniform Struct0 matrix;
uniform Struct1 material;
uniform int numLights;
uniform Struct2 lights[16];
in vec4 vColor;
in vec3 vPosition;
in vec3 vNormal;
in vec2 vTexCoord;
layout(location = 0) out vec4 oColor;

vec4 computeBaseColor() {
	return vColor;
}

vec3 safeNormalize(vec3 v) {
	return dot(v, v) > 0.0 ? normalize(v) : vec3(0);
}

void main() {
	vec4 baseColor = computeBaseColor();
	if (baseColor.w == 0.0) {
		discard;
	}
	if (numLights == 0) {
		oColor = baseColor;
		return;
	}
	vec3 eye = safeNormalize(vPosition);
	vec3 n = safeNormalize(vNormal);
	if (!gl_FrontFacing) {
		n = -n;
	}
	vec3 color = baseColor.xyz;
	vec3 ambientTotal = vec3(0);
	vec3 diffuseTotal = vec3(0);
	vec3 specularTotal = vec3(0);
	vec3 emissionTotal = color * material.emission;
	for (int i = 0; i < numLights; i++) {
		Struct2 light = lights[i];
		switch (light.kind) {
		case 0:
			{
				ambientTotal += light.color * color * material.ambient;
			}
			break;
		case 1:
		case 2:
			{
				bool isDirectional = light.kind == 1;
				vec3 lightNormal = isDirectional ? light.normal : safeNormalize(vPosition - light.position);
				float ldot = max(-dot(lightNormal, n), 0.0);
				diffuseTotal += light.color * color * ldot * material.diffuse;
				if (ldot > 0.0) {
					vec3 reflEye = eye - 2.0 * n * dot(eye, n);
					float rdot = max(-dot(reflEye, lightNormal), 0.0);
					specularTotal += light.color * pow(rdot, material.shininess) * material.specular;
				}
			}
			break;
		}
	}
	oColor = vec4(ambientTotal + diffuseTotal + specularTotal + emissionTotal, baseColor.w);
}
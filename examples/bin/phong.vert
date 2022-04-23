#version 300 es

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

layout(location = 0) in vec4 aPosition;
layout(location = 1) in vec4 aColor;
layout(location = 2) in vec3 aNormal;
layout(location = 3) in vec2 aTexCoord;
uniform Struct0 matrix;
uniform Struct1 material;
uniform int numLights;
uniform Struct2[16] lights;
out vec4 vColor;
out vec3 vPosition;
out vec3 vNormal;
out vec2 vTexCoord;

void main() {
	gl_Position = matrix.transform * aPosition;
	vColor = aColor;
	vPosition = (matrix.modelview * aPosition).xyz;
	vNormal = matrix.normal * aNormal;
	vTexCoord = aTexCoord;
}
import sys.io.File;
import basic.*;
import phong.*;
import hgsl.Global.*; // required for built-in functions
import hgsl.Types; // required for built-in types
import hgsl.ShaderMain; // any shaders compiled into GLSL must extend this class
import hgsl.ShaderModule; // any shader modules (sets of common functions and constants) must extend this class
import hgsl.ShaderStruct; // any shader structures must extend this class (except for anonymous structures)

class Main {
	static function main() {
		// save phong shader example
		File.saveContent("phong.vert", PhongShader.vertexSource);
		File.saveContent("phong.frag", PhongShader.fragmentSource);
		File.saveContent("phong_textured.vert", PhongShaderTextured.vertexSource);
		File.saveContent("phong_textured.frag", PhongShaderTextured.fragmentSource);

		// just to make sure all examples will actually be compiled
		AutoTyping;
		ConstantFolding;
		FunctionType;
		GettingSources;
		ImplicitCasts;
		Inheritances;
		Modules;
		Overloads;
		TypesAndVariables;
		FunctionType;
	}
}

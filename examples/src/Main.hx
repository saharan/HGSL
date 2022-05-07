import hgsl.Source;
import sys.io.File;
import basic.*;
import phong.*;
import hgsl.Global.*; // required for built-in functions
import hgsl.Types; // required for built-in types
import hgsl.ShaderMain; // any shaders compiled into GLSL must extend this class
import hgsl.ShaderModule; // any shader modules (sets of common functions and constants) must extend this class
import hgsl.ShaderStruct; // any shader structures must extend this class (except for anonymous structures)

class Main {
	static function saveSource(name:String, source:Source):Void {
		File.saveContent(name + ".vert", source.vertex);
		File.saveContent(name + ".frag", source.fragment);
	}

	static function main() {
		// save phong shader example
		saveSource("phong", PhongShader.source);
		saveSource("phong_textured", PhongShaderTextured.source);

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
	}
}

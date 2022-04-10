package phong;

import hgsl.ShaderStruct;
import hgsl.Types;

class Material extends ShaderStruct {
	var ambient:Float;
	var diffuse:Float;
	var specular:Float;
	var shininess:Float;
	var emission:Float;
}

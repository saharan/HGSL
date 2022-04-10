package phong;

import hgsl.ShaderStruct;
import hgsl.Types;

class Light extends ShaderStruct {
	var kind:Int;
	var position:Vec3;
	var color:Vec3;
	var normal:Vec3;
}

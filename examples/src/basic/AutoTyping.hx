package basic;

import hgsl.Global.*;
import hgsl.Types;
import hgsl.ShaderModule;
import hgsl.ShaderStruct;

private class Struct1 extends ShaderStruct {
	var a:Int;
	var b:Float;
	var c:Array<Struct2, 2>;
}

private class Struct2 extends ShaderStruct {
	var pos:Vec3;
	var normal:Vec3;
}

class AutoTyping extends ShaderModule {
	function func():Void {
		var s1:Struct1; // type is explicitly specified

		var c = [{
			pos: vec3(0),
			normal: vec3(1)
		}, {
			pos: vec3(2),
			normal: vec3(3)
		}]; // type is not explicitly specified, inferred from the right hand side

		var s2 = {
			a: 1, // int
			b: 1.0, // float
			c: c, // {pos:Vec3, normal:Vec3}[2]
		} // also inferred from the right hand side

		s1 = s2; // as long as the field names, types, and orders match, you can assign one to the other
	}
}

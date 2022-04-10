package basic;

import hgsl.Global.*;
import hgsl.Types;
import hgsl.ShaderMain;
import hgsl.ShaderModule;
import hgsl.ShaderStruct;

private class CommonLogic extends ShaderModule {
	final COMMON_CONST = 5; // module fields must be a compile-time constant

	function commonFunc(x:Int):{a:Int, b:Vec2} { // you can extract common logic into a module function
		return {
			a: x,
			b: vec2(x, 1)
		}
	}
}

class Modules extends ShaderMain {
	function vertex():Void {
		final result = CommonLogic.commonFunc(123);
		result.a; // 123
		result.b; // vec2(123.0, 1.0)
	}

	function fragment():Void {
		final result = CommonLogic.commonFunc(456);
		result.a; // 456
		result.b; // vec2(456.0, 1.0)
	}
}

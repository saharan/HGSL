package basic;

import hgsl.Global.*;
import hgsl.Types;
import hgsl.ShaderMain;
import hgsl.ShaderModule;

private class Module extends ShaderModule {
	function someFunc(a:Int, b:Int):Float {
		var hoge = 123;
		return float(a + b);
	}
}

class FunctionType extends ShaderMain {
	function vertex():Void {
		final funcAlias:(x:Float, y:Float) -> Float = 1.0 > 2.0 ? min : max;
		var max = 1.0;
		funcAlias(1, 2);
	}

	function fragment():Void {
	}
}

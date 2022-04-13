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
		final funcAlias:(x:Float, y:Float) -> Float = max;
		final func = Module.someFunc;
		funcAlias(1, 2);
		func(1, 2);
	}

	function fragment():Void {
	}
}

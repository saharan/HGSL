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

	function someFunc2(func:(a:Float, b:Float) -> Float, a:Float, b:Float):Float {
		return func(a, b);
	}
}

class FunctionType extends ShaderMain {
	function vertex():Void {
		final funcAlias:(x:Float, y:Float) -> Float = false ? min : max;
		funcAlias(1, 2);
		Module.someFunc2(max, 114, 514);
		Module.someFunc2(min, 114, 514);
		Module.someFunc2(funcAlias, 114, 514);
		vertexSource;
	}

	function fragment():Void {
	}
}

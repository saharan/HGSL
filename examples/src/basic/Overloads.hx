package examples.basic;

import hgsl.Global.*;
import hgsl.Types;
import hgsl.ShaderModule;

class Overloads extends ShaderModule {
	// note: no "overload" attribute is required
	function func(a:Int, b:Int):Int {
		return 0;
	}

	function func(a:UInt, b:Float):Int {
		return 1;
	}

	function func(a:Float, b:UInt):Int {
		return 2;
	}

	function func(a:Float, b:Float):Int {
		return 3;
	}

	function someLogic():Void {
		var i:Int;
		var u:UInt;
		var f:Float;

		// overloads are resolved according to GLSL specification

		// exact matches take priority
		func(i, i); // 0
		func(u, f); // 1
		func(f, u); // 2
		func(f, f); // 3

		// the "best" match is chosen in these cases
		func(i, f); // 1
		func(f, i); // 2

		// ERROR! the best match is not obvious; choosing 1 is as good as choosing 2
		// func(u, u);
	}
}

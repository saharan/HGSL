package basic;

import hgsl.Global.*;
import hgsl.Types;
import hgsl.ShaderMain;
import hgsl.ShaderModule;

class FunctionType extends ShaderMain {
	function returnsClosure(initialValue:Int, func:Int -> Int):() -> Int {
		var value = initialValue;
		return () -> func(value++); // return closure
	}

	function vertex():Void {
		var sum = 0;
		function add(value:Int):Int {
			return sum += value; // capture local variable by reference
		}

		final c1 = returnsClosure(1, add); // pass it to another function
		final c2 = returnsClosure(100, add);
		c1(); // 1             = 1
		c1(); // 1+2           = 3
		c1(); // 1+2+3         = 6
		c2(); // 1+2+3+100     = 106
		c2(); // 1+2+3+100+101 = 207
		sum; // 207
	}

	function fragment():Void {
	}
}

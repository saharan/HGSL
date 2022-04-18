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

		final vec2Func:Vec2 -> Vec2 = a -> a;
		final toVoid:Vec2 -> Void = vec2Func; // return: covariant
		final fromInt:IVec2 -> Vec2 = vec2Func; // arguments: contravariant
		((f:IVec2 -> Void) -> f(ivec2(0)))(vec2Func); // combination, passing to another function
	}

	function fragment():Void {
	}
}

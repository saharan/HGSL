package basic;

import hgsl.Global.*;
import hgsl.Types;
import hgsl.ShaderModule;

private class Const extends ShaderModule {
	final EXTERNAL_ONE = 1;
}

class ConstantFolding extends ShaderModule {
	final ONE = ZERO + Const.EXTERNAL_ONE; // as long as no recursive definitions appear, the order does not matter
	final ZERO = int(STRUCT.X.z); // you can use type constructors to generate a compile-time constant value
	final TWO = ONE + 1;
	final TEN = ZERO + ONE * 4 + TWO * 3;
	final INTS:Array<Int, TEN> = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]; // literal array can be a compile-time constant value
	final STRUCT:{X:Vec3, Y:Vec3, Z:Vec3} = {
		X: vec3(1, 0, 0),
		Y: vec3(0, 1, 0),
		Z: vec3(0, 0, 1)
	} // also structures can be a compile-time constant value

	function func():Void {
		final FOUR = TEN / 2 - INTS[1];
		var x = 0;
		switch (3) {
			case ZERO:
				x = 0;
			case Const.EXTERNAL_ONE:
				x = 1;
			case 2:
				x = 2;
			case INTS[3]: // this case matches
				x = 3;
			case FOUR:
				x = 4;
		}
		x; // x is 3, there is no fallthrough

		final LOCAL_CONST = 2;
		var array:Array<Int, Const.EXTERNAL_ONE> = [1]; // array size can be specified using an external compile-time constant
		var array2:Array<Int, LOCAL_CONST> = [1, 2]; // ... or a local one

		final localConst = 3;
		// var array2:Array<Int, localConst> = [1, 2, 3]; // ERROR! variable for array size must start with a capital alphabet
	}
}

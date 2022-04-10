package basic;

import hgsl.Global.*;
import hgsl.Types;
import hgsl.ShaderModule;

class ImplicitCasts extends ShaderModule {
	function func():Void {
		var i:Int;
		var i2:IVec2;
		var i3:IVec3;
		var i4:IVec4;
		var u:UInt;
		var u2:UVec2;
		var u3:UVec3;
		var u4:UVec4;
		var f:Float;
		var f2:Vec2;
		var f3:Vec3;
		var f4:Vec4;

		// implicit casts are done according to GLSL specification
		// [A] can be implicitly casted to [B], where
		//   A = int, B = uint, float
		//   A = uint, B = float
		//   A = IVecN, B = UVecN, VecN
		//   A = UVecN, B = VecN

		u = i + u; // int -> uint
		f = i + f; // int -> float
		f = u + f; // uint -> float

		// i = i + u; // ERROR! implicit cast of uint -> int is not allowed
		i = int(i + u); // ... but allowed when it is done explicitly

		u2 = i2 + u2;
		f2 = i2 + f2;
		f2 = u2 + f2;
		u3 = i3 + u3;
		f3 = i3 + f3;
		f3 = u3 + f3;
		u4 = i4 + u4;
		f4 = i4 + f4;
		f4 = u4 + f4;

		u2 = i + u2; // uint + uvec2 exists, so an implicit int -> uint cast is performed
		f2 = i + f2;
		f2 = u + f2;
		u3 = i + u3;
		f3 = i + f3;
		f3 = u + f3;
		u4 = i + u4;
		f4 = i + f4;
		f4 = u + f4;

		u2 = i2 + u;
		f2 = i2 + f;
		f2 = u2 + f;
		u3 = i3 + u;
		f3 = i3 + f;
		f3 = u3 + f;
		u4 = i4 + u;
		f4 = i4 + f;
		f4 = u4 + f;

		var array:Array<Float, 5> = [1, 2, 3, 4, 5]; // float[5], implicit cast on array declaration (declaration only)
		var array2 = [1, 2, 3, 4, 5]; // int[5], no implicit cast on auto typing
		var array3 = [1.0, 2, 3, 4, 5]; // float[5], the first element takes priority
		// array = array2; // ERROR! an array is invariant (cannot be implicitly casted according to its base types)
	}
}

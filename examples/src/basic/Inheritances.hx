package basic;

import hgsl.Global.*;
import hgsl.Types;
import hgsl.ShaderMain;

private class BaseShader extends ShaderMain {
	function vertex():Void {
	}

	function fragment():Void {
		func1(); // 11
	}

	function func1():Int {
		return 10 + func2();
	}

	function func2():Int {
		return 1;
	}
}

class Shader2 extends BaseShader {
	// note: no "override" attribute is required
	function func2():Int {
		return 2; // override!
	}
}

class Shader3 extends BaseShader {
	function func2():Int {
		return super.func2() + 2; // override, but in a different way
	}
}

class Shader4 extends Shader2 {
	function func1():Int {
		return 20 + func2();
	}
}

class Inheritances {
	public function new() {
		trace(BaseShader.fragmentSource); // there will be "11"
		trace(Shader2.fragmentSource); // there will be "12"
		trace(Shader3.fragmentSource); // there will be "13"
		trace(Shader4.fragmentSource); // there will be "22"
	}
}

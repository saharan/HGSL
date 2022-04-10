package phong;

import hgsl.Global.*;
import hgsl.Types;

// extend the class to make a variant
class PhongShaderTextured extends PhongShader {
	// add another uniform
	@uniform var textureColor:Sampler2D;

	// override the color function
	function computeBaseColor():Vec4 {
		return texture(textureColor, vTexCoord) * vColor;
	}
}

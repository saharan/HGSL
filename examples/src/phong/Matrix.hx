package phong;

import hgsl.ShaderStruct;
import hgsl.Types;

class Matrix extends ShaderStruct {
	// master matrix
	var transform:Mat4;
	// modelview matrix
	var modelview:Mat4;
	// normal matrix (= transpose(inv(mat3(modelview))))
	var normal:Mat3;
}

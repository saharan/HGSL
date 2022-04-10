# HGSL: Haxe to GL Shading Language

## What is this?

This library enables you to write GLSL ES 3.0 programs (especially for WebGL 2.0) with the full help of an IDE, including any kinds of completions and type checks.

You can also use features that are not included in GLSL ES 3.0: implicit type conversions, modularization of common logic and constants, inheritances, anonymous structures, and many other things.

Everything is done at compile time, so you can use this library just to obtain GLSL source codes, or you can integrate shader classes into your project if it uses Haxe.

## Getting started

1. Install the latest [Haxe](https://haxe.org/) somewhere
1. Install [vshaxe](https://github.com/vshaxe/vshaxe) in VSCode Marketplace and configure the Haxe path
1. Create a Haxe project (`>Haxe: Initialize Project`)
1. Copy `src/hgsl` to your source folder
1. Write your shaders!

## How to use

Import `hgsl.Global.*` for built-in functions and variables, `hgsl.Types` for built-in types. Note that importing `hgsl.Types` hides standard types (`Int`, `UInt`, `Float`, `Bool`, `Array`), so make sure not to import it in any non-shader source files.

A main shader class should extend `hgsl.ShaderMain`, and implement entry-point functions for both vertex and fragment shader.

```hx
import hgsl.Global.*;
import hgsl.Types;
import hgsl.ShaderMain;

class Shader extends ShaderMain {
	function vertex():Void { // vertex shader entrypoint
	}

	function fragment():Void { // fragment shader entrypoint
	}
}
```

- Define vertex attributes using `@attribute` metadata. You can also specify layout location by `@attribute(<location>)`.
- Define uniforms using `@uniform` metadata. Defined uniforms can be used from both vertex shader part and fragment shader part.
- Define varyings using `@varying` metadata. You can specify types of varyings by `@varying(flat)` and `@varying(centroid)`.
- Define output colors using `@color` metadata. MRT (Multiple Render Targets) is available by setting location with `@color(<location>)`.

```hx
import hgsl.Global.*;
import hgsl.Types;
import hgsl.ShaderMain;

class Shader extends ShaderMain {
	@attribute(0) var position:Vec4;
	@attribute(1) var color:Vec4;
	@attribute(2) var texCoord:Vec2;
	
	@uniform var transform:Mat4;
	@uniform var colorTexture:Sampler2D;
	
	@varying var vcolor:Vec4;
	@varying(centroid) var vtexCoord:Vec2;
	
	@color var ocolor:Vec4;
	
	function vertex():Void { // vertex shader entrypoint
		gl_Position = transform * position; // built-in output position
		vcolor = color;
		vtexCoord = texCoord;
	}

	function fragment():Void { // fragment shader entrypoint
		ocolor = vcolor * texture(colorTexture, vtexCoord);
	}
}
```

TODO: write about other features...

## Examples

Can be found in [`examples`](./examples/) directory.

## Known issues

HGSL heavily uses Haxe's build macro, and it sometimes causes strange behaviors, including

- Stack overflow on compilation
- Completions getting heavier and heavier
- Shows wrong information on hover / completions does not work on certain places ([corresponding issue](https://github.com/HaxeFoundation/haxe/issues/10673))

Except for the last one, you can fix these issues by restarting Haxe's language server. Open Command Palette and choose `Haxe: Restart Language Server`.

## Questions

Send me replies on [twitter](https://twitter.com/shr_id)!
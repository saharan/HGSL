# HGSL: Haxe to GL Shading Language

## What is this?

This library enables you to write GLSL ES 3.0 programs (especially for WebGL 2.0) with the full help of an IDE, including any kinds of completions and type checks.

You can also use features that are not included in GLSL ES 3.0: implicit type conversions, modularization of common logic and constants, inheritances, anonymous structures, and many other things.

Everything is done at compile time, so you can use this library just to obtain GLSL source codes, or you can integrate shader classes into your project if it uses Haxe.

## Getting started

1. Install [Haxe](https://haxe.org/) 4.3.1 or later somewhere
1. Install [vshaxe](https://github.com/vshaxe/vshaxe) in VSCode Marketplace and configure the Haxe path
1. Create a Haxe project (`>Haxe: Initialize Project`)
1. Copy `src/hgsl` to your source folder
	- or install HGSL using [Haxelib](https://lib.haxe.org/) by `haxelib install hgsl`
1. Write your shaders!

## How to use

### Introduction

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

### Modules

You can define a shader module that contains compile-time constants and functions by extending `hgsl.ShaderModule` class.

```hx
import hgsl.Global.*;
import hgsl.Types;
import hgsl.ShaderModule;
import hgsl.ShaderMain;

class Module extends ShaderModule {
	final SOME_CONST_NUMBER:Int = 16;
	final SOME_CONST_VECTOR:Vec3 = vec3(1, 2, 3); // you can use type constructors
	final ANOTHER_CONST_NUMBER:Float = SOME_CONST_NUMBER * 2.0; // you can refer another const
	// final SIN1:Float = sin(1); // ERROR! built-in functions are not compile-time constant

	function someUtility(input:Vec3):Vec3 { // you can use this function from outside the module
		var output:Vec3 = input * 2;
		return output;
	}
}

class Shader extends ShaderMain {
	function vertex():Void {
		Module.SOME_CONST_NUMBER; // use consts
		var foo:Vec3 = Module.someUtility(vec3(1, 2, 3)); // and functions
	}

	function fragment():Void {
	}
}
```

### Automatic Typing

As long as a variable definition has an initial value, the type specification of the variable can be omitted.

```hx
import hgsl.Global.*;
import hgsl.Types;
import hgsl.ShaderModule;

class Module extends ShaderModule {
	final INT_CONST = 16; // int
	final FLOAT_CONST = 8.0; // float
	final VEC3_CONST = vec3(1, 2, 3); // vec3

	function func():Void {
		var nonConstMatrix = mat3(1); // mat3x3, also available
		                              //   for non-const variables
		// var foo; // ERROR! variable declaration without
		            //   both initial value and type is illegal
	}

	// function func2(a, b, c) { // ERROR! return type and
	// }                         //   argument types cannot be omitted
}
```

### `var` and `final`

`var` and `final` can be both used to declare a variable, but there are differences.

- `var` can be used to declare a **mutable** variable
- `final` can be used to declare an **immutable** variable
  - A `final` variable is NOT necessarily a compile-time constant
  - If a `final` variable is initialized with a compile-time constant value, then it becomes a **compile-time constant**
  - You cannot use `final` to define a field of a structure

### Structures

You can define a named structure by making a class that extends `hgsl.ShaderStruct`.

```hx
import hgsl.Types;
import hgsl.ShaderStruct;

class Struct extends ShaderStruct {
	var fieldA:Int;
	var fieldB:Vec3;
	var fieldC:Mat3x3;
}
```

Structures can be nested, but no circular reference is allowed.

```hx
import hgsl.Types;
import hgsl.ShaderStruct;

class Struct2 extends ShaderStruct {
	var nestedStruct:Struct;
	// var ng:Struct2; // ERROR! infinite recursion occurs
}

class Struct extends ShaderStruct {
	var fieldA:Int;
	var fieldB:Vec3;
	var fieldC:Mat3x3;
	// var ng:Struct2; // ERROR! this also creates an infinite loop
}
```

Anonymous structures can also be used everywhere.

```hx
import hgsl.Types;
import hgsl.ShaderStruct;
import hgsl.ShaderModule;

class Struct extends ShaderStruct {
	var fieldA:Int;
	var fieldB:Vec3;
	var fieldC:{
		var some:Vec2;
		var nested:{
			var fields:Float;
		}
	}
}

class Module extends ShaderModule {
	function func(arg:{a:Int, b:Float}):{a:Int, b:Float} {
		arg.a++;
		return arg;
	}
}

```

In fact, named structures are just type alias or syntax sugar of anonymous structures.

### Arrays

Use `Array<Type, Size>` to refer an array type. Every array must be given a compile-time constant size.

```hx
import hgsl.Types;
import hgsl.ShaderStruct;
import hgsl.ShaderModule;

class Struct extends ShaderStruct {
	var floats:Array<Float, 8>;
	var vec3s:Array<Vec3, 4>;
	var mat4s:Array<Mat4, Module.LENGTH>;  // you can refer external values
	// var ints:Array<Int, Module.length>; // ERROR! fields start with a
	                                       // lower-case alphabet cannot be used
}

class Module extends ShaderModule {
	final LENGTH = 32;
	final length = LENGTH; // ... even though it IS a compile-time constant :(
}
```

Limitation: due to the Haxe's grammar, you cannot use a field starts with a lower-case alphabet for an array size parameter, even if it is actually a compile-time constant.

### Literal arrays and structures

You can use literal arrays and structures to generate a value of an array or structure. There is **no constructor** for them.

```hx
import hgsl.Types;
import hgsl.ShaderStruct;
import hgsl.ShaderModule;

class Struct extends ShaderStruct {
	var ints:Array<Int, 3>;
	var floats:Array<Float, 5>;
	var structs:Array<{
		a:Int,
		b:Int
	}, 2>;
}

class Module extends ShaderModule {
	final CONST_STRUCT:Struct = {
		ints: [1, 2, 3],
		floats: [1.0, 2.0, 3.0, 4.0, 5.0],
		structs: [{a: 1, b: 2}, {a: 3, b: 4}]
	} // this is a compile-time constant
}
```

A literal array that consists only of compile-time constants will also be a compile-time constant value. Likewise, a literal structure that consists only of compile-time constant fields will also be a compile-time constant value.

If a certain type is **expected**, elements of a literal array will be implicitly converted.

```hx
var a = [1, 2, 3, 4, 5];                 // int[5]
var b:Array<Float, 5> = [1, 2, 3, 4, 5]; // float[5], since floats are expected
// a = b; // ERROR! cannot assign one to the other,
// b = a; // ERROR!   since Array is parameter invariant
```

If there is no expected type, the first element of an array will determine the expected type for the rest of the elements.

```hx
var a = [1.0, 2, 3, 4, 5];          // float[5]
var b = [uint(1), 2, 3, 4, 5];      // uint[5]
// var c = [1, 2.0, 3.0, 4.0, 5.0]; // ERROR! cannot convert floats to ints
```

This "expected type" rule also applies for structures.

```hx
var a:{x:Array<Float, 5>, y:UInt} = {
	x: [1, 2, 3, 4, 5], // float[5], since floats are expected
	y: 1                // uint, since uint is expected
}
var b = {
	x: [1, 2, 3, 4, 5], // int[5]
	y: 1                // int
}
// a = b; // ERROR! types are different
```

Unlike some other languages (including Haxe), the order of fields in a structure matters.

```hx
var a = {x: 1, y: 1}
var b = {y: 1, x: 1}
// a = b; // ERROR! types of these variables are different
```

This is mainly because the actual data on memory vary depending on the order of the fields, and there should be a way for users to determine the order of the fields (especially for uniform variables).

### Inheritance

You can inherit a shader to make its variances.

```hx
import hgsl.Global.*;
import hgsl.Types;
import hgsl.ShaderMain;

class Shader extends ShaderMain {
	function foo():Int {
		return 1;
	}

	function vertex():Void {
		foo(); // 1
	}

	function fragment():Void {
	}
}

class ChildShader extends Shader {
	function foo():Int { // override! make it return 2
		return 2;
	}
}
```

In the original shader (`Shader`), `1` is computed in the vertex part. However, since the function `foo` is overridden in the child shader(`ChildShader`), `2` is computed in the vertex part of the shader. Note that you do NOT need `override` qualifier to override a function.

```hx
class ChildShader extends Shader {
	function foo():Int { // override! increase the value by one
		return super.foo() + 1;
	}
}
```

You can refer parent implementations by using the keyword `super`. In this case, the result is the same as the previous one (returns `2`).

All variables will be inherited and cannot be overridden.

```hx
import hgsl.Global.*;
import hgsl.Types;
import hgsl.ShaderMain;

// a very simple shader
class Shader extends ShaderMain {
	@uniform var transform:Mat4;
	@attribute var aPos:Vec4;
	@attribute var aColor:Vec4;
	@varying var color:Vec4;
	@color var oColor:Vec4;

	function vertex():Void {
		gl_Position = transform * aPos;
		color = aColor;
	}

	function fragment():Void {
		oColor = color;
	}
}

// also a simple shader but with texturing
class ChildShader extends Shader {
	// add various fields to make it support texturing
	@uniform var tex:Sampler2D;
	@attribute var aTexCoord:Vec2;
	@varying(centroid) var texCoord:Vec2;

	function vertex():Void {
		super.vertex();
		texCoord = aTexCoord; // output texCoord as well
	}

	function fragment():Void {
		oColor = color * texture(tex, texCoord);
	}
}
```

### Overload

Overload of functions is done just like as in GLSL ES 3.0 (and many other languages). You do NOT need to use `overload` qualifier to overload functions.

```hx
import hgsl.Global.*;
import hgsl.Types;
import hgsl.ShaderModule;

class Module extends ShaderModule {
	function func(a:Int,   b:Int  ):Int { return 1; }
	function func(a:UInt,  b:Float):Int { return 2; }
	function func(a:Float, b:UInt ):Int { return 3; }
	function func(a:Float, b:Float):Int { return 4; }
	
	function func():Void {
		var i:Int, u:UInt, f:Float;
		func(i, i); // 1, exact match
		func(u, f); // 2
		func(f, u); // 3
		func(f, f); // 4
		
		func(i, f); // 2, not exact but matches "best"
		func(f, i); // 3
		
		// func(u, u); // ERROR! cannot determine which one is the "best"
	}
}
```

### Higher-Order Functions

You can define higher order functions. You can pass functions to another function. Also, you can bind a function to a compile-time constant (always use `final` keyword).

```hx
import hgsl.Global.*;
import hgsl.Types;
import hgsl.ShaderModule;

class Module extends ShaderModule {
	function func(f:(a:Int, b:Int) -> Int):Int { // receive a function
		return f(1, 2);
	}
	
	function add(a:Int, b:Int):Int {
		return a + b;
	}
	
	function passFunc():Void {
		final f = add; // bind a function as a compile-time constant
		func(f); // pass the function
		func(add); // or do it directly
	}
}
```

There are several ways to represent the type of a function.

```hx
final fpLike:   Int -> Int -> Int = Module.add; // receives Int and Int, returns Int
final named:(a:Int, b:Int) -> Int = Module.add; // the same, but with names

final higherOrder:           (Int -> Int -> Int) -> Int = Module.func;
final higherOrderNamed:(f:(a:Int, b:Int) -> Int) -> Int = Module.func;

final noArgs:Void -> Void = Module.passFunc;
final noArgs2: () -> Void = Module.passFunc; // more consistent with named ones
```

You can define local functions and capture local variables by reference.

```hx
import hgsl.Global.*;
import hgsl.Types;
import hgsl.ShaderModule;

class Module extends ShaderModule {
	function func():Void {
		var a = 1;
		function localFunc():Void {
			 final b = 2;
			 a + b; // 3
			 a *= 10;
			 a + b; // 12
		}
		localFunc();
		a; // 10
	}
}
```

You can return a local function. When it is done, **a closure** will be generated.

```hx
import hgsl.Global.*;
import hgsl.Types;
import hgsl.ShaderModule;

class Module extends ShaderModule {
	function func():() -> (() -> Int) {
		var a = 0;
		function increment():Int {
			return ++a;
		}
		return increment; // return a local function
	}
	
	function useClosure():Void {
		final c1 = func(); // a closure is generated
		c1(); // 1
		c1(); // 2
		c1(); // 3
		
		final c2 = func(); // another closure is generated
		c2(); // 1
		c2(); // 2
		
		c1(); // 4; every closure will keep its own environment
	}
}
```

You can use the arrow notation to generate an anonymous function.

```hx
import hgsl.Global.*;
import hgsl.Types;
import hgsl.ShaderModule;

class Module extends ShaderModule {
	function func():Void {
		var a = 0;
		final increment = () -> ++a;        // equivalent
		final increment2 = function():Int { // equivalent
			return ++a;
		}
		final addTyped = (a:Int, b:Int) -> a + b; // arguments are explicitly typed
		final add:Int -> Int -> Int = (a, b) -> a + b; // "expected type" helps the type inference
		// final add = (a, b) -> a + b; // ERROR! argument types are unknown
	}
}
```

Functions can be implicitly converted according to their argument types and return types.

```hx
import hgsl.Global.*;
import hgsl.Types;
import hgsl.ShaderModule;

class Module extends ShaderModule {
	function func():Void {
		final float2float:Float -> Float = a -> a;
		final float2void:Float -> Void = float2float; // safe: discard the return value
		final int2float:Int -> Float = float2float;   // safe: implicitly convert the argument
		// final float2int:Int -> Int = float2float;  // ERROR! implicit conversion from float
		                                              //   to int cannot be done
	}
}
```

### Obtain Shader Source

You can obtain source code of shaders using `vertexSource` and `fragmentSource` fields, or `vertex` and `fragment` fields inside `source` field. These fields can only be used from outside shaders.

```hx
import hgsl.Global.*;
import hgsl.Types;
import hgsl.ShaderMain;

import hgsl.Source;

class Shader extends ShaderMain {
	...
}

class Main { // this is NOT a shader class; usual Haxe rules apply here
	static function main() {
		// print the source, or do whatever you need; they are just strings
		trace(Shader.vertexSource);
		trace(Shader.fragmentSource);
		
		// extract source out of the shader, this is convenient
		//   when you have to treat multiple shaders
		final source:Source = Shader.source;
		trace(source.vertex);
		trace(source.fragment);
	}
}
```

You can also access vertex attributes and uniforms through `attributes` and `uniforms` fields, respectively. If you only want to access attribute locations or uniform names, you can also use `a` or `u` field, respectively.

```hx
import hgsl.Global.*;
import hgsl.Types;
import hgsl.ShaderMain;

import hgsl.Attribute;
import hgsl.Uniform;

class Shader extends ShaderMain {
	@uniform var transform:Mat4;
	@attribute var aPos:Vec4;
	...
}

class Main {
	static function main() {
		// print attribute information
		final aPos:Attribute = Shader.attributes.aPos;
		trace(aPos.name);     // "aPos"
		trace(aPos.type);     // Vec(4) in `AttributeType`
		trace(aPos.location); // null, since no location is given
		trace(Shader.a.aPos); // null, equals `aPos.location`
		
		// print uniform information
		final transform:Uniform = Shader.uniform.transform;
		trace(transform.name);     // "transform"
		trace(transform.type);     // Mat(4, 4) in `UniformType`
		trace(Shader.u.transform); // "transform", equals `transform.name`
	}
}
```

Note that these fields are **statically typed**, which means if you change the names of variables in the shader class and leave the main class as it is, there will be errors.

```hx
import hgsl.Global.*;
import hgsl.Types;
import hgsl.ShaderMain;

class Shader extends ShaderMain {
	@uniform var transformModified:Mat4; // modify
	@attribute var aPosModified:Vec4;    //   their names
	...
}

class Main {
	static function main() {
		// trace(Shader.attributes.aPos);   // ERROR! no such field
		// trace(Shader.uniform.transform); // ERROR! no such field too
	}
}
```

Compile-time constants in a shader can be accessed from outside shaders ONLY through `consts` or `c` field.

```hx
import hgsl.Types;
import hgsl.ShaderModule;

class Shader extends ShaderMain {
	final SOME_CONST_STRUCT = {x: 1, y: 2};
}

class Module extends ShaderModule {
	final SOME_CONST_INT = 8;
	final SOME_CONST_ARRAY = [1, 2, 3];
}

class Main { // usual Haxe class
	static function main() {
		// value of StdTypes.Int (not hgsl.Types.Int)
		trace(Module.consts.SOME_CONST_INT);
		
		// value of std.Array<StdTypes.Int> (not hgsl.Types.Array<Int, 3>)
		trace(Module.consts.SOME_CONST_ARRAY);
		
		// value of {x: StdTypes.Int, y: StdTypes.Int}
		trace(Shader.c.SOME_CONST_STRUCT);
		
		// DO NOT do this; you will obtain nothing
		// trace(Module.SOME_CONST_INT);
	}
}
```

### Operator Precedence

Due to Haxe's bizarre operator precedence, compile-time constants **may take unexpected values**.

In Haxe, priority of bitwise operators `&`, `|`, and `^` is **all the same**, which means the following two statements are the same in Haxe.

```hx
1 & 2 | 3 ^ 4 & 5;
(((1 & 2) | 3) ^ 4) & 5;
```

In most languages, however, `&` > `^` > `|` holds in terms of priority. So the following two statements are the same in those languages.

```cpp
1 & 2 | 3 ^ 4 & 5;
(1 & 2) | (3 ^ (4 & 5));
```

This is also true for GLSL. Since compiled source code of an HGSL shader will be compiled again by a GLSL compiler, precedence of operators will be the same as that of GLSL, so no worries.

When it comes to compile-time constants, however, they will be affected by Haxe's operator precedence because of **constant folding** done by HGSL.

```hx
final A = 1, B = 2, C = 3, D = 4, E = 5;
final a = A & B | C ^ D & E; // this will be folded
var   b = A & B | C ^ D & E; // this will not be folded
a == b; // false at runtime, because of the different operator precedence
        //   between Haxe and GLSL
```

To avoid this strange behavior, **always use parentheses when you use bitwise operators**.

```hx
final A = 1, B = 2, C = 3, D = 4, E = 5;
final a = (A & B) | (C ^ (D & E)); // this will be folded
var   b = (A & B) | (C ^ (D & E)); // this will not be folded
a == b; // true, yes they are the same!
```

This is also true for modulo operator `%`; in Haxe, `%` has higher priority than `*` has.
You can access [the complete operators precedence list here](https://haxe.org/manual/expression-operators-precedence.html).

To be honest, this can be technically avoided by reconstructing ASTs, but it's not done anyways. I may implement that in future, or not.

## Limitations

- Any kinds of recursive function calls are not allowed, even if it is obvious to stop within a certain depth
	- This will result in a runtime error
	- (This can actually be checked at compile time without much effort, but it's not done yet)
- Mutual reference between shaders/modules/structures may result in (non-informative) compile errors
	- "Reference" includes inheritance, function call, variable access, and type reference
	- Make sure there is no circular reference in your shaders; keep the dependencies a DAG!

## Examples

Can be found in [`examples`](./examples/) directory.

## Known issues

HGSL heavily uses Haxe's build macro, and it sometimes causes some strange behavior, including

- Stack overflow on compilation
- Completions getting heavier and heavier
- Shows wrong information on hover / completions does not work on certain places ([corresponding issue](https://github.com/HaxeFoundation/haxe/issues/10673))

Except for the last one, you can fix these issues by restarting Haxe's language server. Open Command Palette and choose `Haxe: Restart Language Server`.

For the last one, **try putting much whitespace** before the completion point. You can delete it after writing the code at the point. I know this is kind of a very bad workaround, but it works anyway and getting no completions is worse than that. I hope it gets fixed soon.
1. You got no completion candidates.  
![](https://i.imgur.com/ysDzSGO.png)
2. Put much whitespace. Double it if you still get no candidates.  
![](https://i.imgur.com/JaG9dKb.png)
3. There it is!  
![](https://imgur.com/2AooIPp.png)

## Questions

Send me replies on [twitter](https://twitter.com/shr_id)!

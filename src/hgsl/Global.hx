package hgsl;

import haxe.extern.EitherType;
import hgsl.Types;

private typedef E4<A, B, C, D> = EitherType<EitherType<A, B>, EitherType<C, D>>;
private typedef Comp1 = E4<Float, Int, UInt, Bool>;
private typedef Comp2 = E4<Vec2, IVec2, UVec2, BVec2>;
private typedef Comp3 = E4<Vec3, IVec3, UVec3, BVec3>;
private typedef Comp4 = E4<Vec4, IVec4, UVec4, BVec4>;

extern class Global {
	@:vert static final gl_VertexID:Int;
	@:vert static final gl_InstanceID:Int;
	@:vert static var gl_Position:Vec4;
	@:vert static var gl_PointSize:Float;
	@:frag static final gl_FragCoord:Vec4;
	@:frag static final gl_FrontFacing:Bool;
	@:frag static final gl_PointCoord:Vec2;
	@:frag static var gl_FragDepth:Float;

	static function discard():Void;

	overload static function radians(degrees:Float):Float;

	overload static function radians(degrees:Vec2):Vec2;

	overload static function radians(degrees:Vec3):Vec3;

	overload static function radians(degrees:Vec4):Vec4;

	overload static function degrees(radians:Float):Float;

	overload static function degrees(radians:Vec2):Vec2;

	overload static function degrees(radians:Vec3):Vec3;

	overload static function degrees(radians:Vec4):Vec4;

	overload static function sin(angle:Float):Float;

	overload static function sin(angle:Vec2):Vec2;

	overload static function sin(angle:Vec3):Vec3;

	overload static function sin(angle:Vec4):Vec4;

	overload static function cos(angle:Float):Float;

	overload static function cos(angle:Vec2):Vec2;

	overload static function cos(angle:Vec3):Vec3;

	overload static function cos(angle:Vec4):Vec4;

	overload static function tan(angle:Float):Float;

	overload static function tan(angle:Vec2):Vec2;

	overload static function tan(angle:Vec3):Vec3;

	overload static function tan(angle:Vec4):Vec4;

	overload static function asin(x:Float):Float;

	overload static function asin(x:Vec2):Vec2;

	overload static function asin(x:Vec3):Vec3;

	overload static function asin(x:Vec4):Vec4;

	overload static function acos(x:Float):Float;

	overload static function acos(x:Vec2):Vec2;

	overload static function acos(x:Vec3):Vec3;

	overload static function acos(x:Vec4):Vec4;

	overload static function atan(y:Float, x:Float):Float;

	overload static function atan(y:Vec2, x:Vec2):Vec2;

	overload static function atan(y:Vec3, x:Vec3):Vec3;

	overload static function atan(y:Vec4, x:Vec4):Vec4;

	overload static function atan(yOverX:Float):Float;

	overload static function atan(yOverX:Vec2):Vec2;

	overload static function atan(yOverX:Vec3):Vec3;

	overload static function atan(yOverX:Vec4):Vec4;

	overload static function sinh(x:Float):Float;

	overload static function sinh(x:Vec2):Vec2;

	overload static function sinh(x:Vec3):Vec3;

	overload static function sinh(x:Vec4):Vec4;

	overload static function cosh(x:Float):Float;

	overload static function cosh(x:Vec2):Vec2;

	overload static function cosh(x:Vec3):Vec3;

	overload static function cosh(x:Vec4):Vec4;

	overload static function tanh(x:Float):Float;

	overload static function tanh(x:Vec2):Vec2;

	overload static function tanh(x:Vec3):Vec3;

	overload static function tanh(x:Vec4):Vec4;

	overload static function asinh(x:Float):Float;

	overload static function asinh(x:Vec2):Vec2;

	overload static function asinh(x:Vec3):Vec3;

	overload static function asinh(x:Vec4):Vec4;

	overload static function acosh(x:Float):Float;

	overload static function acosh(x:Vec2):Vec2;

	overload static function acosh(x:Vec3):Vec3;

	overload static function acosh(x:Vec4):Vec4;

	overload static function atanh(x:Float):Float;

	overload static function atanh(x:Vec2):Vec2;

	overload static function atanh(x:Vec3):Vec3;

	overload static function atanh(x:Vec4):Vec4;

	overload static function pow(x:Float, y:Float):Float;

	overload static function pow(x:Vec2, y:Vec2):Vec2;

	overload static function pow(x:Vec3, y:Vec3):Vec3;

	overload static function pow(x:Vec4, y:Vec4):Vec4;

	overload static function exp(x:Float):Float;

	overload static function exp(x:Vec2):Vec2;

	overload static function exp(x:Vec3):Vec3;

	overload static function exp(x:Vec4):Vec4;

	overload static function log(x:Float):Float;

	overload static function log(x:Vec2):Vec2;

	overload static function log(x:Vec3):Vec3;

	overload static function log(x:Vec4):Vec4;

	overload static function exp2(x:Float):Float;

	overload static function exp2(x:Vec2):Vec2;

	overload static function exp2(x:Vec3):Vec3;

	overload static function exp2(x:Vec4):Vec4;

	overload static function log2(x:Float):Float;

	overload static function log2(x:Vec2):Vec2;

	overload static function log2(x:Vec3):Vec3;

	overload static function log2(x:Vec4):Vec4;

	overload static function sqrt(x:Float):Float;

	overload static function sqrt(x:Vec2):Vec2;

	overload static function sqrt(x:Vec3):Vec3;

	overload static function sqrt(x:Vec4):Vec4;

	overload static function inversesqrt(x:Float):Float;

	overload static function inversesqrt(x:Vec2):Vec2;

	overload static function inversesqrt(x:Vec3):Vec3;

	overload static function inversesqrt(x:Vec4):Vec4;

	overload static function abs(x:Float):Float;

	overload static function abs(x:Vec2):Vec2;

	overload static function abs(x:Vec3):Vec3;

	overload static function abs(x:Vec4):Vec4;

	overload static function abs(x:Int):Int;

	overload static function abs(x:IVec2):IVec2;

	overload static function abs(x:IVec3):IVec3;

	overload static function abs(x:IVec4):IVec4;

	overload static function sign(x:Float):Float;

	overload static function sign(x:Vec2):Vec2;

	overload static function sign(x:Vec3):Vec3;

	overload static function sign(x:Vec4):Vec4;

	overload static function sign(x:Int):Int;

	overload static function sign(x:IVec2):IVec2;

	overload static function sign(x:IVec3):IVec3;

	overload static function sign(x:IVec4):IVec4;

	overload static function floor(x:Float):Float;

	overload static function floor(x:Vec2):Vec2;

	overload static function floor(x:Vec3):Vec3;

	overload static function floor(x:Vec4):Vec4;

	overload static function trunc(x:Float):Float;

	overload static function trunc(x:Vec2):Vec2;

	overload static function trunc(x:Vec3):Vec3;

	overload static function trunc(x:Vec4):Vec4;

	overload static function round(x:Float):Float;

	overload static function round(x:Vec2):Vec2;

	overload static function round(x:Vec3):Vec3;

	overload static function round(x:Vec4):Vec4;

	overload static function roundEven(x:Float):Float;

	overload static function roundEven(x:Vec2):Vec2;

	overload static function roundEven(x:Vec3):Vec3;

	overload static function roundEven(x:Vec4):Vec4;

	overload static function ceil(x:Float):Float;

	overload static function ceil(x:Vec2):Vec2;

	overload static function ceil(x:Vec3):Vec3;

	overload static function ceil(x:Vec4):Vec4;

	overload static function fract(x:Float):Float;

	overload static function fract(x:Vec2):Vec2;

	overload static function fract(x:Vec3):Vec3;

	overload static function fract(x:Vec4):Vec4;

	overload static function mod(x:Float, y:Float):Float;

	overload static function mod(x:Vec2, y:Vec2):Vec2;

	overload static function mod(x:Vec3, y:Vec3):Vec3;

	overload static function mod(x:Vec4, y:Vec4):Vec4;

	overload static function mod(x:Vec2, y:Float):Vec2;

	overload static function mod(x:Vec3, y:Float):Vec3;

	overload static function mod(x:Vec4, y:Float):Vec4;

	overload static function min(x:Float, y:Float):Float;

	overload static function min(x:Vec2, y:Vec2):Vec2;

	overload static function min(x:Vec3, y:Vec3):Vec3;

	overload static function min(x:Vec4, y:Vec4):Vec4;

	overload static function min(x:Int, y:Int):Int;

	overload static function min(x:IVec2, y:IVec2):IVec2;

	overload static function min(x:IVec3, y:IVec3):IVec3;

	overload static function min(x:IVec4, y:IVec4):IVec4;

	overload static function min(x:UInt, y:UInt):UInt;

	overload static function min(x:UVec2, y:UVec2):UVec2;

	overload static function min(x:UVec3, y:UVec3):UVec3;

	overload static function min(x:UVec4, y:UVec4):UVec4;

	overload static function min(x:Vec2, y:Float):Vec2;

	overload static function min(x:Vec3, y:Float):Vec3;

	overload static function min(x:Vec4, y:Float):Vec4;

	overload static function min(x:IVec2, y:Int):IVec2;

	overload static function min(x:IVec3, y:Int):IVec3;

	overload static function min(x:IVec4, y:Int):IVec4;

	overload static function min(x:UVec2, y:UInt):UVec2;

	overload static function min(x:UVec3, y:UInt):UVec3;

	overload static function min(x:UVec4, y:UInt):UVec4;

	overload static function max(x:Float, y:Float):Float;

	overload static function max(x:Vec2, y:Vec2):Vec2;

	overload static function max(x:Vec3, y:Vec3):Vec3;

	overload static function max(x:Vec4, y:Vec4):Vec4;

	overload static function max(x:Int, y:Int):Int;

	overload static function max(x:IVec2, y:IVec2):IVec2;

	overload static function max(x:IVec3, y:IVec3):IVec3;

	overload static function max(x:IVec4, y:IVec4):IVec4;

	overload static function max(x:UInt, y:UInt):UInt;

	overload static function max(x:UVec2, y:UVec2):UVec2;

	overload static function max(x:UVec3, y:UVec3):UVec3;

	overload static function max(x:UVec4, y:UVec4):UVec4;

	overload static function max(x:Vec2, y:Float):Vec2;

	overload static function max(x:Vec3, y:Float):Vec3;

	overload static function max(x:Vec4, y:Float):Vec4;

	overload static function max(x:IVec2, y:Int):IVec2;

	overload static function max(x:IVec3, y:Int):IVec3;

	overload static function max(x:IVec4, y:Int):IVec4;

	overload static function max(x:UVec2, y:UInt):UVec2;

	overload static function max(x:UVec3, y:UInt):UVec3;

	overload static function max(x:UVec4, y:UInt):UVec4;

	overload static function clamp(x:Float, minVal:Float, maxVal:Float):Float;

	overload static function clamp(x:Vec2, minVal:Vec2, maxVal:Vec2):Vec2;

	overload static function clamp(x:Vec3, minVal:Vec3, maxVal:Vec3):Vec3;

	overload static function clamp(x:Vec4, minVal:Vec4, maxVal:Vec4):Vec4;

	overload static function clamp(x:Int, minVal:Int, maxVal:Int):Int;

	overload static function clamp(x:IVec2, minVal:IVec2, maxVal:IVec2):IVec2;

	overload static function clamp(x:IVec3, minVal:IVec3, maxVal:IVec3):IVec3;

	overload static function clamp(x:IVec4, minVal:IVec4, maxVal:IVec4):IVec4;

	overload static function clamp(x:UInt, minVal:UInt, maxVal:UInt):UInt;

	overload static function clamp(x:UVec2, minVal:UVec2, maxVal:UVec2):UVec2;

	overload static function clamp(x:UVec3, minVal:UVec3, maxVal:UVec3):UVec3;

	overload static function clamp(x:UVec4, minVal:UVec4, maxVal:UVec4):UVec4;

	overload static function clamp(x:Vec2, minVal:Float, maxVal:Float):Vec2;

	overload static function clamp(x:Vec3, minVal:Float, maxVal:Float):Vec3;

	overload static function clamp(x:Vec4, minVal:Float, maxVal:Float):Vec4;

	overload static function clamp(x:IVec2, minVal:Int, maxVal:Int):IVec2;

	overload static function clamp(x:IVec3, minVal:Int, maxVal:Int):IVec3;

	overload static function clamp(x:IVec4, minVal:Int, maxVal:Int):IVec4;

	overload static function clamp(x:UVec2, minVal:UInt, maxVal:UInt):UVec2;

	overload static function clamp(x:UVec3, minVal:UInt, maxVal:UInt):UVec3;

	overload static function clamp(x:UVec4, minVal:UInt, maxVal:UInt):UVec4;

	overload static function mix(x:Float, y:Float, a:Float):Float;

	overload static function mix(x:Vec2, y:Vec2, a:Vec2):Vec2;

	overload static function mix(x:Vec3, y:Vec3, a:Vec3):Vec3;

	overload static function mix(x:Vec4, y:Vec4, a:Vec4):Vec4;

	overload static function mix(x:Vec2, y:Vec2, a:Float):Vec2;

	overload static function mix(x:Vec3, y:Vec3, a:Float):Vec3;

	overload static function mix(x:Vec4, y:Vec4, a:Float):Vec4;

	overload static function mix(x:Float, y:Float, a:Bool):Float;

	overload static function mix(x:Vec2, y:Vec2, a:BVec2):Vec2;

	overload static function mix(x:Vec3, y:Vec3, a:BVec3):Vec3;

	overload static function mix(x:Vec4, y:Vec4, a:BVec4):Vec4;

	overload static function step(edge:Float, x:Float):Float;

	overload static function step(edge:Vec2, x:Vec2):Vec2;

	overload static function step(edge:Vec3, x:Vec3):Vec3;

	overload static function step(edge:Vec4, x:Vec4):Vec4;

	overload static function step(edge:Float, x:Vec2):Vec2;

	overload static function step(edge:Float, x:Vec3):Vec3;

	overload static function step(edge:Float, x:Vec4):Vec4;

	overload static function smoothstep(edge0:Float, edge1:Float, x:Float):Float;

	overload static function smoothstep(edge0:Vec2, edge1:Vec2, x:Vec2):Vec2;

	overload static function smoothstep(edge0:Vec3, edge1:Vec3, x:Vec3):Vec3;

	overload static function smoothstep(edge0:Vec4, edge1:Vec4, x:Vec4):Vec4;

	overload static function smoothstep(edge0:Float, edge1:Float, x:Vec2):Vec2;

	overload static function smoothstep(edge0:Float, edge1:Float, x:Vec3):Vec3;

	overload static function smoothstep(edge0:Float, edge1:Float, x:Vec4):Vec4;

	overload static function isnan(x:Float):Bool;

	overload static function isnan(x:Vec2):BVec2;

	overload static function isnan(x:Vec3):BVec3;

	overload static function isnan(x:Vec4):BVec4;

	overload static function isinf(x:Float):Bool;

	overload static function isinf(x:Vec2):BVec2;

	overload static function isinf(x:Vec3):BVec3;

	overload static function isinf(x:Vec4):BVec4;

	overload static function floatBitsToInt(value:Float):Int;

	overload static function floatBitsToInt(value:Vec2):IVec2;

	overload static function floatBitsToInt(value:Vec3):IVec3;

	overload static function floatBitsToInt(value:Vec4):IVec4;

	overload static function floatBitsToUint(value:Float):UInt;

	overload static function floatBitsToUint(value:Vec2):UVec2;

	overload static function floatBitsToUint(value:Vec3):UVec3;

	overload static function floatBitsToUint(value:Vec4):UVec4;

	overload static function intBitsToFloat(value:Int):Float;

	overload static function intBitsToFloat(value:IVec2):Vec2;

	overload static function intBitsToFloat(value:IVec3):Vec3;

	overload static function intBitsToFloat(value:IVec4):Vec4;

	overload static function uintBitsToFloat(value:UInt):Float;

	overload static function uintBitsToFloat(value:UVec2):Vec2;

	overload static function uintBitsToFloat(value:UVec3):Vec3;

	overload static function uintBitsToFloat(value:UVec4):Vec4;

	overload static function packSnorm2x16(v:Vec2):UInt;

	overload static function packUnorm2x16(v:Vec2):UInt;

	overload static function unpackSnorm2x16(p:UInt):Vec2;

	overload static function unpackUnorm2x16(p:UInt):Vec2;

	overload static function packHalf2x16(v:Vec2):UInt;

	overload static function unpackHalf2x16(p:UInt):Vec2;

	overload static function length(x:Float):Float;

	overload static function length(x:Vec2):Float;

	overload static function length(x:Vec3):Float;

	overload static function length(x:Vec4):Float;

	overload static function distance(p0:Float, p1:Float):Float;

	overload static function distance(p0:Vec2, p1:Vec2):Float;

	overload static function distance(p0:Vec3, p1:Vec3):Float;

	overload static function distance(p0:Vec4, p1:Vec4):Float;

	overload static function dot(x:Float, y:Float):Float;

	overload static function dot(x:Vec2, y:Vec2):Float;

	overload static function dot(x:Vec3, y:Vec3):Float;

	overload static function dot(x:Vec4, y:Vec4):Float;

	overload static function cross(x:Vec3, y:Vec3):Vec3;

	overload static function normalize(x:Float):Float;

	overload static function normalize(x:Vec2):Vec2;

	overload static function normalize(x:Vec3):Vec3;

	overload static function normalize(x:Vec4):Vec4;

	overload static function faceforward(n:Float, i:Float, nRef:Float):Float;

	overload static function faceforward(n:Vec2, i:Vec2, nRef:Vec2):Vec2;

	overload static function faceforward(n:Vec3, i:Vec3, nRef:Vec3):Vec3;

	overload static function faceforward(n:Vec4, i:Vec4, nRef:Vec4):Vec4;

	overload static function reflect(i:Float, n:Float):Float;

	overload static function reflect(i:Vec2, n:Vec2):Vec2;

	overload static function reflect(i:Vec3, n:Vec3):Vec3;

	overload static function reflect(i:Vec4, n:Vec4):Vec4;

	overload static function refract(i:Float, n:Float, eta:Float):Float;

	overload static function refract(i:Vec2, n:Vec2, eta:Float):Vec2;

	overload static function refract(i:Vec3, n:Vec3, eta:Float):Vec3;

	overload static function refract(i:Vec4, n:Vec4, eta:Float):Vec4;

	overload static function matrixCompMult(x:Mat2x2, y:Mat2x2):Mat2x2;

	overload static function matrixCompMult(x:Mat3x3, y:Mat3x3):Mat3x3;

	overload static function matrixCompMult(x:Mat4x4, y:Mat4x4):Mat4x4;

	overload static function matrixCompMult(x:Mat2x3, y:Mat2x3):Mat2x3;

	overload static function matrixCompMult(x:Mat3x2, y:Mat3x2):Mat3x2;

	overload static function matrixCompMult(x:Mat2x4, y:Mat2x4):Mat2x4;

	overload static function matrixCompMult(x:Mat4x2, y:Mat4x2):Mat4x2;

	overload static function matrixCompMult(x:Mat3x4, y:Mat3x4):Mat3x4;

	overload static function matrixCompMult(x:Mat4x3, y:Mat4x3):Mat4x3;

	overload static function outerProduct(c:Vec2, r:Vec2):Mat2x2;

	overload static function outerProduct(c:Vec3, r:Vec3):Mat3x3;

	overload static function outerProduct(c:Vec4, r:Vec4):Mat4x4;

	overload static function outerProduct(c:Vec3, r:Vec2):Mat2x3;

	overload static function outerProduct(c:Vec2, r:Vec3):Mat3x2;

	overload static function outerProduct(c:Vec4, r:Vec2):Mat2x4;

	overload static function outerProduct(c:Vec2, r:Vec4):Mat4x2;

	overload static function outerProduct(c:Vec4, r:Vec3):Mat3x4;

	overload static function outerProduct(c:Vec3, r:Vec4):Mat4x3;

	overload static function transpose(m:Mat2x2):Mat2x2;

	overload static function transpose(m:Mat3x3):Mat3x3;

	overload static function transpose(m:Mat4x4):Mat4x4;

	overload static function transpose(m:Mat3x2):Mat2x3;

	overload static function transpose(m:Mat2x3):Mat3x2;

	overload static function transpose(m:Mat4x2):Mat2x4;

	overload static function transpose(m:Mat2x4):Mat4x2;

	overload static function transpose(m:Mat4x3):Mat3x4;

	overload static function transpose(m:Mat3x4):Mat4x3;

	overload static function determinant(m:Mat2x2):Float;

	overload static function determinant(m:Mat3x3):Float;

	overload static function determinant(m:Mat4x4):Float;

	overload static function inverse(m:Mat2x2):Mat2x2;

	overload static function inverse(m:Mat3x3):Mat3x3;

	overload static function inverse(m:Mat4x4):Mat4x4;

	overload static function lessThan(x:Vec2, y:Vec2):BVec2;

	overload static function lessThan(x:Vec3, y:Vec3):BVec3;

	overload static function lessThan(x:Vec4, y:Vec4):BVec4;

	overload static function lessThan(x:IVec2, y:IVec2):BVec2;

	overload static function lessThan(x:IVec3, y:IVec3):BVec3;

	overload static function lessThan(x:IVec4, y:IVec4):BVec4;

	overload static function lessThan(x:UVec2, y:UVec2):BVec2;

	overload static function lessThan(x:UVec3, y:UVec3):BVec3;

	overload static function lessThan(x:UVec4, y:UVec4):BVec4;

	overload static function lessThanEqual(x:Vec2, y:Vec2):BVec2;

	overload static function lessThanEqual(x:Vec3, y:Vec3):BVec3;

	overload static function lessThanEqual(x:Vec4, y:Vec4):BVec4;

	overload static function lessThanEqual(x:IVec2, y:IVec2):BVec2;

	overload static function lessThanEqual(x:IVec3, y:IVec3):BVec3;

	overload static function lessThanEqual(x:IVec4, y:IVec4):BVec4;

	overload static function lessThanEqual(x:UVec2, y:UVec2):BVec2;

	overload static function lessThanEqual(x:UVec3, y:UVec3):BVec3;

	overload static function lessThanEqual(x:UVec4, y:UVec4):BVec4;

	overload static function greaterThan(x:Vec2, y:Vec2):BVec2;

	overload static function greaterThan(x:Vec3, y:Vec3):BVec3;

	overload static function greaterThan(x:Vec4, y:Vec4):BVec4;

	overload static function greaterThan(x:IVec2, y:IVec2):BVec2;

	overload static function greaterThan(x:IVec3, y:IVec3):BVec3;

	overload static function greaterThan(x:IVec4, y:IVec4):BVec4;

	overload static function greaterThan(x:UVec2, y:UVec2):BVec2;

	overload static function greaterThan(x:UVec3, y:UVec3):BVec3;

	overload static function greaterThan(x:UVec4, y:UVec4):BVec4;

	overload static function greaterThanEqual(x:Vec2, y:Vec2):BVec2;

	overload static function greaterThanEqual(x:Vec3, y:Vec3):BVec3;

	overload static function greaterThanEqual(x:Vec4, y:Vec4):BVec4;

	overload static function greaterThanEqual(x:IVec2, y:IVec2):BVec2;

	overload static function greaterThanEqual(x:IVec3, y:IVec3):BVec3;

	overload static function greaterThanEqual(x:IVec4, y:IVec4):BVec4;

	overload static function greaterThanEqual(x:UVec2, y:UVec2):BVec2;

	overload static function greaterThanEqual(x:UVec3, y:UVec3):BVec3;

	overload static function greaterThanEqual(x:UVec4, y:UVec4):BVec4;

	overload static function equal(x:Vec2, y:Vec2):BVec2;

	overload static function equal(x:Vec3, y:Vec3):BVec3;

	overload static function equal(x:Vec4, y:Vec4):BVec4;

	overload static function equal(x:IVec2, y:IVec2):BVec2;

	overload static function equal(x:IVec3, y:IVec3):BVec3;

	overload static function equal(x:IVec4, y:IVec4):BVec4;

	overload static function equal(x:UVec2, y:UVec2):BVec2;

	overload static function equal(x:UVec3, y:UVec3):BVec3;

	overload static function equal(x:UVec4, y:UVec4):BVec4;

	overload static function equal(x:BVec2, y:BVec2):BVec2;

	overload static function equal(x:BVec3, y:BVec3):BVec3;

	overload static function equal(x:BVec4, y:BVec4):BVec4;

	overload static function notEqual(x:Vec2, y:Vec2):BVec2;

	overload static function notEqual(x:Vec3, y:Vec3):BVec3;

	overload static function notEqual(x:Vec4, y:Vec4):BVec4;

	overload static function notEqual(x:IVec2, y:IVec2):BVec2;

	overload static function notEqual(x:IVec3, y:IVec3):BVec3;

	overload static function notEqual(x:IVec4, y:IVec4):BVec4;

	overload static function notEqual(x:UVec2, y:UVec2):BVec2;

	overload static function notEqual(x:UVec3, y:UVec3):BVec3;

	overload static function notEqual(x:UVec4, y:UVec4):BVec4;

	overload static function notEqual(x:BVec2, y:BVec2):BVec2;

	overload static function notEqual(x:BVec3, y:BVec3):BVec3;

	overload static function notEqual(x:BVec4, y:BVec4):BVec4;

	overload static function any(x:BVec2):Bool;

	overload static function any(x:BVec3):Bool;

	overload static function any(x:BVec4):Bool;

	overload static function all(x:BVec2):Bool;

	overload static function all(x:BVec3):Bool;

	overload static function all(x:BVec4):Bool;

	overload static function not(x:BVec2):BVec2;

	overload static function not(x:BVec3):BVec3;

	overload static function not(x:BVec4):BVec4;

	overload static function textureSize(sampler:Sampler2D, lod:Int):IVec2;

	overload static function textureSize(sampler:ISampler2D, lod:Int):IVec2;

	overload static function textureSize(sampler:USampler2D, lod:Int):IVec2;

	overload static function textureSize(sampler:Sampler3D, lod:Int):IVec3;

	overload static function textureSize(sampler:ISampler3D, lod:Int):IVec3;

	overload static function textureSize(sampler:USampler3D, lod:Int):IVec3;

	overload static function textureSize(sampler:SamplerCube, lod:Int):IVec2;

	overload static function textureSize(sampler:ISamplerCube, lod:Int):IVec2;

	overload static function textureSize(sampler:USamplerCube, lod:Int):IVec2;

	overload static function textureSize(sampler:Sampler2DShadow, lod:Int):IVec2;

	overload static function textureSize(sampler:SamplerCubeShadow, lod:Int):IVec2;

	overload static function textureSize(sampler:Sampler2DArray, lod:Int):IVec3;

	overload static function textureSize(sampler:ISampler2DArray, lod:Int):IVec3;

	overload static function textureSize(sampler:USampler2DArray, lod:Int):IVec3;

	overload static function textureSize(sampler:Sampler2DArrayShadow, lod:Int):IVec3;

	overload static function texture(sampler:Sampler2D, P:Vec2):Vec4;

	overload static function texture(sampler:ISampler2D, P:Vec2):IVec4;

	overload static function texture(sampler:USampler2D, P:Vec2):UVec4;

	overload static function texture(sampler:Sampler3D, P:Vec3):Vec4;

	overload static function texture(sampler:ISampler3D, P:Vec3):IVec4;

	overload static function texture(sampler:USampler3D, P:Vec3):UVec4;

	overload static function texture(sampler:SamplerCube, P:Vec3):Vec4;

	overload static function texture(sampler:ISamplerCube, P:Vec3):IVec4;

	overload static function texture(sampler:USamplerCube, P:Vec3):UVec4;

	overload static function texture(sampler:Sampler2DShadow, P:Vec3):Float;

	overload static function texture(sampler:SamplerCubeShadow, P:Vec4):Float;

	overload static function texture(sampler:Sampler2DArray, P:Vec3):Vec4;

	overload static function texture(sampler:ISampler2DArray, P:Vec3):IVec4;

	overload static function texture(sampler:USampler2DArray, P:Vec3):UVec4;

	overload static function texture(sampler:Sampler2D, P:Vec2, bias:Float):Vec4;

	overload static function texture(sampler:ISampler2D, P:Vec2, bias:Float):IVec4;

	overload static function texture(sampler:USampler2D, P:Vec2, bias:Float):UVec4;

	overload static function texture(sampler:Sampler3D, P:Vec3, bias:Float):Vec4;

	overload static function texture(sampler:ISampler3D, P:Vec3, bias:Float):IVec4;

	overload static function texture(sampler:USampler3D, P:Vec3, bias:Float):UVec4;

	overload static function texture(sampler:SamplerCube, P:Vec3, bias:Float):Vec4;

	overload static function texture(sampler:ISamplerCube, P:Vec3, bias:Float):IVec4;

	overload static function texture(sampler:USamplerCube, P:Vec3, bias:Float):UVec4;

	overload static function texture(sampler:Sampler2DShadow, P:Vec3, bias:Float):Float;

	overload static function texture(sampler:SamplerCubeShadow, P:Vec4, bias:Float):Float;

	overload static function texture(sampler:Sampler2DArray, P:Vec3, bias:Float):Vec4;

	overload static function texture(sampler:ISampler2DArray, P:Vec3, bias:Float):IVec4;

	overload static function texture(sampler:USampler2DArray, P:Vec3, bias:Float):UVec4;

	overload static function texture(sampler:Sampler2DArrayShadow, P:Vec4):Float;

	overload static function textureProj(sampler:Sampler2D, P:Vec3):Vec4;

	overload static function textureProj(sampler:ISampler2D, P:Vec3):IVec4;

	overload static function textureProj(sampler:USampler2D, P:Vec3):UVec4;

	overload static function textureProj(sampler:Sampler2D, P:Vec4):Vec4;

	overload static function textureProj(sampler:ISampler2D, P:Vec4):IVec4;

	overload static function textureProj(sampler:USampler2D, P:Vec4):UVec4;

	overload static function textureProj(sampler:Sampler3D, P:Vec4):Vec4;

	overload static function textureProj(sampler:ISampler3D, P:Vec4):IVec4;

	overload static function textureProj(sampler:USampler3D, P:Vec4):UVec4;

	overload static function textureProj(sampler:Sampler2DShadow, P:Vec4):Float;

	overload static function textureProj(sampler:Sampler2D, P:Vec3, bias:Float):Vec4;

	overload static function textureProj(sampler:ISampler2D, P:Vec3, bias:Float):IVec4;

	overload static function textureProj(sampler:USampler2D, P:Vec3, bias:Float):UVec4;

	overload static function textureProj(sampler:Sampler2D, P:Vec4, bias:Float):Vec4;

	overload static function textureProj(sampler:ISampler2D, P:Vec4, bias:Float):IVec4;

	overload static function textureProj(sampler:USampler2D, P:Vec4, bias:Float):UVec4;

	overload static function textureProj(sampler:Sampler3D, P:Vec4, bias:Float):Vec4;

	overload static function textureProj(sampler:ISampler3D, P:Vec4, bias:Float):IVec4;

	overload static function textureProj(sampler:USampler3D, P:Vec4, bias:Float):UVec4;

	overload static function textureProj(sampler:Sampler2DShadow, P:Vec4, bias:Float):Float;

	overload static function textureLod(sampler:Sampler2D, P:Vec2, lod:Float):Vec4;

	overload static function textureLod(sampler:ISampler2D, P:Vec2, lod:Float):IVec4;

	overload static function textureLod(sampler:USampler2D, P:Vec2, lod:Float):UVec4;

	overload static function textureLod(sampler:Sampler3D, P:Vec3, lod:Float):Vec4;

	overload static function textureLod(sampler:ISampler3D, P:Vec3, lod:Float):IVec4;

	overload static function textureLod(sampler:USampler3D, P:Vec3, lod:Float):UVec4;

	overload static function textureLod(sampler:SamplerCube, P:Vec3, lod:Float):Vec4;

	overload static function textureLod(sampler:ISamplerCube, P:Vec3, lod:Float):IVec4;

	overload static function textureLod(sampler:USamplerCube, P:Vec3, lod:Float):UVec4;

	overload static function textureLod(sampler:Sampler2DShadow, P:Vec3, lod:Float):Float;

	overload static function textureLod(sampler:Sampler2DArray, P:Vec3, lod:Float):Vec4;

	overload static function textureLod(sampler:ISampler2DArray, P:Vec3, lod:Float):IVec4;

	overload static function textureLod(sampler:USampler2DArray, P:Vec3, lod:Float):UVec4;

	overload static function textureOffset(sampler:Sampler2D, P:Vec2, offset:IVec2):Vec4;

	overload static function textureOffset(sampler:ISampler2D, P:Vec2, offset:IVec2):IVec4;

	overload static function textureOffset(sampler:USampler2D, P:Vec2, offset:IVec2):UVec4;

	overload static function textureOffset(sampler:Sampler3D, P:Vec3, offset:IVec3):Vec4;

	overload static function textureOffset(sampler:ISampler3D, P:Vec3, offset:IVec3):IVec4;

	overload static function textureOffset(sampler:USampler3D, P:Vec3, offset:IVec3):UVec4;

	overload static function textureOffset(sampler:Sampler2DShadow, P:Vec3, offset:IVec2):Float;

	overload static function textureOffset(sampler:Sampler2DArray, P:Vec3, offset:IVec2):Vec4;

	overload static function textureOffset(sampler:ISampler2DArray, P:Vec3, offset:IVec2):IVec4;

	overload static function textureOffset(sampler:USampler2DArray, P:Vec3, offset:IVec2):UVec4;

	overload static function textureOffset(sampler:Sampler2D, P:Vec2, offset:IVec2, bias:Float):Vec4;

	overload static function textureOffset(sampler:ISampler2D, P:Vec2, offset:IVec2, bias:Float):IVec4;

	overload static function textureOffset(sampler:USampler2D, P:Vec2, offset:IVec2, bias:Float):UVec4;

	overload static function textureOffset(sampler:Sampler3D, P:Vec3, offset:IVec3, bias:Float):Vec4;

	overload static function textureOffset(sampler:ISampler3D, P:Vec3, offset:IVec3, bias:Float):IVec4;

	overload static function textureOffset(sampler:USampler3D, P:Vec3, offset:IVec3, bias:Float):UVec4;

	overload static function textureOffset(sampler:Sampler2DShadow, P:Vec3, offset:IVec2, bias:Float):Float;

	overload static function textureOffset(sampler:Sampler2DArray, P:Vec3, offset:IVec2, bias:Float):Vec4;

	overload static function textureOffset(sampler:ISampler2DArray, P:Vec3, offset:IVec2, bias:Float):IVec4;

	overload static function textureOffset(sampler:USampler2DArray, P:Vec3, offset:IVec2, bias:Float):UVec4;

	overload static function texelFetch(sampler:Sampler2D, P:IVec2, lod:Int):Vec4;

	overload static function texelFetch(sampler:ISampler2D, P:IVec2, lod:Int):IVec4;

	overload static function texelFetch(sampler:USampler2D, P:IVec2, lod:Int):UVec4;

	overload static function texelFetch(sampler:Sampler3D, P:IVec3, lod:Int):Vec4;

	overload static function texelFetch(sampler:ISampler3D, P:IVec3, lod:Int):IVec4;

	overload static function texelFetch(sampler:USampler3D, P:IVec3, lod:Int):UVec4;

	overload static function texelFetch(sampler:Sampler2DArray, P:IVec3, lod:Int):Vec4;

	overload static function texelFetch(sampler:ISampler2DArray, P:IVec3, lod:Int):IVec4;

	overload static function texelFetch(sampler:USampler2DArray, P:IVec3, lod:Int):UVec4;

	overload static function texelFetchOffset(sampler:Sampler2D, P:IVec2, lod:Int, offset:IVec2):Vec4;

	overload static function texelFetchOffset(sampler:ISampler2D, P:IVec2, lod:Int, offset:IVec2):IVec4;

	overload static function texelFetchOffset(sampler:USampler2D, P:IVec2, lod:Int, offset:IVec2):UVec4;

	overload static function texelFetchOffset(sampler:Sampler3D, P:IVec3, lod:Int, offset:IVec3):Vec4;

	overload static function texelFetchOffset(sampler:ISampler3D, P:IVec3, lod:Int, offset:IVec3):IVec4;

	overload static function texelFetchOffset(sampler:USampler3D, P:IVec3, lod:Int, offset:IVec3):UVec4;

	overload static function texelFetchOffset(sampler:Sampler2DArray, P:IVec3, lod:Int, offset:IVec2):Vec4;

	overload static function texelFetchOffset(sampler:ISampler2DArray, P:IVec3, lod:Int, offset:IVec2):IVec4;

	overload static function texelFetchOffset(sampler:USampler2DArray, P:IVec3, lod:Int, offset:IVec2):UVec4;

	overload static function textureProjOffset(sampler:Sampler2D, P:Vec3, offset:IVec2):Vec4;

	overload static function textureProjOffset(sampler:ISampler2D, P:Vec3, offset:IVec2):IVec4;

	overload static function textureProjOffset(sampler:USampler2D, P:Vec3, offset:IVec2):UVec4;

	overload static function textureProjOffset(sampler:Sampler2D, P:Vec4, offset:IVec2):Vec4;

	overload static function textureProjOffset(sampler:ISampler2D, P:Vec4, offset:IVec2):IVec4;

	overload static function textureProjOffset(sampler:USampler2D, P:Vec4, offset:IVec2):UVec4;

	overload static function textureProjOffset(sampler:Sampler3D, P:Vec4, offset:IVec3):Vec4;

	overload static function textureProjOffset(sampler:ISampler3D, P:Vec4, offset:IVec3):IVec4;

	overload static function textureProjOffset(sampler:USampler3D, P:Vec4, offset:IVec3):UVec4;

	overload static function textureProjOffset(sampler:Sampler2DShadow, P:Vec4, offset:IVec2):Float;

	overload static function textureProjOffset(sampler:Sampler2D, P:Vec3, offset:IVec2, bias:Float):Vec4;

	overload static function textureProjOffset(sampler:ISampler2D, P:Vec3, offset:IVec2, bias:Float):IVec4;

	overload static function textureProjOffset(sampler:USampler2D, P:Vec3, offset:IVec2, bias:Float):UVec4;

	overload static function textureProjOffset(sampler:Sampler2D, P:Vec4, offset:IVec2, bias:Float):Vec4;

	overload static function textureProjOffset(sampler:ISampler2D, P:Vec4, offset:IVec2, bias:Float):IVec4;

	overload static function textureProjOffset(sampler:USampler2D, P:Vec4, offset:IVec2, bias:Float):UVec4;

	overload static function textureProjOffset(sampler:Sampler3D, P:Vec4, offset:IVec3, bias:Float):Vec4;

	overload static function textureProjOffset(sampler:ISampler3D, P:Vec4, offset:IVec3, bias:Float):IVec4;

	overload static function textureProjOffset(sampler:USampler3D, P:Vec4, offset:IVec3, bias:Float):UVec4;

	overload static function textureProjOffset(sampler:Sampler2DShadow, P:Vec4, offset:IVec2, bias:Float):Float;

	overload static function textureLodOffset(sampler:Sampler2D, P:Vec2, lod:Float, offset:IVec2):Vec4;

	overload static function textureLodOffset(sampler:ISampler2D, P:Vec2, lod:Float, offset:IVec2):IVec4;

	overload static function textureLodOffset(sampler:USampler2D, P:Vec2, lod:Float, offset:IVec2):UVec4;

	overload static function textureLodOffset(sampler:Sampler3D, P:Vec3, lod:Float, offset:IVec3):Vec4;

	overload static function textureLodOffset(sampler:ISampler3D, P:Vec3, lod:Float, offset:IVec3):IVec4;

	overload static function textureLodOffset(sampler:USampler3D, P:Vec3, lod:Float, offset:IVec3):UVec4;

	overload static function textureLodOffset(sampler:Sampler2DShadow, P:Vec3, lod:Float, offset:IVec2):Float;

	overload static function textureLodOffset(sampler:Sampler2DArray, P:Vec3, lod:Float, offset:IVec2):Vec4;

	overload static function textureLodOffset(sampler:ISampler2DArray, P:Vec3, lod:Float, offset:IVec2):IVec4;

	overload static function textureLodOffset(sampler:USampler2DArray, P:Vec3, lod:Float, offset:IVec2):UVec4;

	overload static function textureProjLod(sampler:Sampler2D, P:Vec3, lod:Float):Vec4;

	overload static function textureProjLod(sampler:ISampler2D, P:Vec3, lod:Float):IVec4;

	overload static function textureProjLod(sampler:USampler2D, P:Vec3, lod:Float):UVec4;

	overload static function textureProjLod(sampler:Sampler2D, P:Vec4, lod:Float):Vec4;

	overload static function textureProjLod(sampler:ISampler2D, P:Vec4, lod:Float):IVec4;

	overload static function textureProjLod(sampler:USampler2D, P:Vec4, lod:Float):UVec4;

	overload static function textureProjLod(sampler:Sampler3D, P:Vec4, lod:Float):Vec4;

	overload static function textureProjLod(sampler:ISampler3D, P:Vec4, lod:Float):IVec4;

	overload static function textureProjLod(sampler:USampler3D, P:Vec4, lod:Float):UVec4;

	overload static function textureProjLod(sampler:Sampler2DShadow, P:Vec4, lod:Float):Float;

	overload static function textureProjLodOffset(sampler:Sampler2D, P:Vec3, lod:Float, offset:IVec2):Vec4;

	overload static function textureProjLodOffset(sampler:ISampler2D, P:Vec3, lod:Float, offset:IVec2):IVec4;

	overload static function textureProjLodOffset(sampler:USampler2D, P:Vec3, lod:Float, offset:IVec2):UVec4;

	overload static function textureProjLodOffset(sampler:Sampler2D, P:Vec4, lod:Float, offset:IVec2):Vec4;

	overload static function textureProjLodOffset(sampler:ISampler2D, P:Vec4, lod:Float, offset:IVec2):IVec4;

	overload static function textureProjLodOffset(sampler:USampler2D, P:Vec4, lod:Float, offset:IVec2):UVec4;

	overload static function textureProjLodOffset(sampler:Sampler3D, P:Vec4, lod:Float, offset:IVec3):Vec4;

	overload static function textureProjLodOffset(sampler:ISampler3D, P:Vec4, lod:Float, offset:IVec3):IVec4;

	overload static function textureProjLodOffset(sampler:USampler3D, P:Vec4, lod:Float, offset:IVec3):UVec4;

	overload static function textureProjLodOffset(sampler:Sampler2DShadow, P:Vec4, lod:Float, offset:IVec2):Float;

	overload static function textureGrad(sampler:Sampler2D, P:Vec2, dPdx:Vec2, dPdy:Vec2):Vec4;

	overload static function textureGrad(sampler:ISampler2D, P:Vec2, dPdx:Vec2, dPdy:Vec2):IVec4;

	overload static function textureGrad(sampler:USampler2D, P:Vec2, dPdx:Vec2, dPdy:Vec2):UVec4;

	overload static function textureGrad(sampler:Sampler3D, P:Vec3, dPdx:Vec3, dPdy:Vec3):Vec4;

	overload static function textureGrad(sampler:ISampler3D, P:Vec3, dPdx:Vec3, dPdy:Vec3):IVec4;

	overload static function textureGrad(sampler:USampler3D, P:Vec3, dPdx:Vec3, dPdy:Vec3):UVec4;

	overload static function textureGrad(sampler:SamplerCube, P:Vec3, dPdx:Vec3, dPdy:Vec3):Vec4;

	overload static function textureGrad(sampler:ISamplerCube, P:Vec3, dPdx:Vec3, dPdy:Vec3):IVec4;

	overload static function textureGrad(sampler:USamplerCube, P:Vec3, dPdx:Vec3, dPdy:Vec3):UVec4;

	overload static function textureGrad(sampler:Sampler2DShadow, P:Vec3, dPdx:Vec2, dPdy:Vec2):Float;

	overload static function textureGrad(sampler:SamplerCubeShadow, P:Vec4, dPdx:Vec3, dPdy:Vec3):Float;

	overload static function textureGrad(sampler:Sampler2DArray, P:Vec3, dPdx:Vec2, dPdy:Vec2):Vec4;

	overload static function textureGrad(sampler:ISampler2DArray, P:Vec3, dPdx:Vec2, dPdy:Vec2):IVec4;

	overload static function textureGrad(sampler:USampler2DArray, P:Vec3, dPdx:Vec2, dPdy:Vec2):UVec4;

	overload static function textureGrad(sampler:Sampler2DArrayShadow, P:Vec4, dPdx:Vec2, dPdy:Vec2):Float;

	overload static function textureGradOffset(sampler:Sampler2D, P:Vec2, dPdx:Vec2, dPdy:Vec2, offset:IVec2):Vec4;

	overload static function textureGradOffset(sampler:ISampler2D, P:Vec2, dPdx:Vec2, dPdy:Vec2, offset:IVec2):IVec4;

	overload static function textureGradOffset(sampler:USampler2D, P:Vec2, dPdx:Vec2, dPdy:Vec2, offset:IVec2):UVec4;

	overload static function textureGradOffset(sampler:Sampler3D, P:Vec3, dPdx:Vec3, dPdy:Vec3, offset:IVec3):Vec4;

	overload static function textureGradOffset(sampler:ISampler3D, P:Vec3, dPdx:Vec3, dPdy:Vec3, offset:IVec3):IVec4;

	overload static function textureGradOffset(sampler:USampler3D, P:Vec3, dPdx:Vec3, dPdy:Vec3, offset:IVec3):UVec4;

	overload static function textureGradOffset(sampler:Sampler2DShadow, P:Vec3, dPdx:Vec2, dPdy:Vec2, offset:IVec2):Float;

	overload static function textureGradOffset(sampler:Sampler2DArray, P:Vec3, dPdx:Vec2, dPdy:Vec2, offset:IVec2):Vec4;

	overload static function textureGradOffset(sampler:ISampler2DArray, P:Vec3, dPdx:Vec2, dPdy:Vec2, offset:IVec2):IVec4;

	overload static function textureGradOffset(sampler:USampler2DArray, P:Vec3, dPdx:Vec2, dPdy:Vec2, offset:IVec2):UVec4;

	overload static function textureGradOffset(sampler:Sampler2DArrayShadow, P:Vec4, dPdx:Vec2, dPdy:Vec2, offset:IVec2):Float;

	overload static function textureProj(sampler:Sampler2D, P:Vec3, dPdx:Vec2, dPdy:Vec2):Vec4;

	overload static function textureProj(sampler:ISampler2D, P:Vec3, dPdx:Vec2, dPdy:Vec2):IVec4;

	overload static function textureProj(sampler:USampler2D, P:Vec3, dPdx:Vec2, dPdy:Vec2):UVec4;

	overload static function textureProj(sampler:Sampler2D, P:Vec4, dPdx:Vec2, dPdy:Vec2):Vec4;

	overload static function textureProj(sampler:ISampler2D, P:Vec4, dPdx:Vec2, dPdy:Vec2):IVec4;

	overload static function textureProj(sampler:USampler2D, P:Vec4, dPdx:Vec2, dPdy:Vec2):UVec4;

	overload static function textureProj(sampler:Sampler3D, P:Vec4, dPdx:Vec3, dPdy:Vec3):Vec4;

	overload static function textureProj(sampler:ISampler3D, P:Vec4, dPdx:Vec3, dPdy:Vec3):IVec4;

	overload static function textureProj(sampler:USampler3D, P:Vec4, dPdx:Vec3, dPdy:Vec3):UVec4;

	overload static function textureProj(sampler:Sampler2DShadow, P:Vec4, dPdx:Vec2, dPdy:Vec2):Float;

	overload static function textureProjOffset(sampler:Sampler2D, P:Vec3, dPdx:Vec2, dPdy:Vec2, offset:IVec2):Vec4;

	overload static function textureProjOffset(sampler:ISampler2D, P:Vec3, dPdx:Vec2, dPdy:Vec2, offset:IVec2):IVec4;

	overload static function textureProjOffset(sampler:USampler2D, P:Vec3, dPdx:Vec2, dPdy:Vec2, offset:IVec2):UVec4;

	overload static function textureProjOffset(sampler:Sampler2D, P:Vec4, dPdx:Vec2, dPdy:Vec2, offset:IVec2):Vec4;

	overload static function textureProjOffset(sampler:ISampler2D, P:Vec4, dPdx:Vec2, dPdy:Vec2, offset:IVec2):IVec4;

	overload static function textureProjOffset(sampler:USampler2D, P:Vec4, dPdx:Vec2, dPdy:Vec2, offset:IVec2):UVec4;

	overload static function textureProjOffset(sampler:Sampler3D, P:Vec4, dPdx:Vec3, dPdy:Vec3, offset:IVec3):Vec4;

	overload static function textureProjOffset(sampler:ISampler3D, P:Vec4, dPdx:Vec3, dPdy:Vec3, offset:IVec3):IVec4;

	overload static function textureProjOffset(sampler:USampler3D, P:Vec4, dPdx:Vec3, dPdy:Vec3, offset:IVec3):UVec4;

	overload static function textureProjOffset(sampler:Sampler2DShadow, P:Vec4, dPdx:Vec2, dPdy:Vec2, offset:IVec2):Float;

	@:frag overload static function dFdx(p:Float):Float;

	@:frag overload static function dFdx(p:Vec2):Vec2;

	@:frag overload static function dFdx(p:Vec3):Vec3;

	@:frag overload static function dFdx(p:Vec4):Vec4;

	@:frag overload static function dFdy(p:Float):Float;

	@:frag overload static function dFdy(p:Vec2):Vec2;

	@:frag overload static function dFdy(p:Vec3):Vec3;

	@:frag overload static function dFdy(p:Vec4):Vec4;

	@:frag overload static function fwidth(p:Float):Float;

	@:frag overload static function fwidth(p:Vec2):Vec2;

	@:frag overload static function fwidth(p:Vec3):Vec3;

	@:frag overload static function fwidth(p:Vec4):Vec4;

	@:ctor static function float(a:Any):Float;

	@:ctor static function vec2(a:Any, ?b:Any):Vec2;

	@:ctor static function vec3(a:Any, ?b:Any, ?c:Any):Vec3;

	@:ctor static function vec4(a:Any, ?b:Any, ?c:Any, ?d:Any):Vec4;

	@:ctor static function int(a:Any):Int;

	@:ctor static function ivec2(a:Any, ?b:Any):IVec2;

	@:ctor static function ivec3(a:Any, ?b:Any, ?c:Any):IVec3;

	@:ctor static function ivec4(a:Any, ?b:Any, ?c:Any, ?d:Any):IVec4;

	@:ctor static function uint(a:Any):UInt;

	@:ctor static function uvec2(a:Any, ?b:Any):UVec2;

	@:ctor static function uvec3(a:Any, ?b:Any, ?c:Any):UVec3;

	@:ctor static function uvec4(a:Any, ?b:Any, ?c:Any, ?d:Any):UVec4;

	@:ctor static function bool(a:Any):Bool;

	@:ctor static function bvec2(a:Any, ?b:Any):BVec2;

	@:ctor static function bvec3(a:Any, ?b:Any, ?c:Any):BVec3;

	@:ctor static function bvec4(a:Any, ?b:Any, ?c:Any, ?d:Any):BVec4;

	@:ctor static function mat2(...rest:Any):Mat2x2;

	@:ctor static function mat3(...rest:Any):Mat3x3;

	@:ctor static function mat4(...rest:Any):Mat4x4;

	@:ctor static function mat2x2(...rest:Any):Mat2x2;

	@:ctor static function mat3x3(...rest:Any):Mat3x3;

	@:ctor static function mat4x4(...rest:Any):Mat4x4;

	@:ctor static function mat2x3(...rest:Any):Mat2x3;

	@:ctor static function mat3x2(...rest:Any):Mat3x2;

	@:ctor static function mat2x4(...rest:Any):Mat2x4;

	@:ctor static function mat4x2(...rest:Any):Mat4x2;

	@:ctor static function mat3x4(...rest:Any):Mat3x4;

	@:ctor static function mat4x3(...rest:Any):Mat4x3;
}

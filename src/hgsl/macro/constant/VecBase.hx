package hgsl.macro.constant;

import haxe.ds.Vector;

class VecBase<T> {
	public final data:Vector<T>;
	public final dim:Int;

	public function new(dim:Int) {
		data = new Vector<T>(dim);
		this.dim = dim;
	}

	public static function of<T>(array:Array<T>):VecBase<T> {
		final dim = array.length;
		final res = new VecBase<T>(dim);
		for (i in 0...dim) {
			res.data[i] = array[i];
		}
		return res;
	}

	overload extern public inline function map(b:VecBase<T>, f:(a:T, b:T) -> T):VecBase<T> {
		if (dim != b.dim)
			throw "vector dimensions mismatch";
		final res = new VecBase<T>(dim);
		for (i in 0...dim) {
			res.data[i] = f(data[i], b.data[i]);
		}
		return res;
	}

	overload extern public inline function map(f:(a:T) -> T):VecBase<T> {
		final res = new VecBase<T>(dim);
		for (i in 0...dim) {
			res.data[i] = f(data[i]);
		}
		return res;
	}

	public function resize(dim:Int, padding:T):VecBase<T> {
		final res = new VecBase<T>(dim);
		for (i in 0...dim) {
			res.data[i] = i < this.dim ? data[i] : padding;
		}
		return res;
	}

	public function getSwizzle(comps:Array<Int>):VecBase<T> {
		final res = new VecBase<T>(comps.length);
		for (i => index in comps) {
			if (index < 0 || index >= dim)
				throw "swizzle index out of bounds";
			res.data[i] = data[index];
		}
		return res;
	}

	public function setSwizzle(comps:Array<Int>, v:VecBase<T>):VecBase<T> {
		if (v.dim != comps.length)
			throw "vector dimensions mismatch";
		final used = [for (i in 0...dim) false];
		for (i => index in comps) {
			if (index < 0 || index >= dim)
				throw "swizzle index out of bounds";
			if (used[index])
				throw "swizzle index must not appear more than once";
			used[index] = true;
			data[index] = v.data[i];
		}
		return v;
	}

	public function copy():VecBase<T> {
		return map(x -> x);
	}

	public function equals(v:VecBase<T>):Bool {
		if (dim != v.dim)
			return false;
		for (i in 0...dim) {
			if (data[i] != v.data[i])
				return false;
		}
		return true;
	}

	public function toString():String {
		return "VecBase(" + data.join(", ") + ")";
	}
}

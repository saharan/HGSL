package hgsl.macro.constant;

import haxe.ds.Vector;

class MatBase {
	public final data:Vector<Float>;
	public final cols:Int;
	public final rows:Int;
	public final size:Int;

	public function new(cols:Int, rows:Int) {
		this.cols = cols;
		this.rows = rows;
		size = cols * rows;
		data = new Vector<Float>(size);
	}

	overload extern public inline function map(b:MatBase, f:(a:Float, b:Float) -> Float):MatBase {
		if (cols != b.cols || rows != b.rows)
			throw "matrix sizes mismatch";
		final res = new MatBase(cols, rows);
		for (i in 0...size) {
			res.data[i] = f(data[i], b.data[i]);
		}
		return res;
	}

	overload extern public inline function map(f:(a:Float) -> Float):MatBase {
		final res = new MatBase(cols, rows);
		for (i in 0...size) {
			res.data[i] = f(data[i]);
		}
		return res;
	}

	public static function fromScalar(v:Float, cols:Int, rows:Int):MatBase {
		final res = new MatBase(cols, rows);
		var i = 0;
		for (col in 0...cols) {
			for (row in 0...rows) {
				res.data[i++] = col == row ? v : 0;
			}
		}
		return res;
	}

	public static function fromVector(v:VecBase<Float>, cols:Int, rows:Int):MatBase {
		if (v.dim != cols * rows)
			throw "vector dimensions mismatch";
		final res = new MatBase(cols, rows);
		for (i in 0...res.size) {
			res.data[i] = v.data[i];
		}
		return res;
	}

	public function toVec():VecBase<Float> {
		final res = new VecBase<Float>(size);
		for (i in 0...size) {
			res.data[i] = data[i];
		}
		return res;
	}

	public function resize(cols:Int, rows:Int):MatBase {
		final origCols = this.cols;
		final origRows = this.rows;
		final res = new MatBase(cols, rows);
		var i = 0;
		for (col in 0...cols) {
			for (row in 0...rows) {
				res.data[i++] = col < origCols && row < origRows ? data[col * origRows + row] : col == row ? 1.0 : 0.0;
			}
		}
		return res;
	}

	public function getCol(index:Int):VecBase<Float> {
		final res = new VecBase<Float>(rows);
		for (i in 0...rows) {
			res.data[i] = data[index * rows + i];
		}
		return res;
	}

	public function setCol(index:Int, col:VecBase<Float>):VecBase<Float> {
		if (rows != col.dim)
			throw "vector dimensions mismatch";
		for (i in 0...rows) {
			data[index * rows + i] = col.data[i];
		}
		return col;
	}

	public function isDiag():Null<Float> {
		var i = 0;
		for (col in 0...cols) {
			for (row in 0...rows) {
				if (data[i++] != (col == row ? data[0] : 0)) {
					return null;
				}
			}
		}
		return data[0];
	}

	public function copy():MatBase {
		return map(x -> x);
	}

	public function equals(v:MatBase):Bool {
		return toVec().equals(v.toVec());
	}
}

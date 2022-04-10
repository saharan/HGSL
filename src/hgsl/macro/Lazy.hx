package hgsl.macro;

abstract Lazy<T>(LazyData<T>) {
	function new(func:() -> T) {
		this = new LazyData(func);
	}

	@:from
	static function make<T>(func:() -> T):Lazy<T> {
		return new Lazy(func);
	}

	@:to
	function eval():T {
		if (this.data == null)
			this.data = this.func();
		return this.data;
	}

	public var data(get, never):T;

	function get_data():T {
		return eval();
	}
}

private class LazyData<T> {
	public final func:() -> T;
	public var data:T;

	public function new(func:() -> T) {
		this.func = func;
		data = null;
	}
}

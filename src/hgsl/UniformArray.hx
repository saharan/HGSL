package hgsl;

@:forward.new
@:forward(name, type)
abstract UniformArray<T>(UniformArrayData<T>) {
	@:op([])
	function get(i:Int):T {
		return this.data[i];
	}

	public var length(get, never):Int;

	function get_length():Int {
		return this.data.length;
	}

	public function iterator():Iterator<T> {
		return this.data.iterator();
	}

	public function map<S>(f:(item:T) -> S):Array<S> {
		return this.data.map(f);
	}

	@:to
	function toUniform():Uniform {
		return {
			name: this.name,
			type: this.type
		}
	}
}

class UniformArrayData<T> {
	public final data:Array<T>;
	public final name:String;
	public final type:UniformType;

	public function new(data:Array<T>, name:String, type:UniformType) {
		this.data = data;
		this.name = name;
		this.type = type;
	}
}

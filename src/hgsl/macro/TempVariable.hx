package hgsl.macro;

class TempVariable {
	final entries:Array<{source:Source, pos:Int}> = [];

	@:allow(hgsl.macro.Environment)
	var name(default, set):String;

	public function new(name:String) {
		this.name = name;
	}

	@:allow(hgsl.macro.Source)
	function add(to:Source):Void {
		final pos = to.add(name);
		entries.push({
			source: to,
			pos: pos
		});
	}

	function set_name(name:String):String {
		this.name = name;
		for (entry in entries) {
			entry.source.modify(entry.pos, name);
		}
		return name;
	}
}

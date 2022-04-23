package hgsl.macro;

#if macro
class ParsedFunction {
	public final name:String;
	public final source:Source;

	public function new(name:String) {
		this.name = name;
		source = new Source();
	}
}
#end

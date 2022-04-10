package hgsl.macro;

class ParsedFunction {
	public final name:String;
	public final returnType:GType;
	public final args:Array<GFuncArg>;
	public final source:Source;

	public function new(name:String, returnType:GType, args:Array<GFuncArg>) {
		this.name = name;
		this.returnType = returnType;
		this.args = args;
		source = new Source();
	}
}

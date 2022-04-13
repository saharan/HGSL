package hgsl.macro;

#if macro
class ParsedFunction {
	public final name:String;
	// public final returnType:GType;
	// public final args:Array<GFuncArg>;
	public final defSource:Source;
	public final mainSource:Source;

	public function new(name:String /*,returnType:GType, args:Array<GFuncArg>*/) {
		this.name = name;
		// this.returnType = returnType;
		// this.args = args;
		defSource = new Source();
		mainSource = new Source();
	}
}
#end

package hgsl.macro;

#if macro
private enum SourceToken {
	Break;
	IncreaseIndent;
	DecreaseIndent;
	String(s:String);
	Placeholder(p:Placeholder);
	Source(s:Source);
}

class Source {
	final tokens:Array<SourceToken> = [];

	public function new() {
	}

	overload extern public inline function add(token:String):Void {
		tokens.push(String(token));
	}

	overload extern public inline function add(p:Placeholder):Void {
		tokens.push(Placeholder(p));
	}

	public function addPlaceholder(initialValue:String):Placeholder {
		final p = {str: initialValue}
		add(p);
		return p;
	}

	public function append(src:Source, copy:Bool):Void {
		if (copy) {
			for (token in src.tokens) {
				tokens.push(token);
			}
		} else {
			tokens.push(Source(src));
		}
	}

	public function increaseIndent():Void {
		tokens.push(IncreaseIndent);
	}

	public function decreaseIndent():Void {
		tokens.push(DecreaseIndent);
	}

	public function breakLine():Void {
		if (tokens.length == 0 || tokens[tokens.length - 1] != Break)
			tokens.push(Break);
	}

	public function toString():String {
		final buf = new StringBuf();
		var indent = 0;
		var head = true;
		var parseSource:(tokens:Array<SourceToken>) -> Void = null;
		parseSource = tokens -> {
			for (token in tokens) {
				switch token {
					case Break:
						buf.add("\n");
						head = true;
					case IncreaseIndent:
						indent++;
					case DecreaseIndent:
						indent--;
					case String(s) | Placeholder(_.str => s):
						if (head) {
							head = false;
							buf.add([for (i in 0...indent) "\t"].join(""));
						}
						buf.add(s);
					case Source(s):
						parseSource(s.tokens);
				}
			}
		}
		parseSource(tokens);
		return buf.toString();
	}
}
#end

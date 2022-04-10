package hgsl.macro;

private enum SourceTokenData {
	Break;
	IncreaseIndent;
	DecreaseIndent;
	String(s:String);
}

private class SourceToken {
	public var data:SourceTokenData;

	public function new(data:SourceTokenData) {
		this.data = data;
	}
}

class Source {
	final tokens:Array<SourceToken> = [];

	public function new() {
	}

	overload extern public inline function add(token:String):Int {
		tokens.push(new SourceToken(String(token)));
		return tokens.length - 1;
	}

	overload extern public inline function add(tmp:TempVariable):Void {
		tmp.add(this);
	}

	public function append(src:Source):Void {
		for (token in src.tokens) {
			tokens.push(token);
		}
	}

	public function increaseIndent():Void {
		tokens.push(new SourceToken(IncreaseIndent));
	}

	public function decreaseIndent():Void {
		tokens.push(new SourceToken(DecreaseIndent));
	}

	public function breakLine():Void {
		if (tokens.length == 0 || tokens[tokens.length - 1].data != Break)
			tokens.push(new SourceToken(Break));
	}

	public function modify(index:Int, newToken:String):Void {
		tokens[index].data = String(newToken);
	}

	public function toString():String {
		final buf = new StringBuf();
		var indent = 0;
		var head = true;
		for (token in tokens) {
			switch token.data {
				case Break:
					buf.add("\n");
					head = true;
				case IncreaseIndent:
					indent++;
				case DecreaseIndent:
					indent--;
				case String(s):
					if (head) {
						head = false;
						buf.add([for (i in 0...indent) "\t"].join(""));
					}
					buf.add(s);
			}
		}
		return buf.toString();
	}
}

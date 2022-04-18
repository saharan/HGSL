package hgsl.macro;

import haxe.CallStack;
#if macro
import haxe.macro.Context;

class GError {
	public final message:String;
	public final pos:Position;

	public function new(message:String, pos:Position) {
		this.message = message;
		this.pos = pos;
	}
}

// return a usual error
function error(message:String, pos:Position):GError {
	return new GError(message, pos);
}

// return an internal error, which is less likely an user's fault
function ierror(messageExpr:Expr):GError {
	var msg:String = cast messageExpr.getValue();
	msg += " (from " + Context.currentPos() + ")";
	msg += "\n" + CallStack.toString(CallStack.callStack());
	return new GError(msg, messageExpr.pos);
}

final errors:Array<GError> = [];

function addError(message:String, pos:Position):Void {
	errors.push(error(message, pos));
}

private var firstStamp = 0.0;
private var prevStamp = 0.0;

function stamp(e:Expr):Void {
	final stamp = Timer.stamp();
	if (firstStamp == 0.0) {
		firstStamp = stamp;
		prevStamp = stamp;
	}
	Context.info("dt = " + (stamp - prevStamp) * 1000 + " ms, t = " + (stamp - firstStamp) * 1000 + " ms " + Context.currentPos(), e.pos);
	// trace("dt = " + (stamp - prevStamp) * 1000 + " ms, t = " + (stamp - firstStamp) * 1000 + " ms " + e.pos);
	prevStamp = stamp;
}
#end

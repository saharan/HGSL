package hgsl.macro;

import haxe.macro.Context;

#if macro
class FunctionToParse {
	public final target:GFunc;
	public final userFuncData:UserFuncData;
	public final passedFuncs:Array<GFunc>;
	public final normalArgs:Array<NamedType> = [];
	public final funcArgs:Array<{name:String, type:GFuncType, func:GFunc}> = [];

	public function new(target:GFunc, passedFuncs:Array<GFunc>) {
		this.target = target;
		this.passedFuncs = passedFuncs;
		userFuncData = switch target.kind {
			case BuiltIn | BuiltInConstructor:
				throw ierror(macro "unexpected built-in function");
			case User(data):
				data;
		}
		checkArguments();
	}

	function checkArguments():Void {
		final funcArgs = target.args.filter(arg -> arg.type.isFunctionType()).map(arg -> switch arg.type {
			case TFunc(f):
				{
					name: arg.name,
					type: f,
					func: null
				}
			case TFuncs(_):
				throw ierror(macro "unexpected functions type");
			case _:
				throw ierror(macro "expected function type");
		});
		if (funcArgs.length != passedFuncs.length)
			throw ierror(macro "function argument count mismatch");
		if (!funcArgs.zip(passedFuncs, (a, f) -> {
			a.func = f;
			f.canImplicitlyCast(a.type);
		}).all())
			throw ierror(macro "function types mismatch");
		final normalArgs = target.args.filter(arg -> !arg.type.isFunctionType()).map(arg -> {name: arg.name, type: arg.type});
		for (a in funcArgs)
			this.funcArgs.push(a);
		for (a in normalArgs)
			this.normalArgs.push(a);
	}

	public function generateKey():String {
		final env = userFuncData.env;
		return env.module + "." + env.className + "." + target.name + "(" + target.args.map(arg -> arg.type.toString())
			.join(",") + "):" + target.type.toString() + "<" + passedFuncs.map(f -> f.name + "(" + f.pos + ")").join(", ") + ">";
	}
}
#end

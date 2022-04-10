package hgsl.macro;

import haxe.macro.Context;

#if macro
@:using(hgsl.macro.FieldChain.FieldChainTools)
@:forward(length, iterator, keyValueIterator, map, slice, concat, join)
abstract FieldChain(Array<String>) from Array<String> to Array<String> {
}

private class FieldChainTools {
	public static function splitClassFieldAccess(path:FieldChain, pos:Position):{type:Type, fieldAccess:FieldChain} {
		final len = path.length;
		if (len == 0)
			throw ierror(macro "path is empty");
		var typeIndex = -1;
		for (i => ident in path) {
			if (~/^[A-Z]/.match(ident)) {
				typeIndex = i;
				break;
			}
		}
		if (typeIndex == -1) {
			throw error("unknown class field access", pos);
		}
		final pack = path.slice(0, typeIndex);
		final typeName = path[typeIndex];
		final possibleSubName = {
			final nextString = typeIndex == len - 1 ? null : path[typeIndex + 1];
			nextString != null
			&& ~/^[A-Z]/.match(nextString) ? nextString : null;
		}
		var type:Type = null;
		var fieldAccess:FieldChain = null;
		if (possibleSubName != null) {
			// try including subtype
			final cp = TPath({
				pack: pack,
				name: typeName,
				sub: possibleSubName
			});
			try {
				type = Context.resolveType(cp, (macro "ignore this error message").pos);
				switch type {
					case TDynamic(_):
						type = null;
						throw "no Dynamic";
					case _:
				}
				fieldAccess = path.slice(typeIndex + 2);
			} catch (e) {
				// type not found :(
			}
		}
		if (type == null) { // try without sub
			final cp = TPath({
				pack: pack,
				name: typeName,
				sub: null
			});
			try {
				type = cp.toType();
				fieldAccess = path.slice(typeIndex + 1);
			} catch (e) {
				// type not found :(
				throw error("type " + pack.concat([typeName]).join(".") + " not found", pos);
			}
		}

		return {
			type: type.follow(),
			fieldAccess: fieldAccess
		}
	}

	public static function toExpr(path:FieldChain, pos:Position):Expr {
		return path.fold((p, e) -> {
			if (e == null) {
				{
					expr: EConst(CIdent(p)),
					pos: pos
				}
			} else {
				{
					expr: EField(e, p),
					pos: pos
				}
			}
		}, null);
	}
}
#end

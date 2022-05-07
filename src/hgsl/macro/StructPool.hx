package hgsl.macro;

#if macro
class StructPool {
	var structId:Int = 0;
	final structNameMap:Map<String, String> = new Map();
	final structs:Array<{
		name:String,
		fields:GStructFields,
		source:String,
		used:Bool
	}> = [];

	public function new() {
	}

	public function resetUsage():Void {
		for (struct in structs) {
			struct.used = false;
		}
	}

	public function getUsedStructs():Array<{name:String, source:String}> {
		return structs.filter(s -> s.used).map(s -> {name: s.name, source: s.source});
	}

	public function getStructName(fields:GStructFields, parser:Parser):String {
		final rawName = TStruct(fields).toString();
		// check if already exists
		if (structNameMap.exists(rawName)) {
			final name = structNameMap[rawName];
			// mark as used
			structs.find(s -> s.name == name).used = true;
			return name;
		}
		// register
		final shortName = "Struct" + structId++;
		final source = "struct " + shortName + " {\n" + [for (field in fields) "\t" + field.type.toGLSLTypeOfName(field.name,
			parser) + ";"].join("\n") + "\n};";
		structNameMap[rawName] = shortName;
		structs.push({
			name: shortName,
			fields: fields,
			source: source,
			used: true
		});
		return shortName;
	}
}
#end

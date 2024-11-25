package data.loaders;

typedef NPCDefJSON =
{
	var name:String;
	var image:String;
	var states:Array<NPCState>;
}

typedef NPCState =
{
	var name:String;
	var dlg:Array<NPCDLG>;
}

typedef NPCDLG =
{
	var text:NPCText;
	var ?if_flag:String;
	var ?unless_flag:String;
}

/**Seems excessive until we start fucking with cutscenes just sayin*/
typedef NPCText =
{
	var str:String;
}

@:forward
abstract NPCDef(NPCDefJSON) from NPCDefJSON
{
	public function new(def:NPCDefJSON)
		this = def;

	public function get_state_dlg(state_name:String):Array<NPCDLG>
	{
		for (state in this.states)
			if (state.name == state_name)
				return state.dlg;
		return null;
	}
}


class NPCLoader
{
	public static function load_npc_defs_from_file(map:Map<String, NPCDef>, file_path:String)
	{
		var xml:Xml = Utils.file_to_xml(file_path);
		for (npc_xml in xml.tags("npc"))
			map.set(npc_xml.get("name"), xml_to_npc_def(npc_xml));
	}

	static function xml_to_npc_def(npc_xml:Xml):NPCDef
	{
		var name:String = npc_xml.get("name");
		var image:String = npc_xml.get("image") != null ? npc_xml.get("image") : name;

		var def:NPCDefJSON = {
			name: name,
			image: image,
			states: parse_npc_states(npc_xml.tags("state"))
		};

		// trace(haxe.Json.stringify(def, "\t"));

		return new NPCDef(def);
	}

	static function parse_npc_states(state_xmls:Array<Xml>):Array<NPCState>
		return state_xmls.map((state_xml) -> parse_npc_state(state_xml));

	static function parse_npc_state(state_xml:Xml):NPCState
		return {
			name: state_xml.get("name"),
			dlg: parse_npc_dlgs(state_xml.tags("dlg"))
		};

	static function parse_npc_dlgs(dlg_xmls:Array<Xml>):Array<NPCDLG>
		return dlg_xmls.map((dlg_xml) -> parse_npc_dlg(dlg_xml));

	static function parse_npc_dlg(dlg_xml:Xml):NPCDLG
	{
		var if_flag:String = dlg_xml.get("if");
		var unless_flag:String = dlg_xml.get("unless");
		var text:NPCText = {str: dlg_xml.firstChild().toString()};

		var npc_dlg:NPCDLG = {text: text};

		if (if_flag != null)
			npc_dlg.if_flag = if_flag;

		if (unless_flag != null)
			npc_dlg.unless_flag = unless_flag;

		return npc_dlg;
	}
}
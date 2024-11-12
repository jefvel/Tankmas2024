package data;

import data.types.TankmasDefs.CostumeDef;

/**
 * Mostly a wrapper for a JSON loaded costumes Map
 */
class Costumes
{
	static var costumes:Map<String, CostumeDef>;

	public static var all_defs(get, default):Array<CostumeDef>;
	public static var all_names(get, default):Array<String>;

	public static function init()
		load_costumes();

	static function load_costumes()
	{
		costumes = [];
		var json:{costumes:Array<CostumeDef>} = haxe.Json.parse(Utils.load_file_string("costumes.json"));

		for (costume_def in json.costumes)
			costumes.set(costume_def.name, costume_def);
	}

	public static function get(costume_name:String)
		return costumes.get(costume_name);

	static function get_all_defs():Array<CostumeDef>
	{
		var arr:Array<CostumeDef> = [];
		for (val in costumes)
			arr.push(val);
		return arr;
	}

	static function get_all_names():Array<String>
	{
		var arr:Array<String> = [];
		for (val in costumes.keys())
			arr.push(val);
		return arr;
	}
}
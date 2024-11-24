package ui.sheets;

import entities.Player;
import ui.sheets.BaseSelectSheet;
import ui.sheets.defs.SheetDefs.SheetFileDef;

class CostumeSelectSheet extends BaseSelectSheet
{
	static var saved_sheet:Int = 0;

	public function new()
		super(saved_sheet);

	override function make_sheet_collection():SheetFileDef
		return haxe.Json.parse(Utils.load_file_string('costume-sheets.json'));
	override function kill()
	{
		// missing fields for the below - ?
		// Player.costume = data.Costumes.get(sheet_collection.sheets[current_sheet].items[current_selection].name);
		super.kill();
	}
}

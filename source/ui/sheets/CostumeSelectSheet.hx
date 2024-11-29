package ui.sheets;

import entities.Player;
import ui.sheets.BaseSelectSheet;
import ui.sheets.defs.SheetDefs.SheetFileDef;

class CostumeSelectSheet extends BaseSelectSheet
{
	static var saved_sheet:Int = 0;
	static var saved_selection:Int = 0;

	public function new()
		super(saved_sheet, saved_selection, COSTUME);

	override function make_sheet_collection():SheetFileDef
		return haxe.Json.parse(Utils.load_file_string('costume-sheets.json'));

	override function kill()
	{
		// TODO: save currently-selected costume
		PlayState.self.player.new_costume(data.JsonData.get_costume(characterNames[current_sheet][current_selection]));
		saved_sheet = current_sheet;
		saved_selection = current_selection;
		super.kill();
	}
}

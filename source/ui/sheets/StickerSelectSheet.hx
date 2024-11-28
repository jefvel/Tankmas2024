package ui.sheets;

import entities.Player;
import ui.sheets.BaseSelectSheet;
import ui.sheets.defs.SheetDefs.SheetFileDef;

class StickerSelectSheet extends BaseSelectSheet
{
	static var saved_sheet:Int = 0;
	static var saved_selection:Int = 0;

	public function new()
		super(saved_sheet, saved_selection, STICKER);

	override function make_sheet_collection():SheetFileDef
		return haxe.Json.parse(Utils.load_file_string('sticker-sheets.json'));

	override function kill()
	{
		Player.sticker = characterNames[current_sheet][current_selection];
		saved_sheet = current_sheet;
		saved_selection = current_selection;
		super.kill();
	}
}

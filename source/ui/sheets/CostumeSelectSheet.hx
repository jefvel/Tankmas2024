package ui.sheets;

import ui.sheets.BaseSelectSheet;
import ui.sheets.defs.SheetDefs.SheetFileDef;

class CostumeSelectSheet extends BaseSelectSheet
{
	static var saved_sheet:Int = 0;

	public function new()
		super(saved_sheet);

	override function make_sheet_collection():SheetFileDef
		return haxe.Json.parse(Utils.load_file_string('costume-sheets.json'));
}

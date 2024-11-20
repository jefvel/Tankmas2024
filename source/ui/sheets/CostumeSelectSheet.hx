package ui.sheets;

import ui.sheets.BaseSelectSheet;
class CostumeSelectSheet extends BaseSelectSheet
{
	override function make_sheet_collection()
		haxe.Json.parse(Utils.load_file_string('costume-grid.json'));
}

package ui.sheets;

import ui.sheets.BaseSelectSheet;

class StickerSelectSheet extends BaseSelectSheet
{
	override function make_sheet_collection()
		haxe.Json.parse(Utils.load_file_string('sticker-grid.json'));
}

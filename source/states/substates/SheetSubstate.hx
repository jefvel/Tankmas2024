package states.substates;

import flixel.FlxBasic;
import flixel.util.FlxTimer;
import ui.sheets.BaseSelectSheet;
import ui.sheets.CostumeSelectSheet;
import ui.sheets.StickerSelectSheet;

class SheetSubstate extends flixel.FlxSubState
{
	var sheet_ui:BaseSelectSheet;

	override public function new(sheet_ui:BaseSelectSheet)
	{
		super();

		this.sheet_ui = sheet_ui;

		add(sheet_ui);

		trace("substate exists");
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (Ctrl.jaction[1] && sheet_ui.canSelect) {
			sheet_ui.transOut();
			new FlxTimer().start(1.2, function(tmr:FlxTimer) {close();});
		}
	}


	override function close()
	{
		sheet_ui.kill();
		super.close();
	}
}
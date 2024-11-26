package states.substates;

import flixel.FlxBasic;
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
		if (Ctrl.menuConfirm[1] || Ctrl.menuBack[1])
			close();
	}


	override function close()
	{
		// TODO: save currently-selected costume
		sheet_ui.kill();
		super.close();
	}
}
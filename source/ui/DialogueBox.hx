package ui;

import data.types.TankmasFontTypes;
import flixel.text.FlxText;
import squid.ext.FlxGroupExt;

class DialogueBox extends FlxGroupExt
{
	var text:FlxText;
	var bg:FlxSpriteExt;

	public function new(input_text:String)
	{
		super();

		PlayState.self.dialogues.add(this);

		/*
			text = new FlxTextBMP(200, 159, 1208);
			text.set_format(TextFormatPreset.DEFAULT_WHITE);
			text.fieldWidthSet((FlxG.width / 2).floor());
		 */

		text = Utils.formatText(new FlxText(0, 0, 1216), TextFormatPresets.DIALOGUE);
		bg = new FlxSpriteExt(Paths.get("dialogue-box.png"));

		bg.setPosition(FlxG.width / 2 - bg.width / 2, 0);

		text.text = input_text;
		text.setPosition(bg.x + 194, bg.y + 130);

		sstate(IDLE);

		bg.scrollFactor.set(0, 0);
		text.scrollFactor.set(0, 0);

		add(bg);
		add(text);
	}

	override function kill()
	{
		PlayState.self.dialogues.remove(this, true);
		super.kill();
	}

	override function update(elapsed:Float)
	{
		fsm();
		super.update(elapsed);
	}

	function fsm()
		switch (cast(state, State))
		{
			default:
		}
}

private enum abstract State(String) from String to String
{
	var IDLE;
}

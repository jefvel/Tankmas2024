package ui;

import data.loaders.NPCLoader;
import data.types.TankmasFontTypes;
import flixel.text.FlxText;
import squid.ext.FlxGroupExt;
import squid.ui.FlxTextBMP;

class DialogueBox extends FlxGroupExt
{
	#if ttf
	var text:FlxText;
	#else
	var text:FlxTextBMP;
	#end

	var bg:FlxSpriteExt;

	var dlgs:Array<NPCDLG>;

	var dlg(get, never):NPCDLG;

	var index:Int = 0;

	var type_rate:Int = 2;

	public function get_dlg():NPCDLG
		return dlgs[index];

	public function new(dlgs:Array<NPCDLG>)
	{
		super();

		PlayState.self.dialogues.add(this);

		/*
			text = new FlxTextBMP(200, 159, 1208);
			text.set_format(TextFormatPreset.DEFAULT_WHITE);
			text.fieldWidthSet((FlxG.width / 2).floor());
		 */

		#if ttf
		text = Utils.formatText(new FlxText(0, 0, 1216), TextFormatPresets.DIALOGUE);
		#else
		text = new FlxTextBMP(0, 0, 1216, TextFormatPresets.DIALOGUE);
		text.fieldWidthSet(1216);
		#end
		
		bg = new FlxSpriteExt(Paths.get("dialogue-box.png"));

		bg.setPosition(FlxG.width / 2 - bg.width / 2, 0);

		#if ttf
		// temp
		text.setPosition(bg.x + 194, bg.y + 130);
		switch (TextFormatPresets.DIALOGUE.font.name.split(".")[0])
		{
			case "crappy-handwriting":
				text.y += 42;
		}
		#else
		text.setPosition(bg.x + 194, bg.y + 150);
		text.lineSpacing = -28;
		#end

		sstate(IDLE);

		bg.scrollFactor.set(0, 0);
		text.scrollFactor.set(0, 0);

		add(bg);
		add(text);
		load_dlg(dlgs[index]);
	}

	public function load_dlg(dlg:NPCDLG)
		text.text = dlg.text.str;

	public function next_dlg()
	{
		index = index + 1;
		if (index < dlgs.length)
			load_dlg(dlgs[index]);
	}

	public function type() {}


	override function update(elapsed:Float)
	{
		text.offset_adjust();
		fsm();
		super.update(elapsed);
	}

	function fsm()
		switch (cast(state, State))
		{
			default:
			case TYPING:
		}
	override function kill()
	{
		PlayState.self.dialogues.remove(this, true);
		super.kill();
	}
}

private enum abstract State(String) from String to String
{
	var IDLE;
	var TYPING;
	var IN;
	var OUT;
}

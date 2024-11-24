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

	var line_number:Int = 0;

	var type_index:Int;
	var type_rate:Int = 2;

	public function get_dlg():NPCDLG
		return dlgs[line_number];

	var options:DialogueBoxOptions;

	var line_finished(get, default):Bool;

	public function get_line_finished()
		return type_index >= dlg.text.str.length;

	public function new(dlgs:Array<NPCDLG>, ?options:DialogueBoxOptions)
	{
		super();

		this.dlgs = dlgs;
		this.options = options == null ? {} : options;

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

		sstate(TYPING);

		bg.scrollFactor.set(0, 0);
		text.scrollFactor.set(0, 0);

		add(bg);
		add(text);
		load_dlg(dlgs[line_number]);
	}

	public function load_dlg(dlg:NPCDLG)
	{
		text.text = "";
		type_index = 0;
	}

	public function next_dlg()
	{
		line_number = line_number + 1;
		if (line_number < dlgs.length)
		{
			load_dlg(dlgs[line_number]);
			sstate(TYPING);
		}
		else
			close_dlg();
	}

	public function close_dlg()
	{
		kill();
	}

	public function type()
	{
		type_index = type_index + 1;
		text.text = dlg.text.str.substr(0, type_index);
		if (line_finished)
			sstate(IDLE);
	}

	override function update(elapsed:Float)
	{
		// text.offset_adjust();
		fsm();
		super.update(elapsed);
	}

	function fsm()
		switch (cast(state, State))
		{
			default:
			case TYPING:
				if (Ctrl.jjump[1])
					type_index = dlg.text.str.length - 1;
				if (ttick() % type_rate == 0)
					type();
			case IDLE:
				if (line_finished)
				{
					if (Ctrl.jjump[1])
						next_dlg();
				}
		}

	override function kill()
	{
		options.on_complete != null ? options.on_complete() : false;
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

typedef DialogueBoxOptions =
{
	var ?on_complete:Void->Void;
}

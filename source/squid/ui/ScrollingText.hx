package squid.ui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.text.FlxText;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class ScrollingText extends FlxSprite
{
	var txt:FlxText;

	public function new(text:String)
	{
		super(0, 0);
		makeGraphic(320, 12, FlxColor.BLACK);
		txt = new FlxText(255 + 64, 0, 0, text);

		txt.scrollFactor.set(0, 0);
		scrollFactor.set(0, 0);

		FlxG.state.add(this);
		FlxG.state.add(txt);
	}

	override public function update(elapsed:Float):Void
	{
		txt.x -= FlxG.width / 120;
		if (!txt.isOnScreen())
		{
			txt.kill();
			kill();
		}
		super.update(elapsed);
	}
}

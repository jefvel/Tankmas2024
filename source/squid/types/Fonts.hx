package squid.types;

import flixel.system.FlxAssets;

class Fonts
{
	public static var MAIN:FontSave;
	public static var DIALOGUE:FontSave;
	public static var BITMAP:FontSave;
	public static var MINI:FontSave;

	public static function init()
	{
		MAIN = {name: FlxAssets.FONT_DEFAULT, size: 8};
		DIALOGUE = {name: Paths.get("newgrounds.ttf"), size: 24};
		BITMAP = {name: Paths.get("PixelMplus10-Regular.ttf"), size: 10};
		MINI = {name: Paths.get("mini-6px-normal.ttf"), size: 8};
	}
}

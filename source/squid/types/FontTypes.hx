package squid.types;

import flixel.text.FlxText.FlxTextAlign;

/**
 * Saved info about a font
 */
typedef FontDef =
{
	var name:String;

	/**This is a default size*/
	var size:Int;
}

typedef TextOutlineDef =
{
	var color:Int;
	var thickness:Int;
}

typedef TextFormatDef =
{
	var font:FontDef;

	var ?color:Int;

	/**If set, this overrides font.size*/
	var ?size:Int;

	var ?alignment:FlxTextAlign;

	var ?outline:TextOutlineDef;
}
package squid.ui;

import flixel.graphics.frames.FlxBitmapFont;
import flixel.text.FlxBitmapText;
import squid.types.FontTypes;

/**
 * ...
 * @author 
 */
class FlxTextBMP extends FlxBitmapText
{
	var scroll_rate:Int = 0;

	public function new(?x:Float = 0, ?y:Float = 0, ?fieldWidth:Int, ?scroll_rate:Int = 0, ?text:String, ?font_name:String = "pixelmplus10-bitmap")
	{
		var bmp_graphic:String = Paths.get('${font_name}.png');
		var bmp_defines:String = Paths.get('${font_name}.fnt');

		var bmpFont:FlxBitmapFont = FlxBitmapFont.fromAngelCode(bmp_graphic, bmp_defines);

		this.fieldWidth = fieldWidth;

		super(x, y, bmpFont);

		this.multiLine = true;
		this.autoSize = false;

		this.text = text;
	}

	public function fieldWidthSet(newWidth:Int)
		set_fieldWidth(newWidth);

	public function set_format(format:TextFormatDef)
	{
		//TODO: implement bitmap fonts?
		// lineSpacing = 2;
		// switch (format)
		// {
		// 	case DEFAULT_BLACK:
		// 		color = FlxColor.BLACK;
		// 	case DEFAULT_WHITE:
		// 		color = FlxColor.WHITE;
		// 		setBorderStyle(OUTLINE, FlxColor.BLACK);
		// 	case PAUSE_BODY_CENTERED:
		// 		set_format(PAUSE_BODY);
		// 		alignment = FlxTextAlign.CENTER;
		// 	case PAUSE_BODY:
		// 		color = FlxColor.BLACK;
		// }
	}
}


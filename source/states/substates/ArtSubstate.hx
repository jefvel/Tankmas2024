package states.substates;

class ArtSubstate extends flixel.FlxSubState
{
	var art:FlxSpriteExt;

	override public function new(content:String)
	{
		super();
		art = new FlxSpriteExt(0, 0, Paths.get('$content.png'));
		art.setGraphicSize(width > height ? FlxG.camera.viewWidth : 0, width < height ? FlxG.camera.viewHeight : 0);
		art.screenCenter();
		add(art);

		final
	}
}
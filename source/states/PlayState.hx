package states;

import entities.Player;
import entities.Present;
import entities.base.BaseUser;
import entities.base.NGSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import fx.StickerFX;
import fx.Thumbnail;
import haxe.display.Protocol.HaxeRequestMethod;
import net.tankmas.OnlineLoop;
import net.tankmas.TankmasClient;
import states.substates.SheetSubstate;
import ui.sheets.CostumeSelectSheet;


class PlayState extends BaseState
{
	public static var self:PlayState;

	var bg:FlxSpriteExt;

	public var player:Player;
	public var users:FlxTypedGroup<BaseUser> = new FlxTypedGroup<BaseUser>();
	public var presents:FlxTypedGroup<Present> = new FlxTypedGroup<Present>();
	public var thumbnails:FlxTypedGroup<Thumbnail> = new FlxTypedGroup<Thumbnail>();
	public var shadows:FlxTypedGroup<FlxSpriteExt> = new FlxTypedGroup<FlxSpriteExt>();
	public var stickers:FlxTypedGroup<StickerFX> = new FlxTypedGroup<StickerFX>();
	public var sticker_fx:FlxTypedGroup<NGSprite> = new FlxTypedGroup<NGSprite>();

	override public function create()
	{
		super.create();
		self = this;

		OnlineLoop.init();
		
		bgColor = FlxColor.GRAY;

		add(bg = new FlxSpriteExt(Paths.get("bg-outside-hotel.png")));

		add(shadows);
		add(presents);
		add(users);
		add(thumbnails);
		add(stickers);
		add(sticker_fx);

		new Player();
		
		player.center_on(bg);

		new Present();

		FlxG.camera.target = player;

		FlxG.camera.setScrollBounds(bg.x, bg.width, bg.y, bg.height);
		OnlineLoop.iterate();
	}

	override public function update(elapsed:Float)
	{
		OnlineLoop.iterate();

		super.update(elapsed);
		// Ctrl.update();

		if (Ctrl.reset[1])
			FlxG.switchState(new PlayState());
		if (Ctrl.jaction[1])
			new CostumeSelectSheet();
	}

	override function destroy()
	{
		self = null;
		super.destroy();
	}
}

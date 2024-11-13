package states;

import fx.StickerFX;
import entities.Player;
import entities.Present;
import entities.base.BaseUser;
import flixel.FlxState;
import flixel.text.FlxText;
import net.tankmas.OnlineLoop;
import net.tankmas.TankmasClient;


class PlayState extends BaseState
{
	public static var self:PlayState;

	var bg:FlxSpriteExt;

	public var player:Player;
	public var users:FlxTypedGroup<BaseUser> = new FlxTypedGroup<BaseUser>();
	public var presents:FlxTypedGroup<Present> = new FlxTypedGroup<Present>();
	public var shadows:FlxTypedGroup<FlxSpriteExt> = new FlxTypedGroup<FlxSpriteExt>();
	public var stickers:FlxTypedGroup<StickerFX> = new FlxTypedGroup<StickerFX>();

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
		add(stickers);

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

		if (FlxG.keys.anyJustPressed(["R"]))
			FlxG.switchState(new PlayState());
	}

	override function destroy()
	{
		self = null;
		super.destroy();
	}
}

package states;

import entities.Player;
import entities.Present;
import flixel.FlxState;
import flixel.text.FlxText;

class PlayState extends BaseState
{
	public static var self:PlayState;

	public var players:FlxTypedGroup<Player> = new FlxTypedGroup<Player>();
	public var presents:FlxTypedGroup<Present> = new FlxTypedGroup<Present>();
	public var player_shadows:FlxTypedGroup<FlxSpriteExt> = new FlxTypedGroup<FlxSpriteExt>();

	override public function create()
	{
		super.create();
		self = this;
		
		bgColor = FlxColor.GRAY;

		add(player_shadows);
		add(presents);
		add(players);

		new Player();
		new Present();
	}

	override public function update(elapsed:Float)
	{
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

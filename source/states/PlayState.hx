package states;

import flixel.FlxState;
import flixel.text.FlxText;

class PlayState extends BaseState
{
	public var self:PlayState;

	override public function create()
	{
		super.create();
		self = this;
		add(new FlxText(0, 0, 0, "Hello World", 32).screenCenter());
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

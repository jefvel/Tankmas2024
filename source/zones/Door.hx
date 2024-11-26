package zones;

import ldtk.Json.EntityReferenceInfos;
import ldtk.Point;
import ldtk.Project;

/**
 * Sigh here we go again
 */
class Door extends FlxSpriteExt
{
	var linked_door_ref:EntityReferenceInfos;
	var spawn:FlxPoint;

	public function new(?X:Float, ?Y:Float, width:Int, height:Int, linked_door_ref:EntityReferenceInfos, spawn:ldtk.Point)
	{
		super(X, Y);

		trace(linked_door_ref);

		this.linked_door_ref = linked_door_ref;

		this.spawn = new FlxPoint(X + spawn.cx * 16, Y + spawn.cy * 16);

		makeGraphic(width, height, FlxColor.YELLOW);
		alpha = 0.5;

        PlayState.self.doors.add(this);

		sstate(IDLE);
	}

	override function update(elapsed:Float)
	{
		fsm();
		super.update(elapsed);
	}

	function get_linked_door() {}

	override function updateMotion(elapsed:Float)
	{
		super.updateMotion(elapsed);
	}

	function fsm()
		switch (cast(state, State))
		{
			default:
			case IDLE:
				if (overlaps(PlayState.self.player))
					start_door_out();
			case DOOR_OUT:
			case DOOR_IN:
		}

	function start_door_out()
	{
		var new_world:String="";

		for (world in Main.ldtk_project.worlds)
			if (world.iid == linked_door_ref.worldIid)
				new_world = world.identifier;


		FlxG.switchState(new PlayState(new_world));
	}

	override function kill()
	{
        PlayState.self.doors.remove(this,true);
		super.kill();
	}
}

private enum abstract State(String) from String to String
{
	var IDLE;
	var DOOR_OUT;
	var DOOR_IN;
}

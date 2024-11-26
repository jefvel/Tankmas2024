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

	var next_world:String;

	static var level_transition_door_iid:String = "";

	public function new(?X:Float, ?Y:Float, width:Int, height:Int, linked_door_ref:EntityReferenceInfos, spawn:FlxPoint, iid:String)
	{
		super(X, Y);

		trace(linked_door_ref);

		this.linked_door_ref = linked_door_ref;

		this.spawn = spawn;

		makeGraphic(width, height, FlxColor.YELLOW);
		alpha = 0.5;

        PlayState.self.doors.add(this);

		sstate(IDLE);
		if (level_transition_door_iid == iid)
			sstate(DOOR_IN);
	}

	override function update(elapsed:Float)
	{
		fsm();
		super.update(elapsed);
	}

	function fsm()
		switch (cast(state, State))
		{
			default:
			case IDLE:
				if (overlaps(PlayState.self.player))
					start_door_out();
			case DOOR_OUT:
				// PUT TRANSITION HERE
				sstate(WAIT);
				dip();
			case DOOR_IN:
				PlayState.self.player.center_on(spawn);
				sstate(IDLE);
		}

	function start_door_out()
	{
		for (world in Main.ldtk_project.worlds)
			if (world.iid == linked_door_ref.worldIid)
				next_world = world.identifier;

		level_transition_door_iid = linked_door_ref.entityIid;

		sstate(DOOR_OUT);
	}

	function dip()
	{
		FlxG.switchState(new PlayState(next_world));
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
	var WAIT;
}

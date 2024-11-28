package entities;

import entities.base.BaseUser;
import net.tankmas.NetDefs.NetEventDef;

class ActivityAreaInstance extends FlxObject
{
	var player:BaseUser;
	var activity_area:ActivityArea;

	public function new(player:BaseUser, activity_area:ActivityArea)
	{
		super();
		this.player = player;
		this.activity_area = activity_area;
	}

	public function on_leave() {}

	public function on_interact() {}

	public function on_event(event:NetEventDef) {}
}
package entities;

import entities.ActivityAreaInstance;
import entities.base.BaseUser;
import entities.bonfire.BonfireArea;
import haxe.Constraints;
import levels.TankmasLevel;
import net.tankmas.NetDefs.NetEventDef;

enum ActivityType
{
	Bonfire;
}

@:generic
class ActivityArea<T:Class<ActivityAreaInstance> = ActivityAreaInstance> extends FlxObject
{
	var active_players:Map<String, T> = new Map();

	public function new(X, Y)
	{
		super(x, y);
	}

	public function on_enter(player:BaseUser)
	{
		if (active_players[player.username] != null)
			return;

		var area = new T(player, this);

		active_players[player.username] = area;
	}

	public function on_leave(player:BaseUser)
	{
		var area = active_players[player.username];
		if (area == null)
			return;

		area.on_leave();
		active_players[player.username] = null;
	}

	public function on_event(event:NetEventDef, player:BaseUser)
	{
		var area = active_players[player.username];
		if (area == null)
			return;
		area.on_event(event);
	}

	// Happens when the local player presses the interact button
	public function on_interact(player:Player)
	{
		var area = active_players[player.username];
		if (area == null)
			return;
		area.on_interact();
	}
}
package entities.bonfire;

import net.tankmas.OnlineLoop;

class BonfireArea extends ActivityAreaInstance
{
	var stick: BonfireStick;
	public function new(player, area)
	{
		super(area.x, area.y);
		trace('created at $x, $y, size 100');
		stick = new BonfireStick(x, y, this);
		stick.activate();
	}
	
	override function on_leave() {
		super.on_leave();
		stick.hide();
		destroy();
	}


	override function on_interact() {
		var marshmallow = stick.marshmallow;
		if (marshmallow != null) {
			OnlineLoop.post_marshmallow_discard(Main.current_room_id, marshmallow.current_level);
		}
		stick.shake_off();
	}
}

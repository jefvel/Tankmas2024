package entities;

import data.types.TankmasDefs.CostumeDef;
import data.types.TankmasEnums.Costumes;
import entities.base.BaseUser;
import net.tankmas.OnlineLoop;

class NetUser extends BaseUser
{
	var move_tween:FlxTween;
	var last_hit:Int = 0;

	var min_move_dist:Int = 10;

	var teleport_move:Bool = true;

	var moving:Bool = false;

	var prev_position:FlxPoint = new FlxPoint();
	
	public function new(?X:Float, ?Y:Float, username:String, ?costume:CostumeDef)
	{
		super(X, Y, username);
		type = "net-user";

		new_costume(costume);
		move_to(X, Y, true);
	}

	override function update(elapsed:Float)
	{
		move_animation_handler(moving);
		super.update(elapsed);
		prev_position.set(x, y);
	}

	public function move_to(X:Float, Y:Float, teleport:Bool = false)
	{
		if (teleport)
		{
			prev_position.set(x, y);
			setPosition(x, y);
			return;
		}

		var total_move_dist:Float = Math.abs(x - X) + Math.abs(y - Y);

		if (total_move_dist < min_move_dist)
			return;

		if (move_tween != null)
		{
			move_tween.cancel();
			move_tween.destroy();
			move_tween = null;
		}

		move_tween = FlxTween.tween(this, {x: X, y: Y}, OnlineLoop.tick_rate * .001, {onUpdate: update_moving, onComplete: finish_moving});
	}

	function finish_moving(tween:FlxTween)
		moving = false;

	function update_moving(tween:FlxTween)
		moving = true;

}
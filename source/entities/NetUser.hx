package entities;

import data.types.TankmasDefs.CostumeDef;
import entities.base.BaseUser;
import flixel.math.FlxVelocity;
import net.tankmas.OnlineLoop;

class NetUser extends BaseUser
{
	var move_tween:FlxTween;
	var last_hit:Int = 0;

	var min_move_dist:Int = 32;

	var teleport_move:Bool = true;

	var moving:Bool = false;

	var move_target:FlxPoint = new FlxPoint();

	public function new(?X:Float, ?Y:Float, username:String, ?costume:CostumeDef)
	{
		super(X, Y, username);
		type = "net-user";

		new_costume(costume);
		move_to(X, Y, true);
		trace("NEW USER " + username);
	}

	override function update(elapsed:Float)
	{
		if (moving && distance(move_target) > 0)
			move_update();

		move_animation_handler(moving);

		super.update(elapsed);
	}

	override function updateMotion(elapsed:Float)
	{
		// var prev_x:Float = x;
		// var prev_y:Float = y;

		super.updateMotion(elapsed);

		// var total_move_dist:Float = Math.abs(x - prev_x) + Math.abs(y - prev_y);

		if (velocity.x != 0)
			flipX = velocity.x > 0;
	}

	public function move_update()
	{
		if (distance(move_target) < min_move_dist)
		{
			move_to(move_target.x, move_target.y, true);
			return;
		}

		FlxVelocity.moveTowardsPoint(this, move_target, move_speed);
	}

	public function move_to(X:Float, Y:Float, teleport:Bool = false)
	{
		if (teleport)
		{
			setPosition(x, y);
			velocity.set(0, 0);
			acceleration.set(0, 0);
			moving = false;

			return;
		}

		moving = true;

		move_target.set(X, Y).add(origin.x, origin.y);

		move_update();
	}
}
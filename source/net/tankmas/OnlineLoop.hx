package net.tankmas;

import data.types.TankmasDefs.CostumeDef;
import data.types.TankmasEnums.Costumes;
import entities.NetUser;
import entities.Player;
import entities.base.BaseUser;
import net.tankmas.TankmasClient;

/**
 * The main game online update loop, yea!
 */
class OnlineLoop
{
	public static var tick_rate:Float = 0;

	static var last_update_timestamp:Float;
	static var current_timestamp(get, default):Float;

	static function get_current_timestamp():Float
		return haxe.Timer.stamp();

	public static function init()
	{
		tick_rate = 0;
		last_update_timestamp = current_timestamp;
	}

	public static function iterate()
	{
		var time_diff:Float = current_timestamp - last_update_timestamp;

		if (time_diff > tick_rate * .001 && tick_rate > -1)
		{
			last_update_timestamp = current_timestamp;
			OnlineLoop.update_player_position("1", PlayState.self.player);
		}
	}

	public static function update_player_position(room_id:String, user:Player)
	{
		tick_rate = 999;
		TankmasClient.post_user(room_id, {
			name: Main.username,
			x: user.x.floor(),
			y: user.y.floor(),
			costume: user.costume.name
		}, update_user_visuals);
	}

	public static function update_room(room_id:String)
	{
		tick_rate = 999;
		TankmasClient.get_users_in_room(room_id, update_user_visuals);
	}

	public static function update_user_visuals(data:Dynamic)
	{
		var usernames:Array<String> = Reflect.fields(data.data);

		usernames.remove(Main.username);

		for (username in usernames)
		{
			var def:NetUserDef = Reflect.field(data.data, username);
			var costume:CostumeDef = Costumes.string_to_costume(def.costume);
			var user:BaseUser = BaseUser.get_user(username, function()
			{
				return new NetUser(def.x, def.y, username, costume);
			});

			cast(user, NetUser).move_to(def.x, def.y);

			if (user.costume == null || user.costume.name != costume.name)
				user.new_costume(costume);
		}
		tick_rate = data.tick_rate;
	}
}

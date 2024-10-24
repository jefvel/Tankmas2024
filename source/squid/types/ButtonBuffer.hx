package squid.types;

import haxe.ds.ObjectMap;

/**
 * Map that handles Button Buffers
 */
class ButtonBuffer
{
	final DEFAULT_BUFFER_TIME:Int = 10;

	/**Buffer CD for input locking */
	public var cd:Int = 2;

	var charge_opposites:Map<String, String>;

	var buffer_time:Int = 0;

	public var team:Int;

	var buffer:Map<String, Int> = [];

	public function new(team:Int, ?buffer_time:Int)
	{
		this.team = team;
		this.buffer_time = buffer_time == null ? DEFAULT_BUFFER_TIME : buffer_time;
	}

	/**
	 * Manages attack buffers
	 */
	public function buffer_update()
	{
		cd--;
		if (cd > 0)
			return;

		if (charge_opposites == null)
		{
			charge_opposites = new Map<String, String>();
			for (key in ["jump", "attack", "special", "use"])
				charge_opposites.set(key + "_hold", key + "_release");
		}

		for (key in buffer.keys())
		{
			set(key, get(key) - 1);
			if (get_int(key) <= 0)
				remove(key);
			if (key.indexOf("_hold") > -1 && exists(charge_opposites.get(key)))
				switch (key)
				{
					case "attack_hold":
						!Ctrl.attack[team] ? set(key, 2) : "pass";
					case "jump_hold":
						!Ctrl.jump[team] ? set(key, 2) : "pass";
					case "special_hold":
						!Ctrl.special[team] ? set(key, 2) : "pass";
					case "use_hold":
						!Ctrl.use[team] ? set(key, 2) : "pass";
				}
		}

		buffer_input(Ctrl.jattack[team], "attack");
		buffer_input(Ctrl.jjump[team], "jump");
		buffer_input(Ctrl.jspecial[team], "special");
		buffer_input(Ctrl.juse[team], "use");

		buffer_input(Ctrl.rattack[team], "attack_release");
		buffer_input(Ctrl.rjump[team], "jump_release");
		buffer_input(Ctrl.rspecial[team], "special_release");
		buffer_input(Ctrl.ruse[team], "use_release");

		buffer_input(Ctrl.down[team], "down_hold");
		buffer_input(Ctrl.attack[team], "attack_hold");
		buffer_input(Ctrl.jump[team], "jump_hold");
		buffer_input(Ctrl.special[team], "special_hold");
		buffer_input(Ctrl.use[team], "use_hold");

		if (buffer_input(Ctrl.jjump[team] && Ctrl.down[team] || Ctrl.jroll[team], "roll"))
			remove("jump");

		// trace(cd, team, this);
	}

	/**
	 * Buffers an input, handles hold/release inputs
	 */
	public function buffer_input(input:Bool, key:String):Bool
	{
		if (cd > 0)
			return false;
		if (input)
		{
			if (key.indexOf("_hold") <= -1)
				set(key, buffer_time);
			else
				set(key, !exists(key) ? 2 : get_int(key) + 2);
			return true;
		}
		return false;
	}

	public function get_int(key:String):Int
	{
		// for (key_2 in keys())
		// if (key == "attack")
		// trace(key == key_2, key, key_2, exists(key), get(key), this, exists(key) ? get(key) : -1);
		return exists(key) ? get(key) : -1;
	}

	public function exists(key:String):Bool
		return buffer.exists(key);

	public function get(key:String):Int
		return buffer.get(key);

	public function set(key:String, val:Int)
		buffer.set(key, val);

	public function clear()
		buffer.clear();

	public function remove(key:String)
		buffer.remove(key);
}

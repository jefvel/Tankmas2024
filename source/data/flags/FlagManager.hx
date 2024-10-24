package data.flags;

class FlagManager
{
	var flags:Map<String, Dynamic> = new Map<String, Dynamic>();

	public function new() {}

	public function set(key:String, val:Dynamic)
		flags.set(key, val);

	public function bool(key:String):Bool
	{
		var val:Dynamic = flags.get(key);
		if (val == null)
			return false;
		if (val is Bool)
			return val;
		else if (val is Int)
			return val > 0;
		else if (val is Float)
			return val > 0;
		else if (val is String)
			throw 'FlagManager Error: Using .bool(key) on String: (${key} : ${val}) [${Type.typeof(val)}]';
		throw 'FlagManager Error: Unknown type for val in .bool(key): (${key} : ${val}) [${Type.typeof(val)}]';
	}

	public function greater(key:String, target:Float):Bool
		return cast(flags.get(key), Float) > target;

	public function lesser(key:String, target:Float):Bool
		return cast(flags.get(key), Float) < target;

	public function equals(key:String, target:Float):Bool
		return cast(flags.get(key), Float) == target;

	/**Greater than or equals to */
	public function gre(key:String, target:Float):Bool
		return cast(flags.get(key), Float) >= target;

	public function clear()
		flags.clear();
}

package squid.sprite;

class FlxSpriteGroupExt extends FlxSpriteGroup
{
	var state:String = "";
	var tick:Int = 0;

	var trace_new_state:Bool = false;

	public function new(?X:Float, ?Y:Float)
	{
		super(X, Y);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	/**
	 * Switch state
	 * @param s new state
	 * @param reset_tick resets ticking int
	 */
	public function sstate(s:String, reset_tick:Bool = true)
	{
		#if dev_trace
		if (trace_new_state && state != s)
			trace('New State: ${state} -> ${s}');
		#end
		if (reset_tick)
			tick = 0;
		state = s;
	}

	function ttick():Int
		return tick = tick + 1;
}

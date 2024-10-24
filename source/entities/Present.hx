package entities;

class Present extends FlxSpriteExt
{
	public var detect_range:Int = 100;

	public function new(?X:Float, ?Y:Float)
	{
		super(X, Y);
		PlayState.self.presents.add(this);
	}

	override function kill() {
		PlayState.self.presents.remove(this,true);
		super.kill();
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
			case NEARBY:
				animProtect("nearby");

			case OPENING:
				animProtect("opening");
				if(animation.finished)
					sstate(OPENED);
			case OPENED:			
				animProtect("opened");

		
		}

	public static function find_present_in_detect_range(player:Player) {
		var presents_in_range:Array<{present:Present, distance:Float}>=[];
		var mp_player:FlxPoint= player.mp();

		for(present in PlayState.self.presents){
			var distance:Float=Utils.getDistance(present.mp(),player.mp());
			if(distance<=present.detect_range)
				presents_in_range.push({present:present, distance:distance});
		}

		if(presents_in_range.length>0){
			presents_in_range.sort((a, b) -> a.distance > b.distance ? 1 : -1); //might be other way around
			return presents_in_range.pop(); //or this might be shift
		}

		return null;
	}
}

private enum abstract State(String) from String to String {
	final IDLE;
	final NEARBY;
	final OPENING;
	final OPENED;
}

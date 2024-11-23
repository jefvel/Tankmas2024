package entities;

import data.types.TankmasEnums.PresentAnimation;
import entities.base.NGSprite;
import fx.Thumbnail;

class Present extends NGSprite
{
	public var detect_range:Int = 300;

	public var openable:Bool = true;
	public static var opened:Bool = false;

	public var thumbnail:Thumbnail;

	public function new(?X:Float, ?Y:Float, ?day:Int = 1, ?content:String = 'thedyingsun', opened:Bool = false)
	{
		super(X, Y);
		loadAllFromAnimationSet('present-${day}');

		PlayState.self.presents.add(this);

		this.center_on(PlayState.self.player);
		x += 500;
		if (!opened)
		{
			sprite_anim.anim(PresentAnimation.IDLE);
			sstate(IDLE);
		}
		else
		{
			// sprite_anim.anim(PresentAnimation.OPENED);
			sstate(OPENED);
		}
		thumbnail = new Thumbnail(x, y - 200, Paths.get('$content.png'));
		// PlayState.self.thumbnails.add(thumbnail);
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
				sprite_anim.anim(PresentAnimation.IDLE);
				thumbnail.sstate("CLOSE");
			case NEARBY:
				sprite_anim.anim(PresentAnimation.NEARBY);
				thumbnail.sstate("OPEN");
			case OPENING:
				// animProtect("opening");
				// if(animation.finished)
				// sstate(OPENED);
			case OPENED:			
				// animProtect("opened");
		}

	public static function find_present_in_detect_range(player:Player):Present
	{
		var presents_in_range:Array<{present:Present, distance:Float}>=[];
		var mp_player:FlxPoint = player.mp;

		for(present in PlayState.self.presents){
			var distance:Float = present.mp.distance(player.mp);
			if(distance<=present.detect_range)
				presents_in_range.push({present:present, distance:distance});
		}

		if(presents_in_range.length>0){
			presents_in_range.sort((a, b) -> a.distance > b.distance ? 1 : -1); //might be other way around
			return presents_in_range.pop().present; // or this might be shift
		}

		return null;
	}
	public static function un_mark_all_presents()
	{
		for (present in PlayState.self.presents)
			present.mark_target(false);
	}

	public function mark_target(mark:Bool)
	{
		if (!opened)
		{
			if (mark && openable)
				sstate(NEARBY);
			if (!mark && openable)
				sstate(IDLE);
		}
		else
		{
			if (mark && thumbnail.scale.x == 0)
				thumbnail.sstate("OPEN")
			else if (!mark && thumbnail.scale.x != 0 && thumbnail.state != "CLOSE")
				thumbnail.sstate("CLOSE");
		}
	}

	override function updateMotion(elapsed:Float)
	{
		super.updateMotion(elapsed);
		// TODO: thumbnail here
	}

	public function open()
	{
		if (openable)
			sstate(OPENING);
		openable = false;
	}
}

private enum abstract State(String) from String to String {
	final IDLE;
	final NEARBY;
	final OPENING;
	final OPENED;
}

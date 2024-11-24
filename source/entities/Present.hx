package entities;

import data.types.TankmasEnums.PresentAnimation;
import entities.base.NGSprite;
import fx.Thumbnail;

class Present extends Interactable
{
	public var openable:Bool = true;
	public static var opened:Bool = false;

	public var thumbnail:Thumbnail;

	public function new(?X:Float, ?Y:Float, ?day:Int = 1, ?content:String = 'thedyingsun', opened:Bool = false)
	{
		super(X, Y);
		detect_range = 300;
		interactable = true;

		type = Interactable.InteractableType.PRESENT;
		
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

	override function kill()
	{
		PlayState.self.presents.remove(this, true);
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
<<<<<<< HEAD
				animProtect("opening");
				if (animation.finished)
					sstate(OPENED);
			case OPENED:
				animProtect("opened");
=======
				// animProtect("opening");
				// if(animation.finished)
				// sstate(OPENED);
			case OPENED:			
				// animProtect("opened");
>>>>>>> main
		}

	override public function mark_target(mark:Bool)
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

private enum abstract State(String) from String to String
{
	final IDLE;
	final NEARBY;
	final OPENING;
	final OPENED;
}

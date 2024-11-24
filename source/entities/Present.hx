package entities;

import data.types.TankmasEnums.PresentAnimation;
import entities.base.NGSprite;

class Present extends Interactable
{
	public var openable:Bool = true;

	public function new(?X:Float, ?Y:Float)
	{
		super(X, Y);
		detect_range = 300;
		interactable = true;

		type = Interactable.InteractableType.PRESENT;
		
		loadAllFromAnimationSet("present-1");

		PlayState.self.presents.add(this);

		this.center_on(PlayState.self.player);
		x += 500;
		sprite_anim.anim(PresentAnimation.IDLE);
		sstate(IDLE);
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
			case NEARBY:
				sprite_anim.anim(PresentAnimation.NEARBY);
			case OPENING:
				animProtect("opening");
				if (animation.finished)
					sstate(OPENED);
			case OPENED:
				animProtect("opened");
		}

	override public function mark_target(mark:Bool)
	{
		if (mark && openable)
			sstate(NEARBY);
		if (!mark && openable)
			sstate(IDLE);
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

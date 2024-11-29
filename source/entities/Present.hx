package entities;

import data.JsonData;
import data.SaveManager;
import data.types.TankmasDefs.PresentDef;
import data.types.TankmasEnums.PresentAnimation;
import entities.base.NGSprite;
import flixel.util.FlxTimer;
import fx.Thumbnail;
import states.substates.ArtSubstate;
import states.substates.ComicSubstate;

class Present extends Interactable
{
	public var openable:Bool = true;
	public static var opened:Bool = false;

	public var thumbnail:Thumbnail;
	var content:String;
	var day:Int = 0;
	var comic:Bool = false;

	public function new(?X:Float, ?Y:Float, ?content:String = 'thedyingsun')
	{
		super(X, Y);
		detect_range = 300;
		interactable = true;
		this.content = content;
		var presentData:PresentDef = JsonData.get_present(this.content);
		if (presentData == null)
		{
			throw 'Error getting present: content ${content}; defaulting to default content';
			presentData = JsonData.get_present('thedyingsun');
		}
		comic = presentData.comicProperties != null ? true : false;
		opened = SaveManager.savedPresents.contains(content);
		day = Std.parseInt(presentData.day);

		type = Interactable.InteractableType.PRESENT;
		
		loadAllFromAnimationSet('present-$content');

		PlayState.self.presents.add(this);

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
		thumbnail = new Thumbnail(x, y - 200, Paths.get((content + (comic ? '-0' : '') + '.png')));
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
				if (Ctrl.jspecial[1])
					open();
			case OPENING:
				// animProtect("opening");
			case OPENED:			
				// animProtect("opened");
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
			if (mark /** && thumbnail.scale.x == 0**/)
			{
				thumbnail.sstate("OPEN");
				if (Ctrl.jspecial[1])
					open();
			}
			else if (!mark /** && thumbnail.scale.x != 0 && thumbnail.state != "CLOSE"**/)
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
		if (state != "OPENED")
		{
			sstate(OPENING);
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				// TODO: sound effect
				sstate(OPENED);
				PlayState.self.openSubState(comic ? new ComicSubstate(content, true) : new ArtSubstate(content));
				opened = true;
				SaveManager.open_present(content, day);
			});
		}
		else
		{
			// TODO: sound effect
			PlayState.self.openSubState(comic ? new ComicSubstate(content, false) : new ArtSubstate(content));
		}
		// openable = false;
		// }
	}
}

private enum abstract State(String) from String to String
{
	final IDLE;
	final NEARBY;
	final OPENING;
	final OPENED;
}

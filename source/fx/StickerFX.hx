package fx;

import data.types.TankmasDefs.SpriteAnimationDef;
import entities.base.NGSprite;
import squid.util.Utils;
import states.PlayState;

class StickerFX extends NGSprite
{
	var idle_time:Int = 60;
	var parent:NGSprite;

	public function new(parent:NGSprite, name:String)
	{
		super();

		this.parent = parent;

		loadGraphic(Paths.get(name + ".png"));

		PlayState.self.stickers.add(this);

		sstate(IN);

		trace_new_state = true;
	}

	override function updateMotion(elapsed:Float)
	{
		this.center_on_top(parent);
		super.updateMotion(elapsed);
	}

	override function update(elapsed:Float)
	{
		fsm();
		super.update(elapsed);
	}

	function fsm()
		switch (cast(state, State))
		{
			case IN:
				sprite_anim.anim(StickerAnimations.IN);
				if (sprite_anim.finished)
					sstate(IDLE);
			case IDLE:
				sprite_anim.anim(StickerAnimations.IDLE);
				if (ttick() > idle_time)
					sstate(OUT);
			case OUT:
				sprite_anim.anim(StickerAnimations.OUT);
				if (sprite_anim.finished)
					kill();
		}
}

private enum abstract State(String) from String to String
{
	var IN;
	var IDLE;
	var OUT;
}

enum abstract StickerAnimations(SpriteAnimationDef) from SpriteAnimationDef to SpriteAnimationDef
{
	public static final IN:SpriteAnimationDef = {
		name: "in",
		fps: Utils.ms_to_frames_per_second("40ms"),
		looping: false,
		frames: [
			{
				duration: 1,
				y: 20,
				height: 0.3
			},
			{
				duration: 1,
				y: -10,
				height: 0.5
			},
			{
				duration: 2,
				y: 20,
				height: 0.75,
			},
			{
				duration: 2,
				y: -40,
				height: 0.75,
			}
		]
	};

	public static final IDLE:SpriteAnimationDef = {
		name: "idle",
		fps: Utils.ms_to_frames_per_second("40ms"),
		looping: true,
		frames: [
			{
				duration: 1,
				x: 0,
				y: 0,
				angle: 0,
				height: 1.0,
				width: 1.0
			}
		]
	};

	public static final OUT:SpriteAnimationDef = {
		name: "out",
		fps: Utils.ms_to_frames_per_second("40ms"),
		looping: false,
		frames: [
			{
				duration: 2,
				x: 0,
				y: -10,
				angle: 0,
				height: 1,
				width: 1.0
			},
			{
				duration: 2,
				y: 10,
				angle: 0,
				height: 0.5,
			},
			{
				duration: 2,
				y: -10,
				height: 0.15,
			}
		]
	};
}
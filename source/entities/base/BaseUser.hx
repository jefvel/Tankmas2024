package entities.base;

import data.JsonData;
import data.types.TankmasDefs.CostumeDef;
import data.types.TankmasEnums.PlayerAnimation;
import entities.base.NGSprite;

class BaseUser extends NGSprite
{
	public var costume:CostumeDef;

	var move_acl:Int = 60;
	var move_speed:Int = 500;

	var shadow:FlxSpriteExt;

	public var username:String;

	public var sticker_name:String;

	public function new(?X:Float, ?Y:Float, username:String)
	{
		super(X, Y);

		type = "base-user";
		
		this.username = username;

		new_costume(JsonData.get_costume("tankman"));
		sprite_anim.anim(PlayerAnimation.MOVING);

		PlayState.self.users.add(this);
		PlayState.self.shadows.add(shadow = new FlxSpriteExt(Paths.get("player-shadow.png")));

		maxVelocity.set(move_speed, move_speed);

		sprite_anim.anim(PlayerAnimation.IDLE);

		drag.set(300, 300);
	}

	public function use_sticker(sticker_name:String):Bool
	{
		if (this.sticker_name == sticker_name)
			return false;
		this.sticker_name = sticker_name;
		new fx.StickerFX(this, sticker_name, () -> this.sticker_name = null);
		return true;
	}

	function move_animation_handler(moving:Bool)
	{
		switch (sprite_anim.name)
		{
			default:
			case "idle" | null:
				if (moving)
					sprite_anim.anim(PlayerAnimation.MOVING);
			case "moving":
				if (!moving)
					sprite_anim.anim(PlayerAnimation.IDLE);
		}
	}

	public function new_costume(costume:CostumeDef)
	{
		loadGraphic(Paths.get('${costume.name}.png'));
		original_size.set(width, height);
	}

	override function updateMotion(elapsed:Float)
	{
		super.updateMotion(elapsed);

		shadow.center_on_bottom(this);
		shadow.offset.x = offset.x;
		shadow.updateMotion(elapsed);
	}

	override function kill()
	{
		PlayState.self.users.remove(this, true);
		super.kill();
	}

	public static function get_user(username:String, ?make_user_function:Void->BaseUser):BaseUser
	{
		for (user in PlayState.self.users)
			if (user.username == username)
				return user;
		return make_user_function == null ? null : make_user_function();
	}
}

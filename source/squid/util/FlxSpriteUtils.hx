package squid.util;

/**
 * Tools for FlxSprites, not just FlxSpriteExts
 */
class FlxSpriteUtils
{
	/**Centers sprite  on another sprite or point*/
	public static inline function center_on<T:FlxObject>(obj:T, ?sprite:FlxObject, ?point:FlxPoint):T
	{
		if (sprite != null)
			obj.setPosition(sprite.x + sprite.width * .5 - obj.width * .5, sprite.y + sprite.height * .5 - obj.height * .5);
		if (point != null)
			obj.setPosition(point.x - obj.width * .5, point.y - obj.height * .5);

		return obj;
	}

	/**center_on() but only on x value*/
	public static inline function center_on_x<T:FlxObject>(obj:T, sprite:FlxObject):T
	{
		obj.setPosition(sprite.x + sprite.width * .5 - obj.width * .5, obj.y);
		return obj;
	}

	/**center_on() but only on y value*/
	public static inline function center_on_y<T:FlxObject>(obj:T, sprite:FlxObject):T
	{
		obj.setPosition(obj.x, sprite.y + sprite.height * .5 - obj.height * .5);
		return obj;
	}

	/**center_on() but on bottom of another sprite (top of obj touches bottom of sprite)*/
	public static inline function center_on_bottom<T:FlxObject>(obj:T, sprite:FlxObject):T
	{
		obj.setPosition(sprite.x + sprite.width * .5 - obj.width * .5, sprite.y + sprite.height - obj.height);
		return obj;
	}

	/**center_on() but on top of another sprite (bottom of obj touches top of sprite)*/
	public static inline function center_on_top<T:FlxObject>(obj:T, sprite:FlxObject, offset_y:Int = 0):T
	{
		obj.setPosition(sprite.x + sprite.width * .5 - obj.width * .5, sprite.y - obj.height + offset_y);
		return obj;
	}
}

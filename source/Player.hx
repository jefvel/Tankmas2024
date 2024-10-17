package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class Player extends FlxSprite
{
	static inline var SPEED:Float = 300;

	public var halo:FlxSprite;
	public var body:FlxSprite;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);
        makeGraphic(50, 50, FlxColor.BLUE);
		halo = new FlxSprite(x,y);
		//width = 32;
		//height = 32;


		drag.x = drag.y = 800;

		

	}

	override function update(elapsed:Float) {
		updateMovement();
		super.update(elapsed);
	}

	function updateMovement() {
		var up:Bool = false;
		var down:Bool = false;
		var left:Bool = false;
		var right:Bool = false;

		//Key detection
		up = FlxG.keys.anyPressed([UP, W]);
		down = FlxG.keys.anyPressed([DOWN, S]);
		left = FlxG.keys.anyPressed([LEFT, A]);
		right = FlxG.keys.anyPressed([RIGHT, D]);

		//canceling out movement
		if(up && down){
			up = down = false;
		}
		if(left && right){
			left = right = false;
		}

		var angle:Float = 0; // CW working

		if(up || down || left || right){
			if(up){
				angle = -90;
	
				if(left){
					angle -= 45;
				}
				if(right){
					angle += 45;
				}
	
			} else if(down) {
				angle = 90;
	
				if(left){
					angle += 45;
				}
				if(right){
					angle -= 45;
				}
	
			} else if(left) {
				angle = 180;
			} else if(right) {
				angle = 0; // redundant, but who cares?
			}
	
			velocity.setPolarDegrees(SPEED, angle);
		}
		





		
	}
}
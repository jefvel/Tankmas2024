#if deprecated
package;

import entities.*;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText.FlxTextAlign;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxDirection;
import haxe.Template;
import js.lib.intl.Collator.Collation;

class PlayState extends FlxState
{
	var locationText = new flixel.text.FlxText(0, 0, 0, "Loaded", 16);
	var presentPlaceholder = new FlxSprite(850, 900);
	var tempWall = new FlxSprite(0, 600);
	var player:Player = new Player(400, 750);
	var wall:FlxGroup;
	var playerHalo:FlxSprite = new FlxSprite(0, 0);

	var overlaps:Bool = false;

	private function switchState():Void
	{
		FlxG.switchState(new OtherState());
	}

	private function thing(object1:FlxSprite, object2:FlxSprite):Void
	{
		overlaps = true;
		// if (Std.is(object2, FlxSprite))
		// {
		// 	presentPlaceholder.color = FlxColor.ORANGE;
		// }
		// else
		// {
		// 	presentPlaceholder.color = FlxColor.CYAN;
		// }
	}

	private function notthing(object1:FlxSprite, object2:FlxSprite):Bool
	{
		presentPlaceholder.color = FlxColor.CYAN;
		return false;
	}

	override public function create()
	{
		super.create();

		var screenWidth = 1920;
		var screenHeight = 1080;
		FlxG.resizeGame(screenWidth, screenHeight);

		var offset = screenWidth * 0.4;

		// testing
		var sprite = new FlxSprite();
		sprite.loadGraphic("assets/Test stuff from Shmood/Background-Outside_(MelonJam 2022).png");
		sprite.screenCenter();
		add(sprite);

		var writing = new flixel.text.FlxText(0, 0, 0, "Hello World\nin this new world", 32);
		var button = new FlxButton(0, 0, "Switch States", switchState);
		// writing.screenCenter();
		// writing.alignment = FlxTextAlign.LEFT;
		writing.color = FlxColor.CYAN;
		// writing.font = "Isonorm";

		presentPlaceholder.makeGraphic(100, 100, FlxColor.CYAN);
		tempWall.makeGraphic(screenWidth, 10, FlxColor.RED);
		tempWall.immovable = true;
		// presentPlaceholder.alpha = 0;
		presentPlaceholder.drag.x = 500;
		presentPlaceholder.drag.y = 500;
		// presentPlaceholder.immovable = true;
		wall = FlxCollision.createCameraWall(FlxG.camera, true, 20, false);

		playerHalo.makeGraphic(100, 100, FlxColor.GRAY);
		add(playerHalo);
		add(writing);
		add(button);
		add(player);
		add(presentPlaceholder);
		add(locationText);
		add(tempWall);
	}

	override public function update(elapsed:Float)
	{
		// clear();
		overlaps = false;

		var xPos = FlxG.mouse.screenX;
		var yPos = FlxG.mouse.screenY;

		playerHalo.x = player.x - 25;
		playerHalo.y = player.y - 25;

		FlxG.collide(presentPlaceholder, player);
		FlxG.collide(wall, player);
		FlxG.collide(tempWall, player);
		FlxG.overlap(playerHalo, presentPlaceholder, thing);

		if (overlaps && FlxG.keys.justPressed.E)
		{
			presentPlaceholder.color = FlxColor.ORANGE;
		}
		else
		{
			presentPlaceholder.color = FlxColor.CYAN;
		}

		locationText.text = xPos + ", " + yPos + ", " + Std.int(1 / elapsed);
		// add(locationText);

		// FlxG.collide(player, presentPlaceholder);

		if (FlxG.keys.justPressed.SPACE)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}

		super.update(elapsed);
	}
}
#end
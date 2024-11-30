package;

import Paths.Manifest;
import data.loaders.NPCLoader;
import flixel.FlxGame;
import levels.LdtkProject;
import openfl.display.Sprite;
import utils.CrashHandler;
import ng.NewgroundsHandler;

class Main extends Sprite
{
	public static var username:String = #if random_username 'poop_${Math.random()}' #else "not_very_squidly" #end;

	public static var current_room_id:String = "1";

	public static var DEV:Bool = #if dev true #else false #end;

	public static var ldtk_project:LdtkProject = new LdtkProject();

	#if newgrounds
	public static var ng_api:NewgroundsHandler;
	#end

	public static function main():Void
	{
		// We need to make the crash handler LITERALLY FIRST so nothing EVER gets past it.
		CrashHandler.initialize();
		CrashHandler.queryStatus();

		openfl.Lib.current.addChild(new Main());
	}

	public function new()
	{
		super();
		Manifest.init(make_game);
	}

	public function make_game()
	{
		Lists.init();
		ng_api = new NewgroundsHandler();
		addChild(new FlxGame(1920, 1080, PlayState, true));
	}
}

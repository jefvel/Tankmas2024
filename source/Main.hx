package;

import Paths.Manifest;
import data.loaders.NPCLoader;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public static var username:String = #if random_username data.Uuid.v4() #else "not_very_squidly" #end;

	public static var current_room_id:String = "1";
	
	public static var DEV:Bool = #if dev true #else false #end;

	public function new()
	{
		super();
		Manifest.init(make_game);
	}

	public function make_game()
	{
		Lists.init();
		NPCLoader.load_npc_defs_from_file(Paths.get("test-npcs.xml"));
		addChild(new FlxGame(1920, 1080, PlayState, true));
	}
}

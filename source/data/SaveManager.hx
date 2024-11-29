package data;

import entities.Player;

class SaveManager
{
	public static var savedPresents:Array<String> = [];
	public static var savedCostumes:Array<String> = [];
	public static var savedEmotes:Array<String> = [];
	public static var savedRoom:String = "outside_hotel";

	public static function init()
	{
		// opened presents
		load_presents();

		// unlocked costumes, as well as what the player is currently wearing
		load_costumes();

		// unlocked emotes, as well as what emote the player is currently using
		load_emotes();

		// loads current room
		load_room();
	}

	public static function save()
	{
		save_presents();
		save_costumes();
		save_emotes();
		save_room();
		FlxG.save.flush();
	}

	public static function load_presents(force:Bool = false):Void
	{
		if (FlxG.save.data.savedPresents == null)
		{
			trace("Error loading saved presents");
			save_presents(true);
		}
		savedPresents = FlxG.save.data.savedPresents;
	}

	public static function load_costumes():Void
	{
		if (FlxG.save.data.savedCostumes == null)
		{
			trace("Error loading saved costumes");
			save_costumes(true);
		}
		savedCostumes = FlxG.save.data.savedCostumes;
		if (FlxG.save.data.currentCostume != null && PlayState.self != null)
			PlayState.self.player.new_costume(FlxG.save.data.currentCostume);
	}

	public static function load_emotes():Void
	{
		if (FlxG.save.data.savedEmotes == null)
		{
			trace("Error loading saved emotes");
			save_emotes(true);
		}
		savedEmotes = FlxG.save.data.savedEmotes;
		if (FlxG.save.data.currentEmote != null && PlayState.self != null)
			PlayState.self.player.sticker = FlxG.save.data.currentEmote;
	}

	public static function load_room():Void
	{
		if (FlxG.save.data.savedRoom == null)
		{
			trace("Error loading saved room");
			save_room(true);
		}
		savedRoom = FlxG.save.data.savedRoom;
	}

	public static function open_present(content:String, day:Int)
	{
		if (savedPresents.safeContains(content))
			return;
		savedPresents.push(content);
		// TODO: find medal accompanying present
		save_presents(true);
	}

	public static function save_presents(force:Bool = false)
	{
		FlxG.save.data.savedPresents = savedPresents;
		if (force)
			FlxG.save.flush();
	}

	public static function save_costumes(force:Bool = false)
	{
		FlxG.save.data.savedCostumes = savedCostumes;
		FlxG.save.data.currentCostume = PlayState.self == null ? 'tankman' : PlayState.self.player.costume.name;
		if (force)
			FlxG.save.flush();
	}

	public static function save_emotes(force:Bool = false)
	{
		FlxG.save.data.savedEmotes = savedEmotes;
		FlxG.save.data.currentEmote = PlayState.self == null ? 'edd-sticker' : PlayState.self.player.sticker;
		if (force)
			FlxG.save.flush();
	}

	public static function save_room(force:Bool = false)
	{
		FlxG.save.data.savedRoom = savedRoom;
		if (force)
			FlxG.save.flush();
	}
}
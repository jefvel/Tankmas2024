package data;

import haxe.Serializer;
import haxe.Unserializer;
import ui.AutoSaveIcon;
import ui.ChompyStats.ChompyStatBlock;
import ui.WarpUI;

class ProgressManager
{
	public static var slot:Int = 1;
	public static var date:String = "--/--/--";
	public static var current_slot(get, never):String;

	/*
	 * Reads and Writes progress
	 */
	public static function save_check()
	{
		#if dev
		if (FlxG.save == null)
		{
			trace("Warning! FlxG.save is null!");
			return;
		}
		if (FlxG.save.data == null)
		{
			trace("Warning! FlxG.save.**data** is null!");
			return;
		}
		#end
	}

	public static function start_new_game(from_level:String = "intro")
	{
		#if trace_save
		trace("/////NEW GAME/////");
		#end
	}

	static function get_current_slot():String
		return #if save_selector_test 'test-slot-${slot}' #else 'slot-${slot}' #end;

	public static function load(?slot_name:String):Bool
	{
		save_check();

		var current = Date.now().getTime();

		#if trace_save
		trace('/////Starting Save Data Load/////');
		#end

		bind_main(slot_name);

		var SAVE_VERSION_MISMATCH:Bool = FlxG.save.data.saveVersion != Main.saveVersion;
		#if ignore_save_versions
		SAVE_VERSION_MISMATCH = false;
		#end

		if (SAVE_VERSION_MISMATCH)
		{
			#if trace_save
			if (SAVE_VERSION_MISMATCH)
				trace('////SAVE VERSION MISMATCH ${FlxG.save.data.saveVersion} =/= ${Main.saveVersion}');

			trace('/////Load Result for ${slot_name}: No Save Data/////');
			#end
			return false;
		}

		if (FlxG.save.data.saveVersion == null)
			return false;

		if (FlxG.save.data.flags != null)
			Flags.load(FlxG.save.data.flags);

		if (FlxG.save.data.saveDate != null)
			ProgressManager.date = FlxG.save.data.saveDate;

		#if trace_save
		trace("/////Load Result: All Good/////");
		trace('READ FLAGS: ${Flags.get_all()}');
		trace("/////End Save/////");
		#end

		AutoSaveIcon.load();

		return true;
	}

	public static function save_all(?slot_name:String)
	{
		#if trace_save
		trace('/////Saving -> ${current_slot}/////');
		#end

		bind_main(slot_name);

		if (PlayState.world == "forest")
			FlxG.save.data.introComplete = true;

		save_quests();
		save_emblems();
		save_money();

		save_location();
		save_total_time();
		save_feathers();
		save_maps();
		save_prev_bonus();
		save_bestiary();

		save_flags();
		save_bosses();
		save_key_items();
		save_date();

		FlxG.save.data.music_volume = SoundPlayer.music_volume;
		FlxG.save.data.sound_volume = SoundPlayer.sound_volume;
		FlxG.save.data.saveVersion = Main.saveVersion;

		var flush_result:Bool = FlxG.save.flush();

		#if trace_save
		trace('Quests: ' + FlxG.save.data.questsActive);
		trace("Flags: " + FlxG.save.data.flags);
		trace("Flushed: " + flush_result);

		trace("/////End Save/////");
		#end

		#if switch
		lime.console.nswitch.SaveData.commit();
		#end

		AutoSaveIcon.save();

		#if dev_trace
		trace('WRITING FLAGS: ${Flags.get_all()}');
		#end

		FlxG.save.close();
	}

	public static function save_quests()
	{
		FlxG.save.data.questsActive = QuestTracker.active;
		FlxG.save.data.questsComplete = QuestTracker.complete;
		var s:Serializer = new Serializer();
		s.serialize(QuestTracker.counters);
		FlxG.save.data.questsCounters = s.toString();
		AutoSaveIcon.save();
	}

	public static function save_emblems()
	{
		FlxG.save.data.emblemSlots = PauseEmblems.slots;
		AutoSaveIcon.save();
	}

	public static function save_money()
	{
		FlxG.save.data.gold = PlayState.gold;
		AutoSaveIcon.save();
	}

	public static function save_location()
	{
		FlxG.save.data.curLevel = PlayState.curLevel;
		AutoSaveIcon.save();
	}

	public static function save_total_time()
	{
		FlxG.save.data.stime = PlayState.stime;
		AutoSaveIcon.save();
	}

	public static function save_feathers()
	{
		FlxG.save.data.feathers = PlayState.feathers;
		FlxG.save.data.feathersUsed = PlayState.feathersUsed;
		AutoSaveIcon.save();
	}

	public static function save_maps()
	{
		FlxG.save.data.maps = PlayState.maps;
		FlxG.save.data.mapsUsed = PlayState.mapsUsed;
		AutoSaveIcon.save();
	}

	public static function save_prev_bonus()
	{
		FlxG.save.data.prevBonus = PlayState.curLevel;
		AutoSaveIcon.save();
	}

	public static function save_bestiary()
	{
		FlxG.save.data.bestiary = QuestTracker.bestiary;
		AutoSaveIcon.save();
	}

	public static function save_flags()
	{
		FlxG.save.data.flags = Flags.get_all();
		AutoSaveIcon.save();
	}

	public static function save_bosses()
	{
		AutoSaveIcon.save();
	}

	public static function save_key_items()
	{
		FlxG.save.data.keyItems = QuestTracker.keyItems;
		AutoSaveIcon.save();
	}

	public static function save_date()
	{
		var date:Date = Date.now();
		FlxG.save.data.saveDate = date.getMonth() + "/" + date.getDay() + "/" + date.getFullYear();
	}

	public static function save_chompy_garden()
	{
		bind_garden();

		FlxG.save.data.chompyStats = Lists.chompyStats;
		FlxG.save.data.lastSave = 99;
		AutoSaveIcon.save();

		var flush_attempt:Bool = FlxG.save.flush();

		#if trace_save
		trace("CHOMPY SAVE ATTEMPT: " + flush_attempt);
		trace("CHOMPIES SAVED: " + Lists.chompyStats);
		#end

		FlxG.save.close();
	}

	public static function load_chompy_garden()
	{
		bind_garden();

		Lists.chompyStats = new Map<Int, ChompyStatBlock>();
		if (FlxG.save.data.chompyStats != null)
		{
			debug("Chompy Stat Load" + ", " + FlxG.save.data.chompyStats.h);
			debug("Reflect " + Reflect.fields(FlxG.save.data.chompyStats.h));
			for (key in Reflect.fields(FlxG.save.data.chompyStats.h))
			{
				debug("KEY IS " + key);
				Lists.setChompyStatBlock(Std.parseInt(key), Reflect.field(FlxG.save.data.chompyStats.h, key));
			}
			debug("CHOMPIES LOADED: " + ", " + Lists.chompyStats);
		}
		else
		{
			Utils.scrollMSG("WARNING: Chompy Stats are null");
		}
		FlxG.save.close();
	}

	/**
	 * Clears the whole dang save
	 */
	public static function clear(reset_state:Bool = true)
	{
		#if trace_save
		trace("/////ERASING/////");
		trace("BINDING " + FlxG.save.bind(current_slot, "saves"));
		trace("DATA ERASED: " + FlxG.save.erase());
		#end

		Flags.clear();

		if (reset_state)
			FlxG.switchState(new LoadingState());
	}

	public static function save_controls()
	{
		FlxG.save.data.keys = Ctrl.controls[1];
		debug("Saving Controls: " + ", " + FlxG.save.data.keys + ", " + Ctrl.controls[1]);
		Ctrl.set();
	}

	public static function load_controls()
	{
		if (FlxG.save.data == null)
			return;

		if (FlxG.save.data.keys != null)
			Ctrl.controls[1] = FlxG.save.data.keys;
	}

	static function bind_main(?slot_name:String)
	{
		slot_name = slot_name == null ? current_slot : slot_name;
		var bind_result:Bool = FlxG.save.bind(slot_name, "Renaine/saves");
		#if trace_save
		trace('BINDING TO ${slot_name} RESULT ${bind_result}');
		#end
	}

	public static function load_game_with_save() {}
}

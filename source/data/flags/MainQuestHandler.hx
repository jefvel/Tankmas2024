package data.flags;

import data.flags.Flags;

class MainQuestHandler
{
	public static var prefix:String = "MQ_";

	public static var current(get, default):MainQuestFlag;

	public static function set_main_quest(new_main_quest:MainQuestFlag, ?iid:String, ?source_type:String)
	{
		new_main_quest = new_main_quest.clean_flag();

		for (flag in Flags.get_keys())
			if (flag.indexOf(prefix) > -1)
				Flags.destroy_bool(flag);

		Flags.set_bool('${prefix}${new_main_quest}', true, iid, source_type);

		#if dev_trace
		trace(Flags.get_bool('${prefix}${new_main_quest}'), '${prefix}${new_main_quest}');
		#end
	}

	/**Sets main quest only if it's after the current main quest*/
	public static function update_main_quest(new_main_quest:MainQuestFlag, ?iid:String, ?source_type:String)
	{
		new_main_quest = new_main_quest.clean_flag();

		if (new_main_quest.after(current))
			set_main_quest(new_main_quest, iid, source_type);
	}

	public static function delete_main_quest(quest_flag_to_delete:MainQuestFlag, ?iid:String, ?source_type:String)
	{
		quest_flag_to_delete = quest_flag_to_delete.clean_flag();

		Flags.destroy_bool('${prefix}${quest_flag_to_delete}', iid, source_type);
	}

	static function get_current_main_quest():MainQuestFlag
	{
		for (flag in Flags.get_all().keys())
		{
			var clean_flag:String = flag.split(prefix)[1];

			if (is_valid_main_quest(clean_flag))
				return clean_flag;
		}

		return MainQuestFlag.NONE;
		/*
			for (flag in Flags.get_all().keys())
				if (flag.indexOf(prefix) > -1 && Flags.get_bool(flag))
					return cast(flag.split(prefix)[1], MainQuestFlag);

			return null;
		 */
	}

	public static inline function is_the_main_quest(quest_to_check:MainQuestFlag):Bool
		return current.clean_flag() == quest_to_check.clean_flag();

	/**
	 * Does a happen after b?
	 * WARNING: a == b returns false!
	 */
	public static inline function after(a:MainQuestFlag, ?b:MainQuestFlag):Bool
	{
		// trace(a, a.position(), b, b.position());
		b = b == null ? current : b;

		a = a.clean_flag();
		b = b.clean_flag();

		return a.position() > b.position();
	}

	/**
	 * Does a happen before b?
	 * WARNING: a == b returns false!
	 */
	public static inline function before(a:MainQuestFlag, ?b:MainQuestFlag):Bool
	{
		b = b == null ? current : b;

		a = a.clean_flag();
		b = b.clean_flag();

		return a.position() < b.position();
	}

	/**
	 * a is greater than equal to b
	 */
	public static inline function gte(a:MainQuestFlag, ?b:MainQuestFlag, ?verboise:Bool = false):Bool
	{
		b = b == null ? current : b;

		a = a.clean_flag();
		b = b.clean_flag();

		if (verboise)
			trace(a, b, a.after(b), a == b);

		return a.after(b) || a == b;
	}

	/**
	 * a is less than equal to b
	 */
	public static inline function lte(a:MainQuestFlag, ?b:MainQuestFlag):Bool
	{
		b = b == null ? current : b;

		a = a.clean_flag();
		b = b.clean_flag();

		return a.before(b) || a == b;
	}

	static function get_current():MainQuestFlag
		return get_current_main_quest();

	public inline static function clean_flag(flag:String):MainQuestFlag
		return cast(flag.replace("MQ_", prefix).replace(prefix, ""), MainQuestFlag);

	public inline static function is_valid_main_quest(flag:MainQuestFlag, verboise:Bool = false):Bool
	{
		if (verboise && flag != null)
			trace(flag.clean_flag(), MainQuestFlag.order.indexOf(flag.clean_flag()));
		return flag != null ? MainQuestFlag.order.indexOf(flag.clean_flag()) > -1 : false;
	}
}

enum abstract MainQuestFlag(String) from String to String
{
	public static var order:haxe.ds.ReadOnlyArray<MainQuestFlag> = [
		NONE,
		FOREST_PROLOGUE,
		FOREST_ACT_0_ACTIVE,
		FOREST_ACT_1_ACTIVE,
		FOREST_MINIBOSS_ACTIVE,
		FOREST_ACT_2_ACTIVE,
		FOREST_ACT_3_ACTIVE,
		FOREST_BOSS_PRE,
		FOREST_BOSS_ACTIVE,
		FOREST_BOSS_POST,
		BEACH_FAMILY_QUEST_1,
		BEACH_FAMILY_QUEST_2,
		BEACH_FAMILY_QUEST_3,
		BEACH_FAMILY_QUEST_4,
		BEACH_FAMILY_QUEST_5,
		BEACH_FAMILY_QUEST_6,
		BEACH_ACT_1_ACTIVE,
		BEACH_MINIBOSS_ACTIVE,
		BEACH_ACT_2_PRE,
		BEACH_ACT_2_ACTIVE,
		BEACH_ACT_3_ACTIVE,
		BEACH_BOSS_PRE,
		BEACH_BOSS_ACTIVE,
		BEACH_BOSS_POST_FIGHT,
		BEACH_BOSS_POST_ORB,
		BEACH_BOSS_POST_BATHYSPHERE,
		BEACH_TO_DESERT,
		DESERT_ACT_1_PRE,
		DESERT_ACT_1_ACTIVE,
		DESERT_EXCAVATION_START,
		DESERT_EXCAVATION_JUMP,
		DESERT_EXCAVATION_ACTIVE,
		DESERT_EXCAVATION_TOWER_1,
		DESERT_EXCAVATION_TOWER_2,
		DESERT_EXCAVATION_TOWER_3,
		DESERT_DARK_WORLD_PRE,
		DESERT_DARK_WORLD_ACTIVE,
		DESERT_DARK_WORLD_TOTEM_COLLECTED,
		DESERT_DARK_WORLD_POST,
		DESERT_ACT_2_ACTIVE,
		DESERT_NECROPOLIS_PRE,
		DESERT_NECROPOLIS_ACTIVE,
		DESERT_NECROPOLIS_ACTION_1,
		DESERT_NECROPOLIS_ACTION_2,
		DESERT_NECROPOLIS_ACTION_3,
		DESERT_NECROPOLIS_ACTION_4,
		DESERT_NECROPOLIS_ACTION_5,
		DESERT_NECROPOLIS_ACTION_6,
		DESERT_NECROPOLIS_PUZZLE_1,
		DESERT_NECROPOLIS_PUZZLE_2,
		DESERT_NECROPOLIS_PUZZLE_3,
		DESERT_NECROPOLIS_PUZZLE_4,
		DESERT_NECROPOLIS_PUZZLE_5,
		DESERT_NECROPOLIS_PUZZLE_6,
		DESERT_NECROPOLIS_PUZZLE_7,
		DESERT_NECROPOLIS_PUZZLE_8,
		DESERT_NECROPOLIS_PUZZLE_9,
		DESERT_NECROPOLIS_PUZZLE_10,
		DESERT_NECROPOLIS_PUZZLE_11,
		DESERT_NECROPOLIS_PUZZLE_12,
		DESERT_BOSS_PRE,
		DESERT_BOSS_ACTIVE,
		DESERT_BOSS_POST,
		DESERT_TRAIN_PULL_OUT,
		GEAR_TRAIN_PULL_IN,
		GEAR_TRAIN_EXITING,
		GEAR_TRAIN_CHECKPOINT,
		GEAR_FACTORY_1_PRE,
		GEAR_FACTORY_1_ACTIVE,
		GEAR_FACTORY_1_POST,
		GEAR_BALL_RHODI_TRAVELLING,
		GEAR_BALL_PRE_TOWN,
		GEAR_BALL_INTRO,
		GEAR_BALL_DANCE,
		GEAR_BALL_ATTACK,
		GEAR_BITNET_PRE,
		GEAR_BITNET_INVESTIGATE,
		GEAR_BITNET_ACTIVE,
		GEAR_BITNET_EXIT,
		GEAR_SUPERCHARGE_PRE,
		GEAR_SUPERCHARGE_ACTIVE,
		GEAR_SUPERCHARGE_POST,
		GEAR_FACTORY_2_PRE,
		GEAR_FACTORY_2_ACTIVE,
		GEAR_FACTORY_2_POST,
		GEAR_FACTORY_BOSS_PRE,
		GEAR_FACTORY_BOSS_REMATCH,
		GEAR_FACTORY_BOSS_POST,
		GEAR_GO5_WAKEUP,
		GEAR_GO5_GO_GET_MAIL,
		GEAR_GO5_MAIL_ACQUIRED,
		GEAR_GO5_FIRST_MEETING,
		GEAR_GO5_AIRSHIP_READY,
		AIRSHIP_FIRST_BOARDED,
		AIRSHIP_IN_FLIGHT,
		AIRSHIP_UNDER_ATTACK,
		AIRSHIP_BOSS_INTRO,
		AIRSHIP_BOSS_ACTIVE,
		AIRSHIP_BOSS_POST,
		ICE_JUST_ARRIVED,
		ICE_TOWN_QUEST_MERCHANT,
		ICE_TOWN_QUEST_CRAFTSMAN,
		ICE_TOWN_QUEST_TRAVELER,
		ICE_TOWN_QUEST_SOLDIER,
		ICE_TOWN_QUEST_SCHOLAR,
		ICE_TOWN_QUEST_SERVANT,
		ICE_TOWN_QUEST_LEADER,
		ICE_TOWN_QUEST_MONK,
		ICE_ACT_1,
		ICE_INTERMISSION,
		ICE_MIDBOSS,
		ICE_ACT_2,
		ICE_BOSS_PRE,
		ICE_BOSS_ACTIVE,
		ICE_BOSS_POST,
		ICE_TEMPLE,
		FOREST_RETURN_WORKSHOP_INTRO,
		FOREST_RETURN_WORKSHOP_AREA_ZERO,
		FOREST_RETURN_WORKSHOP_AREA_ONE,
		FOREST_RETURN_WORKSHOP_AREA_TWO,
		FOREST_RETURN_WORKSHOP_AREA_THREE,
		FOREST_RETURN_WORKSHOP_AREA_FOUR,
		FOREST_RETURN_WORKSHOP_ACTIVE,
		FOREST_RETURN_WORKSHOP_BOSS,
		FOREST_RETURN_WORKSHOP_POST,
		DESERT_RELIQ_INTRO,
		DESERT_RELIQ_SCRIBBLE_INTRO,
		DESERT_RELIQ_SCRIBBLE_1,
		DESERT_RELIQ_SCRIBBLE_2,
		DESERT_RELIQ_SCRIBBLE_3,
		DESERT_RELIQ_SCRIBBLE_DONE
	];

	public static inline function position(flag:MainQuestFlag)
		return order.indexOf(flag);

	var NONE;

	var FOREST_PROLOGUE;
	var FOREST_ACT_0_ACTIVE;
	var FOREST_ACT_1_ACTIVE;
	var FOREST_MINIBOSS_ACTIVE;
	var FOREST_ACT_2_ACTIVE;
	var FOREST_ACT_3_ACTIVE; //
	var FOREST_BOSS_PRE; //
	var FOREST_BOSS_ACTIVE; //
	var FOREST_BOSS_POST; //

	// Bubbledash Beach
	var BEACH_FAMILY_QUEST_1;
	var BEACH_FAMILY_QUEST_2;
	var BEACH_FAMILY_QUEST_3;
	var BEACH_FAMILY_QUEST_4;
	var BEACH_FAMILY_QUEST_5;
	var BEACH_FAMILY_QUEST_6;

	var BEACH_ACT_1_ACTIVE;
	var BEACH_MINIBOSS_ACTIVE;

	/*Miniboss Krakling Krew defeated but hasn't entered Act 2 yet*/
	var BEACH_ACT_2_PRE;

	var BEACH_ACT_2_ACTIVE;

	/**arrived in merlone*/
	var BEACH_ACT_3_ACTIVE;

	/*temple is open*/
	var BEACH_BOSS_PRE;
	var BEACH_BOSS_ACTIVE;
	/*post match*/
	var BEACH_BOSS_POST_FIGHT;
	/*aine's entered the post-temple area*/
	var BEACH_BOSS_POST_ORB;
	var BEACH_BOSS_POST_BATHYSPHERE;

	var BEACH_TO_DESERT;

	/**wayfind compass quest*/
	var DESERT_ACT_1_PRE;

	var DESERT_ACT_1_ACTIVE;
	var DESERT_EXCAVATION_START;
	var DESERT_EXCAVATION_JUMP;
	var DESERT_EXCAVATION_ACTIVE;
	var DESERT_EXCAVATION_TOWER_1;
	var DESERT_EXCAVATION_TOWER_2;
	var DESERT_EXCAVATION_TOWER_3;

	/**Portal has opened*/
	var DESERT_DARK_WORLD_PRE;

	var DESERT_DARK_WORLD_ACTIVE;
	var DESERT_DARK_WORLD_TOTEM_COLLECTED;
	var DESERT_DARK_WORLD_POST;

	/**Dark World is cleared, Excavation portal will now take you to Desert Act 2, TODO: Make a shortcut portal in Desert Town*/
	var DESERT_ACT_2_ACTIVE;

	/**Necropolis*/
	var DESERT_NECROPOLIS_PRE;

	var DESERT_NECROPOLIS_ACTIVE;

	var DESERT_NECROPOLIS_ACTION_1;
	var DESERT_NECROPOLIS_ACTION_2;
	var DESERT_NECROPOLIS_ACTION_3;
	var DESERT_NECROPOLIS_ACTION_4;
	var DESERT_NECROPOLIS_ACTION_5;
	var DESERT_NECROPOLIS_ACTION_6;

	var DESERT_NECROPOLIS_PUZZLE_1; //
	var DESERT_NECROPOLIS_PUZZLE_2; //
	var DESERT_NECROPOLIS_PUZZLE_3; //
	var DESERT_NECROPOLIS_PUZZLE_4; //
	var DESERT_NECROPOLIS_PUZZLE_5; //
	var DESERT_NECROPOLIS_PUZZLE_6; //
	var DESERT_NECROPOLIS_PUZZLE_7; //
	var DESERT_NECROPOLIS_PUZZLE_8; //
	var DESERT_NECROPOLIS_PUZZLE_9; //
	var DESERT_NECROPOLIS_PUZZLE_10; //
	var DESERT_NECROPOLIS_PUZZLE_11; //
	var DESERT_NECROPOLIS_PUZZLE_12;

	/**All puzzles solved **/
	var DESERT_BOSS_PRE;

	/**Boss has been summoned but not killed*/
	var DESERT_BOSS_ACTIVE;

	/**Boss has been defeated but desert train has not been boarded*/
	var DESERT_BOSS_POST;

	var DESERT_TRAIN_PULL_OUT;

	// Gear/Factoria ⚙️
	var GEAR_TRAIN_PULL_IN;
	var GEAR_TRAIN_EXITING;
	var GEAR_TRAIN_CHECKPOINT;

	var GEAR_FACTORY_1_PRE;
	var GEAR_FACTORY_1_ACTIVE;
	var GEAR_FACTORY_1_POST;

	var GEAR_BALL_RHODI_TRAVELLING;
	var GEAR_BALL_PRE_TOWN;

	/**
	 * The ball starts
	 */
	/*From Aine entering the ball with Rhodi to being introduced to Chal*/
	var GEAR_BALL_INTRO;

	/**From Aine asked to join the dance to the dance happening*/
	var GEAR_BALL_DANCE;

	/**From the ball being attacked to escaping through the trapdoor until getting to Chalcedony Manor*/
	var GEAR_BALL_ATTACK;

	/**From first arriving to the manor until Rhodi tells you to investigate the BitNet**/
	var GEAR_BITNET_PRE;

	/**From getting the investigate quest to touching the BitNet bulb**/
	var GEAR_BITNET_INVESTIGATE;

	/**The entire time Aine is in the BitNet**/
	var GEAR_BITNET_ACTIVE;

	/**From waking up after the BitNet, before Rhodi talks**/
	var GEAR_BITNET_EXIT;

	/**From getting asked by Rhodi to meet them in Chalcedony Manor to learning about Supercharging**/
	var GEAR_SUPERCHARGE_PRE;

	var GEAR_SUPERCHARGE_ACTIVE;
	var GEAR_SUPERCHARGE_POST;

	var GEAR_FACTORY_2_PRE;
	var GEAR_FACTORY_2_ACTIVE;
	var GEAR_FACTORY_2_POST;

	var GEAR_FACTORY_BOSS_PRE;
	var GEAR_FACTORY_BOSS_REMATCH;
	var GEAR_FACTORY_BOSS_POST;

	var GEAR_GO5_WAKEUP;
	var GEAR_GO5_GO_GET_MAIL;
	var GEAR_GO5_MAIL_ACQUIRED;
	var GEAR_GO5_FIRST_MEETING;
	var GEAR_GO5_AIRSHIP_READY;

	var AIRSHIP_FIRST_BOARDED;
	var AIRSHIP_IN_FLIGHT;
	var AIRSHIP_UNDER_ATTACK;
	var AIRSHIP_BOSS_INTRO;
	var AIRSHIP_BOSS_ACTIVE;
	var AIRSHIP_BOSS_POST;

	var ICE_JUST_ARRIVED;

	// main town quest chain
	var ICE_TOWN_QUEST_MERCHANT;
	var ICE_TOWN_QUEST_CRAFTSMAN;
	var ICE_TOWN_QUEST_TRAVELER;
	var ICE_TOWN_QUEST_SOLDIER;
	var ICE_TOWN_QUEST_SCHOLAR;
	var ICE_TOWN_QUEST_SERVANT;
	var ICE_TOWN_QUEST_LEADER;
	var ICE_TOWN_QUEST_MONK;

	// full access to eastwest
	var ICE_ACT_1;
	var ICE_INTERMISSION;
	var ICE_MIDBOSS;
	var ICE_ACT_2;
	var ICE_BOSS_PRE;
	var ICE_BOSS_ACTIVE;
	var ICE_BOSS_POST;
	var ICE_TEMPLE;

	// Returning with Cremini
	var FOREST_RETURN_WORKSHOP_INTRO;
	var FOREST_RETURN_WORKSHOP_AREA_ZERO;
	var FOREST_RETURN_WORKSHOP_AREA_ONE;
	var FOREST_RETURN_WORKSHOP_AREA_TWO;
	var FOREST_RETURN_WORKSHOP_AREA_THREE;
	var FOREST_RETURN_WORKSHOP_AREA_FOUR;
	var FOREST_RETURN_WORKSHOP_ACTIVE;
	var FOREST_RETURN_WORKSHOP_BOSS;
	var FOREST_RETURN_WORKSHOP_POST;

	var DESERT_RELIQ_INTRO;
	var DESERT_RELIQ_SCRIBBLE_INTRO;
	var DESERT_RELIQ_SCRIBBLE_1;
	var DESERT_RELIQ_SCRIBBLE_2;
	var DESERT_RELIQ_SCRIBBLE_3;
	var DESERT_RELIQ_SCRIBBLE_DONE;
}

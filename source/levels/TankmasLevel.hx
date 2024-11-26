package levels;

import entities.NPC;
import entities.Player;
import entities.Present;
import flixel.tile.FlxTilemap;
import levels.LDTKLevel;
import levels.LdtkProject.LdtkProject_Level;
import zones.Door;

class TankmasLevel extends LDTKLevel
{
	public var col:FlxTilemap;

	public var bg:FlxSprite;

	var level_name:String;

	public function new(level_name:String, ?tilesheet_graphic:String)
		super(level_name, tilesheet_graphic);

	override function generate(LevelName:String, tilesheet_graphic:String)
	{
		PlayState.self.levels.add(this);

		level_name = LevelName;

		super.generate(level_name, tilesheet_graphic);


		//for (i in 0..._tileObjects.length)
			//setTileProperties(i, FlxObject.NONE);

		var data:LdtkProject_Level = get_level_by_name(level_name);

		setPosition(data.worldX, data.worldY);

		bg = new FlxSpriteExt(x, y, Paths.get(data.json.bgRelPath.split("/").last()));

		PlayState.self.level_backgrounds.add(bg);

		// col = new FlxTilemap();
		// col.loadMapFromArray([for (i in 0...array_len) 1], lvl_width, lvl_height, graphic, tile_size, tile_size);

		//		for (i in [0, 3, 4])
		// col.setTileProperties(i, FlxObject.NONE);
	}

	public function place_entities()
	{
		var level:LdtkProject_Level = get_level_by_name(level_name);

		for (entity in level.l_Entities.all_Player.iterator())
		{
			new Player(x + entity.pixelX, y + entity.pixelY);
		}

		for (entity in level.l_Entities.all_NPC.iterator())
		{
			new NPC(x + entity.pixelX, y + entity.pixelY, entity.f_name);
		}

		for (entity in level.l_Entities.all_Present.iterator())
		{
			new Present(x + entity.pixelX, y + entity.pixelY);
		}
		for (entity in level.l_Entities.all_Door.iterator())
		{
			var spawn:FlxPoint = new FlxPoint(x + entity.f_spawn.cx * 16, y + entity.f_spawn.cy * 16);
			new Door(x + entity.pixelX, y + entity.pixelY, entity.width, entity.height, entity.f_linked_door, spawn, entity.iid);
		}
		/**put entity iterators here**/
		/* 
			example:
				for (entity in data.l_Entities.all_Boy.iterator())
					new Boy(x + entity.pixelX, y + entity.pixelY);
		 */
	}
	public static function make_all_levels_in_world(world_name:String):Array<TankmasLevel>
	{
		var array:Array<TankmasLevel> = [];

		for (world in Main.ldtk_project.worlds)
			if (world.identifier == world_name)
				for (level in world.levels)
					array.push(new TankmasLevel(level.identifier));

		return array;
	}
}

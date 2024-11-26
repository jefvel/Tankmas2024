package levels;

import entities.NPC;
import entities.Player;
import entities.Present;
import flixel.tile.FlxTilemap;
import flixel.util.FlxDirectionFlags;
import levels.LDTKLevel;
import levels.LdtkProject.LdtkProject_Level;

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

		// trace(data.l_Collision.iid);

		// col.loadMapFromArray(data.l_Collision.json.intGridCsv, lvl_width, lvl_height, Paths.get("tile-collision.png"), 32, 32);

		// trace(data.l_Collision.json.intGridCsv);

		// for (i in data.l_Collision.json.intGridCsv)
		// {
		// 	// trace(data.l_Collision.intGrid.get(i));
		// 	if (data.l_Collision.intGrid.get(i) > 0)
		// 	{
		// 		trace(i);
		// 	}
		// 	col.setTileByIndex(i, data.l_Collision.json.intGridCsv[i]);
		// }

		// col.setPosition(x, y);

		PlayState.self.level_collision.add(col = new LDTKLevel(level_name, Paths.get("tile-collision.png")));
		col.setTileProperties(1, FlxDirectionFlags.NONE);


		//		for (i in [0, 3, 4])
		// col.setTileProperties(i, FlxObject.NONE);
	}

	public function place_entities()
	{
		var data:LdtkProject_Level = get_level_by_name(level_name);

		for(entity in data.l_Entities.all_Player.iterator()){
			new Player(x + entity.pixelX, y + entity.pixelY);
		}

		for(entity in data.l_Entities.all_NPC.iterator()){
			new NPC(x + entity.pixelX, y + entity.pixelY, entity.f_name);
		}

		for(entity in data.l_Entities.all_Present.iterator()){
			new Present(x + entity.pixelX, y + entity.pixelY);
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

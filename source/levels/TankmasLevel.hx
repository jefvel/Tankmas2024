package levels;

import entities.NPC;
import entities.Player;
import entities.Present;
import flixel.tile.FlxTilemap;
import levels.LDTKLevel;
import levels.LdtkProject.LdtkProject_Level;

class TankmasLevel extends LDTKLevel
{
	public var col:FlxTilemap;

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

		var data = get_level_by_name(level_name);

		// col = new FlxTilemap();
		// col.loadMapFromArray([for (i in 0...array_len) 1], lvl_width, lvl_height, graphic, tile_size, tile_size);

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
}

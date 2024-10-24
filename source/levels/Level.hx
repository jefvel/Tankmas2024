#if ldtk
package levels;

import flixel.tile.FlxTilemap;

class Level extends LDTKLevel
{
	public var col:FlxTilemap;

	var level_name:String;

	public function new(level_name:String, graphic:String)
		super(level_name, graphic);

	override function generate(LevelName:String, Graphic:String)
	{
		level_name = LevelName;

		super.generate(level_name, Graphic);

		for (i in 0..._tileObjects.length)
			setTileProperties(i, FlxObject.NONE);

		var data = get_level_by_name(level_name);

		// col = new FlxTilemap();
		// col.loadMapFromArray([for (i in 0...array_len) 1], lvl_width, lvl_height, graphic, tile_size, tile_size);

		//		for (i in [0, 3, 4])
		// col.setTileProperties(i, FlxObject.NONE);
	}

	public function place_entities()
	{
		var data = get_level_by_name(level_name);
		/**put entity iterators here**/
		/* 
			example:
				for (entity in data.l_Entities.all_Boy.iterator())
					new Boy(x + entity.pixelX, y + entity.pixelY);
		 */
	}
}
#end

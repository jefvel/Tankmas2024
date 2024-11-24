package ui.sheets;

import data.types.TankmasDefs.CostumeDef;
import flixel.FlxBasic;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import squid.ext.FlxGroupExt;
import states.substates.SheetSubstate;
import ui.sheets.defs.SheetDefs;

class BaseSelectSheet extends FlxGroupExt
{
	var stickerSheetBase:FlxSprite;
	var description:FlxText;
	var title:FlxText;

	var sheet_collection:SheetFileDef;
	var characterSpritesArray:Array<FlxTypedSpriteGroup<FlxSprite>> = [];

	var current_sheet(default, set):Int = 0;
	var current_selection(default, set):Int = 0;

	var graphicSheet:Bool = false;

	/**
	 * This is private, should be only made through things that extend it
	 * @param saved_sheet 
	 */
	function new(saved_sheet:Int)
	{
		trace("sheet exists");
		
		super();

		FlxG.state.openSubState(new SheetSubstate(this));

		final notepad:FlxSprite = new FlxSprite(1500, 150);
		add(notepad);

		description = new FlxText(1500, 250, 430, '');
		description.setFormat(null, 32, FlxColor.BLACK, LEFT);
		add(description);

		stickerSheetBase = new FlxSprite(66, 239);
		add(stickerSheetBase);

		title = new FlxText(70, 70, 1420, '');
		title.setFormat(null, 48, FlxColor.BLACK, LEFT, OUTLINE, FlxColor.WHITE);
		add(title);

		sheet_collection = make_sheet_collection();

		for (sheet in sheet_collection.sheets)
		{
			final characterSprites:FlxTypedSpriteGroup<FlxSprite> = new FlxTypedSpriteGroup<FlxSprite>();
			add(characterSprites);

			for (i in 0...sheet.items.length - 1)
			{
				if (sheet.items[i].name == null)
					continue;
				final character:CostumeDef = data.Costumes.get(sheet.items[i].name);
				if (!data.Costumes.check_for_unlock(character))
					continue;
				var sprite_position:FlxPoint = FlxPoint.weak();

				// initial positions
				sprite_position.x = 190 + (340 * (i % 4));
				sprite_position.y = 420 + (270 * Math.floor(i / 4));

				// add offsets
				sprite_position.x += sheet.items[i].xOffset;
				sprite_position.y += sheet.items[i].yOffset;

				final sprite:FlxSprite = new FlxSprite(sprite_position.x, sprite_position.y).loadGraphic(Paths.get('${character.name}.png'));

				if (sheet.items[i].angle != null)
					sprite.angle = sheet.items[i].angle;
				characterSprites.add(sprite);
			}

			if (characterSprites.members.length != 0)
			{
				characterSpritesArray.push(characterSprites);
				if (sheet.graphic != null)
					Paths.get(sheet.graphic);
			}
			characterSprites.kill();
		}
		update_sheet_graphics();
		update_selection_graphics();
		members.for_all_members((member:FlxBasic) -> cast(member, FlxObject).scrollFactor.set(0, 0));

		trace("sheet exists");

	}

	function make_sheet_collection():SheetFileDef
		throw "not implemented";

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		control();
	}

	function control()
	{
		for (i in 0...characterSpritesArray[current_sheet].length - 1)
		{
			// TODO: make this mobile-friendly
			if (FlxG.mouse.overlaps(characterSpritesArray[current_sheet].members[i]))
				current_selection = i;
		}
		if (Ctrl.cleft[1])
			current_selection = current_selection - 1;
		if (Ctrl.cright[1])
			current_selection = current_selection + 1;
		if (Ctrl.cup[1])
			current_sheet = current_sheet + 1;
		if (Ctrl.cdown[1])
			current_sheet = current_sheet - 1;

		if (Ctrl.menuBack[1] || Ctrl.menuConfirm[1])
			kill();
	}

	function set_current_sheet(val:Int):Int
	{
		if (characterSpritesArray.length > 0)
			characterSpritesArray[current_sheet].kill();

		if (current_sheet < 0)
			current_sheet = characterSpritesArray.length - 1;
		if (current_sheet > characterSpritesArray.length - 1)
			current_sheet = 0;

		current_sheet = val;

		update_sheet_graphics();

		return current_sheet;
	}
	function set_current_selection(val:Int):Int
	{
		characterSpritesArray[current_sheet].members[current_selection].scale.set(1, 1);
		
		current_selection = val;

		if (current_selection < 0)
			current_selection = characterSpritesArray[current_sheet].members.length - 1;
		if (current_selection > characterSpritesArray[current_sheet].members.length - 1)
			current_selection = 0;

		update_selection_graphics();

		return current_selection;
	}

	function update_sheet_graphics()
	{
		graphicSheet = sheet_collection.sheets[current_sheet].graphic != null;
		if (graphicSheet)
			stickerSheetBase.loadGraphic(Paths.get(sheet_collection.sheets[current_sheet].graphic));
		else 
			stickerSheetBase.makeGraphic(1430, 845, FlxColor.BLACK);

		characterSpritesArray[current_sheet].revive();

		update_selection_graphics();
	}

	function update_selection_graphics()
	{
		final costume:CostumeDef = data.Costumes.get(sheet_collection.sheets[current_sheet].items[current_selection].name);
		title.text = costume.display;
		description.text = (costume.desc != null ? costume.desc : '');
		characterSpritesArray[current_sheet].members[current_selection].scale.set(1.1, 1.1);
	}

	override function kill()
	{
		FlxG.state.closeSubState();
		// TODO: save currently-selected costume
		super.kill();
	}
}
package ui;

package states.substates;

import data.types.TankmasDefs.CostumeDef;
import data.types.TankmasDefs.OverallSheetDef;
import data.types.TankmasDefs.SheetGridDef;
import flixel.FlxBasic;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

class BaseSelectSheet extends FlxTypedGroup<FlxSprite>
{
	var stickerSheetBase:FlxSprite;
	var title:FlxText;
	var description:FlxText;
	var sheetCollection:{grid:Array<OverallSheetDef>};
	var characterSpritesArray:Array<FlxTypedSpriteGroup<FlxSprite>> = [];
	var isCharacters:Bool = true;

	static var sheetCharacters:Int = 0;
	static var sheetStickers:Int = 0;

	var currentSheet:Int = 0;
	var curSelection:Int = 0;
	var graphicSheet:Bool = false;

	override public function new(?isCharacters:Bool = true)
	{
		super();
		this.isCharacters = isCharacters;
		currentSheet = isCharacters ? sheetCharacters : sheetStickers;
		trace("substate exists");
	}

	override public function create()
	{
		final notepad:FlxSprite = new FlxSprite(1500, 150);
		add(notepad);

		description = new FlxText(1500, 250, 430, '');
		description.setFormat(null, 16, FlxColor.BLACK, LEFT);
		add(description);

		stickerSheetBase = new FlxSprite(66, 239);
		add(stickerSheetBase);

		title = new FlxText(70, 70, 1420, '');
		title.setFormat(null, 24, FlxColor.BLACK, LEFT, OUTLINE, FlxColor.WHITE);
		add(title);

		sheetCollection = make_sheet_collection();

		for (sheet in sheetCollection.grid)
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
				sprite_position.x += sheet.items[i].xOffset != null ? sheet.items[i].xOffset : 0;
				sprite_position.y += sheet.items[i].yOffset != null ? sheet.items[i].yOffset : 0;

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
		changeSheet(isCharacters ? sheetCharacters : sheetStickers, true);
		changeSelection();
		members.for_all_members((member:FlxBasic) -> cast(member, FlxObject).scrollFactor.set(0, 0));

		trace("sheet exists");

		super.create();
	}

	function make_sheet_collection()
		throw "not implemented";

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		control();

		trace(stickerSheetBase);
	}

	function control()
	{
		if (Ctrl.cleft[0])
			changeSelection(-1);
		if (Ctrl.cright[0])
			changeSelection(1);
		if (Ctrl.cup[0])
			changeSheet(1);
		if (Ctrl.cdown[0])
			changeSheet(-1);

		if (Ctrl.menuBack[0])
			close();
	}

	function changeSheet(?int:Int = 0, ?set:Bool = false)
	{
		characterSpritesArray[currentSheet].kill();
		if (set)
			currentSheet = int
		else
			currentSheet += int;

		if (currentSheet < 0)
			currentSheet = characterSpritesArray.length - 1;
		if (currentSheet > characterSpritesArray.length - 1)
			currentSheet = 0;

		if (sheetCollection.grid[currentSheet].graphic != null && !graphicSheet)
		{
			graphicSheet = true;
			stickerSheetBase.loadGraphic(Paths.get(sheetCollection.grid[currentSheet].graphic));
		}
		else if (sheetCollection.grid[currentSheet].graphic == null && graphicSheet)
		{
			graphicSheet = false;
			stickerSheetBase.makeGraphic(1430, 845, FlxColor.BLACK);
		}
		characterSpritesArray[currentSheet].revive();
		changeSelection();
	}

	function changeSelection(?int:Int = 0, ?set:Bool = false)
	{
		if (set)
			curSelection = int
		else
			curSelection += int;

		if (curSelection < 0)
			curSelection = characterSpritesArray[currentSheet].members.length - 1;
		if (curSelection > characterSpritesArray[currentSheet].members.length - 1)
			curSelection = 0;

		final costume:CostumeDef = data.Costumes.get(sheetCollection.grid[currentSheet].items[curSelection].name);
		title.text = costume.display;
		description.text = (costume.desc != null ? costume.desc : '');
	}

	override function close()
	{
		// TODO: save currently-selected costume
		super.close();
	}
}
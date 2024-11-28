package ui.sheets;

import data.types.TankmasDefs.CostumeDef;
import data.types.TankmasDefs.StickerDef;
import flixel.FlxBasic;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxOutlineEffect;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.tweens.FlxEase;
import squid.ext.FlxGroupExt;
import states.substates.SheetSubstate;
import ui.sheets.defs.SheetDefs;

class BaseSelectSheet extends FlxGroupExt
{
	var type:SheetType;

	var stickerSheetBase:FlxSprite;
	var effectSheet:FlxEffectSprite;
	var description:FlxText;
	var title:FlxText;

	var sheet_collection:SheetFileDef;
	var characterSpritesArray:Array<FlxTypedSpriteGroup<FlxSprite>> = [];
	var characterNames:Array<Array<String>> = [];

	var current_sheet(default, set):Int = 0;
	var current_selection(default, set):Int = 0;

	var graphicSheet:Bool = false;

	/**
	 * This is private, should be only made through things that extend it
	 * @param saved_sheet
	 * @param saved_selection
	 */
	function new(saved_sheet:Int, saved_selection:Int, ?type:SheetType = COSTUME)
	{
		trace("sheet exists");
		
		super();

		this.type = type;

		FlxG.state.openSubState(new SheetSubstate(this));

		final notepad:FlxSprite = new FlxSprite(1500, 150);
		add(notepad);

		description = new FlxText(1500, 250, 430, '');
		description.setFormat(null, 32, FlxColor.BLACK, LEFT);
		add(description);

		add(stickerSheetBase = new FlxSprite(66, 239));

		add(effectSheet = new FlxEffectSprite(stickerSheetBase, [new FlxOutlineEffect(FAST, FlxColor.WHITE, 8)]));

		title = new FlxText(70, 70, 1420, '');
		title.setFormat(null, 48, FlxColor.BLACK, LEFT, OUTLINE, FlxColor.WHITE);
		add(title);

		sheet_collection = make_sheet_collection();

		for (sheet in sheet_collection.sheets)
		{
			final characterSprites:FlxTypedSpriteGroup<FlxSprite> = new FlxTypedSpriteGroup<FlxSprite>();
			add(characterSprites);

			final daNames:Array<String> = [];

			for (i in 0...sheet.items.length - 1)
			{
				if (sheet.items[i].name == null)
					continue;
				final identity:SheetItemDef = sheet.items[i];
				final sprite:FlxSprite = new FlxSprite(0, 0);
				if (type == STICKER)
				{
					final sticker:StickerDef = data.JsonData.get_sticker(identity.name);
					if (!data.JsonData.check_for_unlock_sticker(sticker))
						continue;
					sprite.loadGraphic(Paths.get('${sticker.name}.png'));
				}
				else
				{
					final character:CostumeDef = data.JsonData.get_costume(identity.name);
					if (!data.JsonData.check_for_unlock_costume(character))
						continue;
					sprite.loadGraphic(Paths.get('${character.name}.png'));
				}

				var sprite_position:FlxPoint = FlxPoint.weak();

				// initial positions
				sprite_position.x = 190 + (340 * (i % 4));
				sprite_position.y = 320 + (270 * Math.floor(i / 4));

				// add offsets
				sprite_position.x += identity.xOffset;
				sprite_position.y += identity.yOffset;

				sprite.setPosition(sprite_position.x, sprite_position.y);

				if (identity.angle != null)
					sprite.angle = identity.angle;
				characterSprites.add(sprite);
				daNames.push(identity.name);
			}

			if (characterSprites.members.length != 0)
			{
				characterSpritesArray.push(characterSprites);
				if (sheet.graphic != null)
					Paths.get(sheet.graphic);
				characterNames.push(daNames);
			}
			characterSprites.kill();
		}
		current_sheet = saved_sheet;
		current_selection = saved_selection;

		members.for_all_members((member:FlxBasic) ->
		{
			final daMem:FlxObject = cast(member, FlxObject);
			daMem.y += 700;
			daMem.scrollFactor.set(0, 0);
			FlxTween.tween(daMem, {y: daMem.y - 700}, 1.3, {ease: FlxEase.cubeInOut});
		});

		// trace("sheet exists");

	}

	function make_sheet_collection():SheetFileDef
		throw "not implemented";

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		Ctrl.update();
		control();
	}

	function control()
	{
		for (i in 0...characterSpritesArray[current_sheet].length)
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
	}

	function set_current_sheet(val:Int):Int
	{
		if (characterSpritesArray.length > 0)
			characterSpritesArray[current_sheet].kill();

		if (val < 0)
			current_sheet = characterSpritesArray.length - 1;
		else if (val > characterSpritesArray.length - 1)
			current_sheet = 0;
		else
			current_sheet = val;

		update_sheet_graphics();

		return current_sheet;
	}
	function set_current_selection(val:Int):Int
	{
		// characterSpritesArray[current_sheet].members[current_selection].scale.set(1, 1);

		if (val < 0)
			current_selection = characterSpritesArray[current_sheet].members.length - 1;
		else if (val > characterSpritesArray[current_sheet].members.length - 1)
			current_selection = 0;
		else
			current_selection = val;

		update_selection_graphics();

		return current_selection;
	}

	function update_sheet_graphics()
	{
		graphicSheet = sheet_collection.sheets[current_sheet].graphic != null ? true : false;
		if (graphicSheet)
			stickerSheetBase.loadGraphic(Paths.get(sheet_collection.sheets[current_sheet].graphic));
		else 
			stickerSheetBase.makeGraphic(1430, 845, FlxColor.BLACK);

		characterSpritesArray[current_sheet].revive();

		update_selection_graphics();
	}

	function update_selection_graphics()
	{
		if (type == STICKER)
		{
			final sticker:StickerDef = data.JsonData.get_sticker(characterNames[current_sheet][current_selection]);
			title.text = sticker.properName;
			description.text = (sticker.desc != null ? (sticker.desc + ' ') : '') + 'Created by ${sticker.artist != null ? sticker.artist : "Unknown"}';
		}
		else
		{
			final costume:CostumeDef = data.JsonData.get_costume(characterNames[current_sheet][current_selection]);
			title.text = costume.display;
			description.text = (costume.desc != null ? costume.desc : '');
		}
		// characterSpritesArray[current_sheet].members[current_selection].scale.set(1.1, 1.1);
	}
}

enum abstract SheetType(String) from String to String
{
	final COSTUME;
	final STICKER;
}
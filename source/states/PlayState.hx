package states;

import entities.Interactable;
import entities.NPC;
import entities.Player;
import entities.Present;
import entities.base.BaseUser;
import entities.base.NGSprite;
import fx.StickerFX;
import net.tankmas.OnlineLoop;
import ui.DialogueBox;
import ui.sheets.CostumeSelectSheet;


class PlayState extends BaseState
{
	public static var self:PlayState;

	var bg:FlxSpriteExt;

	public var player:Player;
	public var users:FlxTypedGroup<BaseUser> = new FlxTypedGroup<BaseUser>();
	public var presents:FlxTypedGroup<Present> = new FlxTypedGroup<Present>();
	public var shadows:FlxTypedGroup<FlxSpriteExt> = new FlxTypedGroup<FlxSpriteExt>();
	public var stickers:FlxTypedGroup<StickerFX> = new FlxTypedGroup<StickerFX>();
	public var sticker_fx:FlxTypedGroup<NGSprite> = new FlxTypedGroup<NGSprite>();
	public var dialogues:FlxTypedGroup<DialogueBox> = new FlxTypedGroup<DialogueBox>();
	public var npcs:FlxTypedGroup<NPC> = new FlxTypedGroup<NPC>();

	/**Do not add to state*/
	public var interactables:FlxTypedGroup<Interactable> = new FlxTypedGroup<Interactable>();

	override public function create()
	{
		super.create();
		self = this;

		OnlineLoop.init();
		
		bgColor = FlxColor.GRAY;

		add(bg = new FlxSpriteExt(Paths.get("bg-outside-hotel.png")));

		add(shadows);
		add(npcs);
		add(presents);
		add(users);
		add(stickers);
		add(sticker_fx);
		add(dialogues);

		// add(new DialogueBox(Lists.npcs.get("thomas").get_state_dlg("default")));

		new Player();
		
		player.center_on(bg);

		new Present();

		new NPC(player.x - 150, player.y, "thomas");

		FlxG.camera.target = player;

		FlxG.camera.setScrollBounds(bg.x, bg.width, bg.y, bg.height);
		OnlineLoop.iterate();
	}

	override public function update(elapsed:Float)
	{
		OnlineLoop.iterate();

		super.update(elapsed);

		if (FlxG.keys.anyJustPressed(["R"]))
			FlxG.switchState(new PlayState());
		if (FlxG.keys.anyJustPressed(["C"]))
			new CostumeSelectSheet();
	}

	override function destroy()
	{
		self = null;
		super.destroy();
	}
}

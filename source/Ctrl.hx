package;

import flixel.FlxG;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.FlxGamepadInputID;
import openfl.Assets;

/**
 * Main control loop
 * @author Squidly
 */
class Ctrl
{
	//for switch, mainly
	static var REVERSE_MENU_CONTROLS:Bool = false;

	// controls are handled as an array of bools
	public static var anyB:Array<Bool> = [false];
	// jump/action
	public static var jump:Array<Bool> = [false];
	public static var action:Array<Bool> = [false];
	public static var special:Array<Bool> = [false];
	public static var use:Array<Bool> = [false];

	// just pressed
	public static var jjump:Array<Bool> = [false];
	public static var jaction:Array<Bool> = [false];
	public static var jspecial:Array<Bool> = [false];
	public static var juse:Array<Bool> = [false];
	public static var jroll:Array<Bool> = [false];

	// just released
	public static var rjump:Array<Bool> = [false];
	public static var raction:Array<Bool> = [false];
	public static var rspecial:Array<Bool> = [false];
	public static var ruse:Array<Bool> = [false];

	// directions
	public static var left:Array<Bool> = [false];
	public static var right:Array<Bool> = [false];
	public static var up:Array<Bool> = [false];
	public static var down:Array<Bool> = [false];

	// constant directions (for menus)
	public static var cleft:Array<Bool> = [false];
	public static var cright:Array<Bool> = [false];
	public static var cup:Array<Bool> = [false];
	public static var cdown:Array<Bool> = [false];
	public static var cTicks:Array<Int> = [0, 0, 0, 0];

	// menu
	public static var menuConfirm:Array<Bool> = [false];
	public static var menuBack:Array<Bool> = [false];
	public static var menuLeft:Array<Bool> = [false];
	public static var menuRight:Array<Bool> = [false];

	// miscFront
	public static var pause:Array<Bool> = [false];
	public static var map:Array<Bool> = [false];

	public static var reset:Array<Bool> = [false];

	public static var releaseHolds:Array<Bool> = [false];

	public static var controlModes:Array<String> = ["", "CONTROLLER", "CONTROLLER"];

	public static var p1controller:FlxGamepad;
	public static var p2controller:FlxGamepad;

	public static var model:String = "keyboard";

	public static var scrollRate:Int = 10;

	/*whether allFalse was called, set to false every update()*/
	public static var allCleared:Bool = false;

	static var controlLock:Int = 0;

	public function new()
	{
		// Nothing
	}

	public static var controls:Array<Array<String>> = null;

	public static function set()
	{
		controls = [[""]];
		for (c in 1...5)
		{
			controls.push(Assets.getText("assets/data/config/controls/plyrc" + c + ".txt").split("\n"));
			for (f in 0...controls[c].length)
			{
				controls[c][f] = controls[c][f].trim();
			}
		}
		// ProgressManager("keys_load");
		#if switch
		model = "switch";
		REVERSE_MENU_CONTROLS=true;
		#end
	}

	public static function update()
	{
		if (controls == null)
		{
			set();
		}
		if (controlLock > 0)
		{
			controlLock--;
			return;
		}
		allCleared = false;
		for (c in 1...2)
		{
			up[c] = FlxG.keys.anyPressed([controls[c][0]]);
			down[c] = FlxG.keys.anyPressed([controls[c][1]]);
			left[c] = FlxG.keys.anyPressed([controls[c][2]]);
			right[c] = FlxG.keys.anyPressed([controls[c][3]]);
			jump[c] = FlxG.keys.anyPressed([controls[c][4]]);
			jjump[c] = FlxG.keys.anyJustPressed([controls[c][4]]);
			rjump[c] = FlxG.keys.anyJustReleased([controls[c][4]]);
			action[c] = FlxG.keys.anyPressed([controls[c][5]]);
			jaction[c] = FlxG.keys.anyJustPressed([controls[c][5]]);
			raction[c] = FlxG.keys.anyJustReleased([controls[c][5]]);
			special[c] = FlxG.keys.anyPressed([controls[c][6]]);
			jspecial[c] = FlxG.keys.anyJustPressed([controls[c][6]]);
			rspecial[c] = FlxG.keys.anyJustReleased([controls[c][6]]);
			use[c] = FlxG.keys.anyPressed([controls[c][7]]);
			juse[c] = FlxG.keys.anyJustPressed([controls[c][7]]);
			ruse[c] = FlxG.keys.anyJustReleased([controls[c][7]]);
			pause[c] = FlxG.keys.anyJustPressed(["P", "ENTER"]);
			map[c] = FlxG.keys.anyJustPressed(["SPACE"]);
			reset[c] = FlxG.keys.anyJustPressed(["R"]);
			jroll[c] = FlxG.keys.anyJustPressed(["SHIFT"]);
			menuLeft[c] = jspecial[c];
			menuRight[c] = juse[c];
			menuConfirm[c] = jjump[c] && !REVERSE_MENU_CONTROLS || jspecial[c] && REVERSE_MENU_CONTROLS;
			menuBack[c] = jjump[c] && REVERSE_MENU_CONTROLS || jspecial[c] && !REVERSE_MENU_CONTROLS;

			anyB[c] = up[c] || down[c] || left[c] || right[c] || jump[c] || action[c] || special[c] || use[c] || pause[c] || map[c] || reset[c] || jroll[c];

			if (anyB[c])
				model = "keyboard";
		}
		altcontrol();
		menuControl();
	}

	public static function altcontrol()
	{ // gamepad controls
		// var gp:Array<FlxGamepad> = FlxG.gamepads.getByID

		for (p in 1...3)
		{
			// if (controlModes[p].indexOf("CONTROLLER") == -1) return;
			var gp:FlxGamepad = null;

			if (p == 1)
				gp = p1controller;

			if (p == 2)
				gp = p2controller;

			// debug(PlayState.coop);

			if (p1controller == null && p2controller == null && p == 1)
				gp = FlxG.gamepads.getFirstActiveGamepad();

			if (gp != null && FlxG.gamepads.getByID(gp.id) != null)
			{
				gp.deadZone = .5;
				right[p] = right[p] || gp.analog.value.LEFT_STICK_X > 0 || gp.anyPressed([FlxGamepadInputID.DPAD_RIGHT]);
				up[p] = up[p] || gp.analog.value.LEFT_STICK_Y < 0 || gp.anyPressed([FlxGamepadInputID.DPAD_UP]);
				left[p] = left[p] || gp.analog.value.LEFT_STICK_X < 0 || gp.anyPressed([FlxGamepadInputID.DPAD_LEFT]);
				down[p] = down[p] || gp.analog.value.LEFT_STICK_Y > 0 || gp.anyPressed([FlxGamepadInputID.DPAD_DOWN]);
				pause[p] = pause[p] || gp.anyJustPressed([FlxGamepadInputID.START]);
				map[p] = map[p] || gp.anyJustPressed([FlxGamepadInputID.BACK]);

				jump[p] = jump[p] || gp.anyPressed([FlxGamepadInputID.A]);
				jjump[p] = jjump[p] || gp.anyJustPressed([FlxGamepadInputID.A]);
				rjump[p] = rjump[p] || gp.anyJustReleased([FlxGamepadInputID.A]);

				action[p] = action[p] || gp.anyPressed([FlxGamepadInputID.X]);
				jaction[p] = jaction[p] || gp.anyJustPressed([FlxGamepadInputID.X]);
				raction[p] = raction[p] || gp.anyJustReleased([FlxGamepadInputID.X]);

				special[p] = special[p] || gp.anyPressed([FlxGamepadInputID.B]);
				jspecial[p] = jspecial[p] || gp.anyJustPressed([FlxGamepadInputID.B]);
				rspecial[p] = rspecial[p] || gp.anyJustReleased([FlxGamepadInputID.B]);

				use[p] = use[p] || gp.anyPressed([FlxGamepadInputID.Y]);
				juse[p] = juse[p] || gp.anyJustPressed([FlxGamepadInputID.Y]);
				ruse[p] = ruse[p] || gp.anyJustReleased([FlxGamepadInputID.Y]);

				reset[p] = reset[p] || gp.anyJustReleased([FlxGamepadInputID.BACK]);

				jroll[p] = jroll[p]
					|| gp.anyJustPressed([FlxGamepadInputID.LEFT_SHOULDER])
					|| gp.anyJustPressed([FlxGamepadInputID.RIGHT_SHOULDER]);

				menuConfirm[p] = jjump[p] && !REVERSE_MENU_CONTROLS || jspecial[p] && REVERSE_MENU_CONTROLS;
				menuBack[p] = jjump[p] && REVERSE_MENU_CONTROLS || jaction[p] && !REVERSE_MENU_CONTROLS;

				menuLeft[p] = menuLeft[p] || gp.anyJustPressed([FlxGamepadInputID.LEFT_SHOULDER]);
				menuRight[p] = menuRight[p] || gp.anyJustPressed([FlxGamepadInputID.RIGHT_SHOULDER]);

				anyB[p] = up[p] || down[p] || left[p] || right[p] || jump[p] || action[p] || special[p] || use[p] || pause[p] || map[p] || reset[p] || jroll[p];

				if (gp.anyInput())
				{
					model = "xbox";
					if (gp.model == FlxGamepadModel.PS4)
					{
						model = "psx";
					}
					#if switch
					model = "switch";
					#end
				}
			}

			if (gp != null && FlxG.gamepads.getByID(gp.id) == null)
			{
				if (gp == p1controller)
					for (g in FlxG.gamepads.getActiveGamepads())
						if (g != p2controller)
							p1controller = g;
				if (gp == p2controller)
					for (g in FlxG.gamepads.getActiveGamepads())
						if (g != p1controller)
							p2controller = g;
			}
		}
	}

	static function menuControl()
	{
		for (c in 1...3)
		{ // for all players
			cup[c] = cdown[c] = cleft[c] = cright[c] = false;
			if (up[c] || down[c] || left[c] || right[c])
			{
				if (cTicks[c] % scrollRate == 0)
				{
					cup[c] = up[c];
					cdown[c] = down[c];
					cleft[c] = left[c];
					cright[c] = right[c];
				}
				cTicks[c]++;
				// debug(cTicks[c]);
			}
			else
			{
				cTicks[c] = 0;
			}
		}
	}

	public static function allFalse()
	{
		// debug("All False");
		for (c in 1...3)
		{ // for all players
			setFalse(c);
		}
		allCleared = true;
	}

	public static function setFalse(c:Int)
	{
		/*
			if (PlayState.players != null && PlayState.players.members != null)
			{
				if (c <= PlayState.players.members.length && PlayState.players.members.length > 0)
					PlayState.players.members[c - 1].clearBuffer();
			}
		 */
		up[c] = false;
		down[c] = false;
		left[c] = false;
		right[c] = false;
		jump[c] = false;
		jjump[c] = false;
		rjump[c] = false;
		action[c] = false;
		jaction[c] = false;
		raction[c] = false;
		special[c] = false;
		jspecial[c] = false;
		rspecial[c] = false;
		juse[c] = false;
		use[c] = false;
		ruse[c] = false;
		pause[c] = false;
		map[c] = false;
		reset[c] = false;
		menuConfirm[c] = false;
		menuBack[c] = false;
		cup[c] = false;
		cdown[c] = false;
		cleft[c] = false;
		cright[c] = false;
		cTicks[c] = 0;
	}

	public static function any(l:Array<Bool>):Bool
	{
		for (r in l)
		{
			if (r)
			{
				return true;
			}
		}
		return false;
	}

	public static function setControlLock(setLock:Int)
	{
		controlLock = setLock;
		allFalse();
	}
	/*
		function anyJustPressed(keys:Array<String>):Bool {
			return FlxG.keys.anyJustPressed(keys);
		}

		function anyJustReleased(keys:Array<String>):Bool {
			if (keys == ["-"]) return false;
			return FlxG.keys.anyJustReleased(keys);
		}

		function anyPressed(keys:Array<String>):Bool {
			if (keys == ["-"]) return false;
			return FlxG.keys.anyJustReleased(keys);
		}
	 */
}

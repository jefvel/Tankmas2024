package states;

import flixel.FlxState;
import sound.RadioManager;
#if gif
import squid.recorder.GifRecorder;
#end

class BaseState extends FlxState
{
	var tick:Int = 0;
	var state:String = "";

	static var FIRST_RUN:Bool = true;

	var radio:RadioManager;

	public function new()
	{
		super();
		if (FIRST_RUN)
		{
			#if gif
			GifRecorder.init("game", "../../../export/");
			#end
			FlxG.game.stage.quality = openfl.display.StageQuality.LOW;
			FlxG.stage.window.borderless = true;
			FIRST_RUN = false;
			radio = new RadioManager();
		}
	}

	override function update(elapsed:Float)
	{
		Ctrl.update();
		#if gif
		if (FlxG.keys.anyJustPressed(["G"]))
			squid.recorder.GifRecorder.self.handle_record_button();
		#end
		super.update(elapsed);
	}

	/**
		Increment tick by i * timescale
		@param	add int to increment by
	**/
	public function ttick(add:Int = 1):Float
	{
		tick += add;
		return tick;
	}

	/**
	 * Switch state
	 * @param s new state
	 * @param resetTick resets ticking int
	 */
	public function sstate(new_state:String, reset_tick:Bool = true)
	{
		#if dev_trace
		if (trace_new_state && state != new_state)
			trace('[${type}] New State: ${state} -> ${new_state}');
		#end
		if (reset_tick)
			tick = 0;
		state = new_state;
	}
}

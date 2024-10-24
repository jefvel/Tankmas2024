#if gif
package squid.recorder;

import flixel.FlxBasic;
import gif.GifEncoder;
import openfl.display.BitmapData;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.utils.ByteArray;
import sys.io.FileOutput;

private enum abstract RecordingMode(String) from String to String
{
	var NORMAL;
	var RETROACTIVE;
}

class GifRecorder extends FlxBasic
{
	public static var self:GifRecorder;

	public var use_other_sizes:Bool = false;

	private var base_dir:String = "";
	private var raw_dir(get, default):String;
	private var gifs_dir(get, default):String;

	private var file_prefix:String = "";

	private var state:State = IDLE;

	private static var frames:Array<BitmapData> = [];
	private static var frames_43:Array<BitmapData> = [];
	private static var frames_169:Array<BitmapData> = [];

	public var RECORDING_MODE:RecordingMode = RETROACTIVE;

	var retroactive_frames_max_length:Int;

	private static var tick:Int = 0;

	/**How many frames left to capture*/
	var snaps_remaining:Int = 0;

	/**game_frame_rate/gif_frame_rate = gif capture rate*/
	var snap_interval:Int;

	var game_frame_rate:Int;
	var gif_frame_rate:Int;

	/**Timestamp for file*/
	private static var timestamp:String = "";

	private static var snap_shake:Map<Int, {x:Float, y:Float}> = [];
	private static var gif_time:Int = haxe.macro.Compiler.getDefine("gif_time") == null ? 10 : Std.parseInt(haxe.macro.Compiler.getDefine("gif_time"));

	public static var snapping:Bool;

	public static function init(file_prefix:String = "gif_recorder", base_dir:String, game_frame_rate:Int = 60, gif_frame_rate:Int = 30)
	{
		if (self == null)
		{
			FlxG.plugins.addPlugin(self = new GifRecorder(file_prefix, base_dir, game_frame_rate, gif_frame_rate));
		}
	}

	public function new(file_prefix:String, base_dir:String, game_frame_rate:Int, gif_frame_rate:Int)
	{
		super();

		this.file_prefix = file_prefix;
		this.base_dir = base_dir;
		this.game_frame_rate = game_frame_rate;
		this.gif_frame_rate = gif_frame_rate;

		retroactive_frames_max_length = gif_time * gif_frame_rate;
		snap_interval = (game_frame_rate / gif_frame_rate).floor();

		reset();
	}

	public override function update(elapsed:Float)
	{
		recording_mode_update(elapsed);
		super.update(elapsed);
	}

	function recording_mode_update(elapsed:Float)
	{
		switch (RECORDING_MODE)
		{
			case NORMAL:
				if (state == SNAPPING)
				{
					snap_frame();
					if (snaps_remaining == 0)
						create_gif();
				}
			case RETROACTIVE:
				state = SNAPPING;
				snap_frame();
		}
	}

	/**
	 * Dumps all frames and resets snapping
	 */
	public function reset()
	{
		#if gif_debug
		trace("GifRecorder: Resetting :O");
		#end
		gif_time = 10;
		state = IDLE;
		frames = [];
		frames_43 = [];
		frames_169 = [];
		tick = 0;
		snaps_remaining = 0;
		timestamp = "";
		snap_shake.clear();
	}

	/**
		Starts the recorder taking pics for a gif a gif
	 */
	public function handle_record_button(?frames_to_snap:Int)
	{
		switch (RECORDING_MODE)
		{
			case NORMAL:
				if (state != IDLE)
					return;

				reset();

				snaps_remaining = frames_to_snap == null ? gif_frame_rate * gif_time : frames_to_snap;
				state = SNAPPING;

				#if gif_debug
				trace("START RECORDING GIF FOR " + snaps_remaining + "FRAMES");
				#end
			case RETROACTIVE:
				create_gif();
		}
	}

	function snap_frame()
	{
		tick++;
		if (tick % snap_interval != 1)
			return;

		try
		{
			if (RECORDING_MODE == RETROACTIVE)
				if (frames != null && frames.length >= retroactive_frames_max_length)
				{
					frames.shift();
					frames_43.shift();
					frames_169.shift();
				}

			var mat:Matrix = new Matrix();
			mat.translate(FlxG.camera.shake_amount.x, FlxG.camera.shake_amount.y);

			var image:BitmapData = new BitmapData(Math.floor(FlxG.camera.width), Math.floor(FlxG.camera.height), false, 0);

			#if shader_gif_draw_test
			FlxG.stage.context3D.drawToBitmapData(image);
			#else
			image.draw(FlxG.camera.canvas, mat);
			#end

			frames.push(image);

			snap_shake.set(frames.length - 1, {x: 0, y: 0});
		}
		catch (e)
			trace(e);

		snaps_remaining--;

		//	trace('SNAPS REMAINING ' + snaps_remaining);
	}

	#if gif_lerp_test
	var lerp:FlxPoint = new FlxPoint(0.25, 0.25);

	function rect_track_sprite(rect:Rectangle, sprite:FlxSprite):Rectangle
	{
		var target:FlxPoint = FlxPoint.get();
		var position:FlxPoint = FlxPoint.get(lerp.x, lerp.y);
		var schmoovement:FlxPoint = FlxPoint.get();

		target.x = sprite.x + sprite.width / 2 - rect.width / 2;
		target.y = sprite.y + sprite.height / 2 - rect.height / 2;

		target.x = target.x - FlxG.camera.scroll.x;
		target.y = target.y - FlxG.camera.scroll.y;

		schmoovement.x = (target.x - position.x) * lerp.x;
		schmoovement.y = (target.y - position.y) * lerp.y;

		trace(schmoovement.x, schmoovement.y);

		position.add(schmoovement.x, schmoovement.y);

		trace(position);
		position = bound_in_cam(position, rect, FlxG.camera);
		trace(position);

		rect.x = position.x;
		rect.y = position.y;

		target.put();
		position.put();
		schmoovement.put();

		return rect;
	}
	#else
	function rect_track_sprite(rect:Rectangle, sprite:FlxSprite):Rectangle
	{
		var position:FlxPoint = FlxPoint.get();

		position.x = sprite.x + sprite.width / 2 - rect.width / 2;
		position.y = sprite.y + sprite.height / 2 - rect.height / 2;

		position = bound_in_cam(position, rect, FlxG.camera);
		position.subtractPoint(FlxG.camera.scroll);

		rect.x = position.x;
		rect.y = position.y;

		return rect;
	}
	#end

	function bound_in_cam(point:FlxPoint, rect:Rectangle, camera:FlxCamera):FlxPoint
	{
		var min:FlxPoint = FlxPoint.get(camera.scroll.x, camera.scroll.y);
		var max:FlxPoint = FlxPoint.get(camera.scroll.x + camera.width, camera.scroll.y + camera.height);

		if (point.x + rect.width > max.x)
			point.x = max.x - rect.width;
		if (point.y + rect.height > max.y)
			point.y = max.y - rect.height;

		if (point.x < min.x)
			point.x = min.x;
		if (point.y < min.y)
			point.y = min.y;

		min.put();
		max.put();

		return point;
	}

	function create_gif()
	{
		#if gif_debug
		trace("GifRecorder: Frames Captured, Making Gif :D");
		#end

		#if sys
		var date:Date = Date.now();
		timestamp = '${file_prefix}_${date.getFullYear()}-${date.getMonth() + 1}-${date.getDate()}_${date.getHours()}-${date.getMinutes()}-${date.getSeconds()}';

		sys.FileSystem.createDirectory('$raw_dir');
		sys.FileSystem.createDirectory('$raw_dir/3-4');
		sys.FileSystem.createDirectory('$raw_dir/16-9');
		sys.FileSystem.createDirectory('$gifs_dir');
		sys.FileSystem.createDirectory('$gifs_dir/mp4');
		sys.FileSystem.createDirectory('$gifs_dir/mp4/smol');
		sys.FileSystem.createDirectory('$gifs_dir/mp4/big_dump');

		write_frames_and_compile(frames, '$raw_dir');

		if (use_other_sizes)
		{
			write_frames_and_compile(frames_43, '$raw_dir/3-4', "-3-4");
			write_frames_and_compile(frames_169, '$raw_dir/16-9', "-16-9");

			recurse_rmdir('$raw_dir/3-4');
			recurse_rmdir('$raw_dir/16-9');
		}

		recurse_rmdir('$raw_dir');
		recurse_rmdir('$gifs_dir/mp4/big_dump');

		state = IDLE;
		#end

		#if gif_debug
		trace('GifRecorder: Finished! Saved to ${gifs_dir}');
		#end
	}

	function write_frames_and_compile(frames:Array<BitmapData>, full_dir:String, append:String = "")
	{
		regenerate_timestamp();

		if (frames.length <= 0)
			return;

		for (n in 0...frames.length)
		{
			var b:ByteArray = frames[n].encode(new Rectangle(snap_shake.get(n).x, snap_shake.get(n).y, frames[n].width, frames[n].height),
				new openfl.display.PNGEncoderOptions());
			var fo:FileOutput = sys.io.File.write('$full_dir/${timestamp}_$n.png', true);
			fo.writeBytes(b, 0, b.length);
			fo.close();
		}

		compile_gifs_ffmpeg(full_dir, append, FlxPoint.get(frames[0].width, frames[0].height));

		// compile_gifs_without_ffmpeg(full_dir, append, 33, frames[0].width, frames[0].height);
	}

	function recurse_rmdir(dir_path:String)
		while (sys.FileSystem.exists(dir_path))
			command('rmdir "${dir_path}" /s /q', false);

	function compile_gifs_without_ffmpeg(full_dir:String, ?append:String = "", fps:Int, width:Int, height:Int)
	{
		trace("creating test.gif ...");

		var output = new haxe.io.BytesOutput();
		var encoder:GifEncoder = new GifEncoder(width, height, 14, GifRepeat.Infinite, GifQuality.High);

		encoder.start(output);

		trace(frames.length);

		for (bitmap_data in frames)
		{
			var bytes:ByteArray = bitmap_data.encode(bitmap_data.rect, flash.display.PNGEncoderOptions);
			var frame:GifFrame = {
				delay: -1,
				flippedY: false,
				data: haxe.io.UInt8Array.fromBytes(bytes)
			}

			encoder.add(output, frame);
		}

		encoder.commit(output);

		var bytes = output.getBytes();

		sys.io.File.saveBytes('$gifs_dir/test.gif', bytes);

		trace("done.");
	}

	function compile_gifs_ffmpeg(full_dir:String, ?append:String = "", scale:FlxPoint)
	{
		var file_name:String = '${timestamp}' + append;

		var ms:Int = Math.round(1000 / gif_frame_rate);

		var cmds:Array<String> = [];

		var scale_x:Int = scale.x.floor();
		var scale_y:Int = scale.y.floor();

		// big version
		cmds.push('ffmpeg -framerate ${ms} -i "$full_dir/${timestamp}_%d.png" -c:v libx264 -vf "scale=${scale_x * 4}:${scale_y * 4}:flags=neighbor" -r 60 -crf 0 "${base_dir}gifs/mp4/big_dump/$file_name.mp4"');

		// small version
		cmds.push('ffmpeg -framerate ${ms} -i "$full_dir/${timestamp}_%d.png" -c:v libx264 -crf 0 ${base_dir}/gifs/mp4/smol/$file_name.mp4');

		// small version -> gif
		cmds.push('ffmpeg -i ${base_dir}/gifs/mp4/smol/${file_name}.mp4 -vf "fps=${ms},scale=${scale_x}:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" "${base_dir}/gifs/${file_name}_raw.gif"');

		// convert big version to work with VideoPad because welp
		cmds.push('ffmpeg -i "${base_dir}/gifs/mp4/big_dump/$file_name.mp4" -c:v libx264 -c:a copy "${base_dir}/gifs/mp4/$file_name.mp4"');

		#if lossless_gif
		cmds.push('gifsicle -O2 ${base_dir}/gifs/${file_name}_raw.gif -o ${base_dir}/gifs/${file_name}.gif');
		#else
		// despite the name, this is lossless and the default and much smaller file size
		cmds.push('gifsicle -O3 --lossy=5 ${base_dir}/gifs/${file_name}_raw.gif -o ${base_dir}/gifs/${file_name}.gif');
		#end

		for (cmd in cmds)
			command(cmd);

		// process(cmds);
	}

	function command(cmd:String, verboise:Bool = true)
	{
		#if sys
		if (verboise)
			trace(cmd);
		Sys.command(cmd);
		#end
	}

	function process(cmds:Array<String>, verboise:Bool = true)
	{
		#if sys
		var cmd:String = "";

		for (n in 0...cmds.length)
			cmd = cmd + (n == 0 ? cmds[n] : ' && ${cmds[n]}');

		if (verboise)
			trace(cmd);

		new sys.io.Process(cmd);
		#end
	}

	function get_raw_dir():String
		return '$base_dir/raw';

	function get_gifs_dir():String
		return '$base_dir/gifs';

	function regenerate_timestamp():String
	{
		var date:Date = Date.now();
		timestamp = '${file_prefix}_${date.getFullYear()}-${date.getMonth() + 1}-${date.getDate()}_${date.getHours()}-${date.getMinutes()}-${date.getSeconds()}';
		return timestamp;
	}
}

private enum abstract State(String) from String to String
{
	var IDLE;
	var SNAPPING;
}
#end

package squid.ext;

import haxe.PosInfos;

/*
	None
 */
class SysExt
{
	public static var OUTPUT_PATH:String = "../../../output.txt";

	public static var global_tick:Int = 0;
	public static var state_tick:Int = 0;
	public static var total_trace:String;

	public static function init()
	{
		override_trace();

		#if dump_output
		lime.app.Application.onExit = function()
		{
			trace("END OF TRACE");
			sys.io.File.saveContent(OUTPUT_PATH, total_trace);
			Sys.sleep(.25);
		}
		#end
	}

	public static function update(elapsed:Float)
	{
		global_tick++;
		state_tick++;
	}

	public static function new_state()
	{
		SoundPlayer.init();
		SysExt.state_tick = 0;
	}

	public static function format_output(v:Dynamic, infos:PosInfos):String
	{
		var str = Std.string(v);
		if (infos == null)
			return str;
		var pstr = infos.fileName.split("/").last() + ":" + infos.lineNumber;
		if (infos.customParams != null)
			for (v in infos.customParams)
				str += ", " + Std.string(v);
		var out:String = '[$state_tick] ' + pstr + ":	" + str + "\n";
		#if dump_trace
		total_trace = '$total_trace\n$out';
		var formatted_total_trace:Array<Array<String>> = [];
		var maxLen:Int = 30;

		for (line in total_trace.split("\n"))
		{
			var cols:Array<String> = line.replace("\t\t", "\t").replace("\t\t", "\t").split("\t");
			for (col in cols)
			{
				col = col.ltrim().rtrim();
				// maxLen = col.length > maxLen ? col.length : maxLen;
			}
			formatted_total_trace.push(cols);
		}

		// TY to IanHarrigan
		var sb = new StringBuf();
		for (line in formatted_total_trace)
		{
			// sb.add("| ");
			for (n in 0...line.length)
			{
				sb.add(line[n].rpad(" ", maxLen));
				if (n < line.length - 1)
					sb.add(" | ");
			}
			sb.add("\n");
		}

		sys.io.File.saveContent("../../../output.txt", sb.toString());
		#end
		return out;
	}

	public static function override_trace()
		haxe.Log.trace = function(v:Dynamic, ?infos:PosInfos):Void
		{
			var str = format_output(v, infos);
			#if js
			if (js.Syntax.typeof(untyped console) != "undefined" && (untyped console).log != null)
				(untyped console).log(str);
			#elseif lua
			untyped __define_feature__("use._hx_print", _hx_print(str));
			#elseif sys
			Sys.println(str);
			#else
			throw new haxe.exceptions.NotImplementedException()
			#end
		}
}

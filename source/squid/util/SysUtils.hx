package squid.util;

class SysUtils
{
	public static var DUMP_TRACE:Bool;

	public static function open_file_wait() {}

	public static function catch_stack(exception:haxe.Exception)
	{
		trace(exception);
		var stack:String = "";
		for (line in haxe.CallStack.exceptionStack(true))
			stack = stack + line + "\n";
		trace(stack);
	}
}

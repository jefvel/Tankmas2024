package net.tankmas;

typedef NetUserDef =
{
	name:String,
	?x:Int,
	?y:Int,
	?costume:String,
	?timestamp:Int,
}

typedef NetEventDef =
{
	username:String,
	type:String,
	data:Dynamic,
}

enum abstract NetEventType(String) from String to String
{
	final STICKER = "sticker";
}
package net.tankmas;

typedef NetUserDef =
{
	name:String,
	?x:Int,
	?y:Int,
	?sx:Int, // Scale x, if facing right or left
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
	final DROP_MARSHMALLOW = "drop_marshmallow";
}
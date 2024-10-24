package data.loaders;

typedef AsepriteJSON =
{
	var frames:Map<String, AsepriteFrame>;
	var meta:{app:String, version:String, frameTags:Array<AsepriteFrameTag>};
}

typedef AsepriteFrameTag =
{
	name:String,
	from:Int,
	to:Int,
	color:String,
	data:String
}

typedef AsepriteFrame =
{
	frame:
	{
		x:Int, y:Int, w:Int, h:Int
	},
	rotated:Bool,
	trimmed:Bool,
	spriteSourceSize:
	{
		x:Int, y:Int, w:Int, h:Int
	},
	sourceSize:
	{
		w:Int, h:Int
	},
	duration:Int
}

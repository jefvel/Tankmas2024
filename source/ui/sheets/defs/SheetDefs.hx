package ui.sheets.defs;

typedef SheetFileDef =
{
	var sheets:Array<SheetDef>;
}

typedef SheetDef =
{
	var ?graphic:String;
	var items:Array<SheetItemDef>;
}

typedef SheetItemDef =
{
	var name:String;
	var ?angle:Int;
	var ?xOffset:Float;
	var ?yOffset:Float;
}

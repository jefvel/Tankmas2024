package data.types;

import data.types.TankmasEnums.UnlockCondition;

typedef CostumeDef =
{
	var name:String;
	var ?unlock:UnlockCondition;
	var ?data:Dynamic;
}
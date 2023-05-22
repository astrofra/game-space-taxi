// Camera helper hack

Include("scriptlib/nad.nut");

//EngineSetFixedDeltaFrame(g_engine, 1 / 30.0);

class Beacon
{

	heli_item		= 0;
	item_position	= Vector(0,0,0);
	item_rotation	= Vector(0,0,0);

	//--------------------
	function	OnSetup(item)
	{
		item_position = ItemGetPosition(item);
		item_rotation = ItemGetRotation(item);
		heli_item = SceneFindItem(g_scene, "heli_body");
	}

	
	//------------------------
	function	OnUpdate(item)
	{
		item_position.y = item_position.y * 0.65 + ItemGetPosition(heli_item).y * 0.35;
		ItemSetPosition(item, item_position);
		
/*
		local v = EulerFromDirection(ItemGetWorldPosition(heli_item) - item_position); //ItemGetWorldPosition(item));
		item_rotation = item_rotation.Lerp(0.99, v);
		ItemSetRotation(item,item_rotation);
*/
		ItemComputeMatrix(heli_item);
		ItemSetTarget(item, ItemGetWorldPosition(heli_item));
	}
	
}
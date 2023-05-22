// Helicopter generic class

	Include("scriptlib/nad.nut");
	Include("scriptapp/controller.nut");

//--------------
class Helicopter
{
	throttle 		= 0.0;
	target_throttle	= 0.0;
	pitch			= 0.0;

	item_position	= Vector(0,0,0);
	direction		= 0.0;

	oriented_direction
					= Vector(0,0,0);
	oriented_correction
					= Vector(0,0,0);

	physic_throttle	= Vector(0,0,0);
	
	pad_guide_item	= 0;
	prop_item		= 0;
	heli_item		= 0;
	target_hint_item
					= 0;
	target_hint_matrix = Matrix3();

	tower_item		= 0;
	
	prop_y_angle	= 0.0;

	//----------------------
	function	OnSetup(item)
	{
		item_position = ItemGetWorldPosition(item);
		
		prop_item = SceneFindItem(g_scene, "heli_prop");
		heli_item = SceneFindItem(g_scene, "heli_body");
		tower_item = SceneFindItem(g_scene, "tower_origin");
		target_hint_item = SceneFindItem(g_scene, "target_hint");
		pad_guide_item = SceneFindItem(g_scene, "pad_guide");

		if (ItemIsValid(prop_item))
			print("--Helicopter() Found helicopter propeller");
		else
			print("!!Helicopter() Cannot find helicopter propeller");
		
		if (ItemIsValid(heli_item))
			print("--Helicopter() Found helicopter body");
		else
			print("!!Helicopter() Cannot find helicopter body");

		if (ItemIsValid(tower_item))
			print("--Helicopter() Found tower origin");
		else
			print("!!Helicopter() Cannot find tower origin");

		if (ItemIsValid(target_hint_item))
			print("--Helicopter() Target hint origin");
		else
			print("!!Helicopter() Cannot find Target hint origin");

		if (ItemIsValid(pad_guide_item))
			print("--Helicopter() Found Pad guide");
		else
			print("!!Helicopter() Cannot find Pad guide");

		SetThrottle(0.0);
	}

	//------------------------
	function	SetThrottle(t)
	{
		target_throttle = t;
	}
	
	//------------------------
	function	OnUpdate(item)
	{
		//print("g_pad = " + g_pad);

		local	control_dir = GetControllerVector();

		//	Handle Throttle
		SetThrottle(control_dir.y * 2.0);

		//	Handle Direction
		direction = Lerp(0.75, direction, control_dir.x);

		UpdateHeliEngine(item);

		// Get ideal heli orientation matrix.
		ItemSetTarget(target_hint_item, ItemGetWorldPosition(tower_item));
		target_hint_matrix = ItemGetRotationMatrix(target_hint_item);

		//	Get Heli / Tower direction vector.
		local 	dir_v = ItemGetWorldPosition(tower_item) - ItemGetWorldPosition(item);

		//	Prepare Pitch vector, based on heli's acceleration.
		pitch = Lerp(0.05, pitch, -direction);
		local	pitch_v = Vector(0, pitch , 0);

		//	Apply Heli's rotation to pitch vector.
		pitch_v	= pitch_v.ApplyRotationMatrix(target_hint_matrix);
		dir_v += pitch_v;
		dir_v = dir_v.Normalize();

		local	rot_matrix = RotationMatrixY(Deg(90.0));
		dir_v 	= dir_v.ApplyRotationMatrix(rot_matrix);
		local	rot_v = EulerFromDirection(dir_v);

		ItemSetRotation(item,rot_v);

		// Orient Pad guide
		//if (ItemIsValid(current_pad_item))
		//	ItemSetTarget(pad_guide_item, ItemGetWorldPosition(current_pad_item));

		if (ItemIsSleeping(heli_item))
			ItemWake(heli_item);

	}

	//-------------------------------
	function	UpdateHeliEngine(item)
	{
		throttle = target_throttle * 0.2 + throttle * 0.8;

		// Propeller
		prop_y_angle += (abs(throttle) + abs(direction) + 1.0) * Deg(20.0) * 60.0 * g_dt_frame;
		ItemSetRotation(prop_item, Vector(0, prop_y_angle, 0));
	}

	//----------------------------------------
	function	OnPhysicStep(item, step_taken)
	{
		if	(!step_taken)
			return;		// Engine did not update item physic state, skip.

		// Prepare ascending vector.
		physic_throttle.y = Mtrs(throttle * 0.1);
		
		// Prepare forward vector, transform it according to the heli orientation.
		oriented_direction.x = Mtrs(direction);
		oriented_direction.y = 0.0;
		oriented_direction.z = 0.0;
		oriented_direction = oriented_direction.ApplyRotationMatrix(target_hint_matrix);

		//	Get the distance from the center of the tower,
		//	And prepare a correction vector to bring the heli nearer, in case.
		local	dn = ItemGetWorldPosition(item).Dist(ItemGetWorldPosition(tower_item)) - Mtr(3.0);

		oriented_correction.x = 0.0; // Don't correct on X axis.
		oriented_correction.y = 0.0; // Don't correct on Y axis.
		oriented_correction.z = Mtrs(dn);
		oriented_correction = oriented_correction.ApplyRotationMatrix(target_hint_matrix);


		//	Apply various vectors as impulses.
		local	impulse_result = physic_throttle;
		impulse_result += oriented_direction.MulReal(0.125);
		impulse_result += oriented_correction.MulReal(0.25);
		ItemApplyLinearImpulse(item, impulse_result);
	}
}
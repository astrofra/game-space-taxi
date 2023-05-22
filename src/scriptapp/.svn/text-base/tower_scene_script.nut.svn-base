// Tower script

Include("scriptlib/nad.nut");

current_pad_item	<-	0;

class TowerSceneScript
{

	pad				= [];
	max_pad			= 0;
	current_pad 	= 0;
	pad_timeout		= 0.0;

	player			= 0;

	//-------------------------
	function	FindPads(scene)
	{
		local n		= 0;

		while(1)
		{
			local	pad_item = 0;
			pad_item = SceneFindItem(scene, "pad_" + n);

			if (ItemIsValid(pad_item))
				pad.append(pad_item);
			else
				break;
			n++;
		}

		max_pad = n;
		print ("--Tower() SeekPads(), found " + n + " pad(s)");
	}

	//---------------------------
	function	FindPlayer(scene)
	{
		player = SceneFindItem(scene, "heli_body");
		if (ItemIsValid(player))
		{
			player = ItemGetScriptInstance(player);
			print("--Tower() SeekPlayer(), found ''heli_body''");
		}
		else
			print("--Tower() SeekPlayer(), cannot find ''heli_body''");
	}

	//------------------------
	function	OnSetup(scene)
	{
		FindPads(scene);
		FindPlayer(scene);
		pad_timeout = 0;
	}


	//---------------------
	function	CyclePads()
	{
		if ((g_clock - pad_timeout) > SecToTick(5.0))
		{
			local	new_pad = 0;

			do
			{
				new_pad = Irand(0, max_pad);
			}
			while (new_pad == current_pad);

			current_pad = new_pad;
			current_pad_item = pad[current_pad];
			
			print("--CyclePads() New pad request : pad #" + current_pad);
			pad_timeout = g_clock;
		}
	}
	
	//-------------------------
	function	OnUpdate(scene)
	{
		if (!player.client_loaded)
			CyclePads();
	}
	
}
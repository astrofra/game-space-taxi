// Player base script.

Include("ships/helicopter.nut");

class Player extends Helicopter
{

	client_loaded		= false;

	//----------------------
	function	OnSetup(item)
	{
		
		client_loaded = false;

		//	Call the parent method
		base.OnSetup(item);
	}

	//-----------------------
	function	OnUpdate(item)
	{
		
		//	Call the parent method
		base.OnUpdate(item);
	}
}

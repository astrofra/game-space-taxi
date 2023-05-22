// Level 0.

//-----------------------------
class	Level extends LevelBase
{
	current_room				=	0;	// Set this as the starting room.
	current_spawn_point			=	0;

	room_connection				=
	[
		[	// Room 0
			{	room = 0, spawn = 0	} // Exit 0
		],
		[	// Room 1
			{	room = 0, spawn = 0	} // Exit 0
		]
	]

	//----------------------
	function	IsEndLevel()
	{	return false;	}
}

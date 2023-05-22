// Controller

g_pad		<-	0;
device_list	<-	0;
device_list	= GetDeviceList(DeviceTypeGame);

if (device_list.len())
	g_pad = DeviceNew(device_list[0].id);
	
//------------------------------
function	GetControllerVector()
{
	local	_direction = Vector2(0.0,0.0);
	local	jx,jz;
	
	if	(g_pad != 0)
	{
		DeviceUpdate(g_pad);

		// Get pad throttle
		jz = DevicePoolFunction(g_pad, DeviceAxisZ);
		jz = (jz - 32767.0) / -32767.0;

		// Get pad direction
		jx = DevicePoolFunction(g_pad, DeviceAxisX);
		jx = (jx - 32767.0) / 32767.0; 
	}
	else
	{
		KeyboardUpdate();

		// Get keyboard throttle
		if (KeyboardSeekFunction(DeviceKeyPress, KeyUpArrow))
			jz = 1.0;
		else
		{
			if (KeyboardSeekFunction(DeviceKeyPress, KeyDownArrow))
				jz = -1.0;
			else
				jz = 0.0;
		}

		// Get keyboard direction
		if (KeyboardSeekFunction(DeviceKeyPress, KeyLeftArrow))
			jx = -1.0;
		else
		{
			if (KeyboardSeekFunction(DeviceKeyPress, KeyRightArrow))
				jx = 1.0;
			else
				jx = 0.0;
		}
	}
	
	_direction.x = jx;
	_direction.y = jz;
	
	return (_direction);
}
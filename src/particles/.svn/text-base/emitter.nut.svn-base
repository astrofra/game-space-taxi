class	Emitter
{
	emitter_speed		= Vector(0,0,0);
	prev_emitter_pos	= Vector(0,0,0);
	
	particle_geometry	= 0;
	particle_material	= 0;
	particles		= 0;
/// @sparm
	max_particles		= 150;

	spawn_rate		= 0.0125; //Sec(0.15);
	spawn_rate_jitter	= 0.0125;
	
	spawn_position_jitter	= Mtr(0.2);
	
	velocity_emit		= false;
	velocity_threshold	= Mtrs(0.025);
	
	particle_life_span	= Sec(3.0);
	
	particle_weight		= 0.0;
	
	particle_ejection_speed_y = 0.0;
/// @eparm

	particle_ejection_speed	= Vector(0,0,0);
	
	interlace		= 0;
	timer			= 0.0;
	recycle			= false;
	
	ramped_velocity		= 0.0;
	
	current_particle	= 0;
	
	//-------------------
	function OnSetup(item)
	{
		print("Initializing Emitter : max_particles = " + max_particles);
		
		ItemSetScriptLogicFrequency(item, 30.0);
		
		particles = array(max_particles, 0);
		
		for(local n = 0; n < max_particles; n++)
		{
			SpawnParticle(item, n);
		}
		
		particle_ejection_speed.y = particle_ejection_speed_y;
	}

	//----------------------------
	function SpawnParticle(item, n)
	{
		local pos = Vector(0,0,0);

		particles[n] = { object = 0, item = 0, instance = 0, geometry = 0, particle_material = 0,
		position = pos, direction = Vector(0,0,0), fade = 0.0,
		age = particle_life_span, initial_speed = Vector(0,0,0) };
		
		particles[n].object = SceneAddObject(g_scene, "Particle");
		particles[n].geometry = EngineLoadGeometryBypassCache(g_engine, "particles/particle_face_clipping.nmg");
		ObjectSetGeometry(particles[n].object, particles[n].geometry);
		particles[n].particle_material = GeometryGetMaterial(particles[n].geometry, "particle");
	
		particles[n].item = ObjectGetItem(particles[n].object);
		ItemSetFlags(particles[n].item, ItemFlagBillboard, true);
		//ItemSetup(particles[n].item, false);
		//ItemSetOrientationMethod(particles[n].item, OrientationMatrix);	
		DeactivateParticle(item, n);

	}
	
	//----------------------------
	function ResetParticle(item, i)
	{
		ItemActivate(particles[i].item, true);
		particles[i].position = ItemGetWorldPosition(item);
		particles[i].age = particle_life_span;
		particles[i].initial_speed = emitter_speed + particle_ejection_speed;
		particles[i].fade = 1.0;
		ItemSetScale(particles[i].item, Vector(0.5,0.5,0.5));
		ItemSetCommandList(particles[i].item, "toscale 0,0.5,0.5,0.5;toscale " + particle_life_span + ",0.125,0.125,0.125;");
	}
	
	//---------------------------------
	function DeactivateParticle(item, i)
	{
		particles[i].position = ItemGetWorldPosition(item);
		particles[i].age = 0.0;
		particles[i].fade = -1.0;
		ItemActivate(particles[i].item, false);
	}
	
	//------------------------------
	function UpdateParticle(item, i)
	{
		local	dt = g_dt_frame;
		if (particles[i].age < 0.0)
		{
			ItemActivate(particles[i].item, false);
			return;
		}
			
		particles[i].position = particles[i].position + particles[i].direction.MulReal(dt * 2.0) + particles[i].initial_speed.MulReal(30.0 * dt);
		
		if (particle_weight > 0.0)
			particles[i].position.y -= particle_weight * dt;
		
		particles[i].direction = particles[i].direction.Lerp(0.75, Vector(Rand(0.0,1.0) - 0.5, Rand(0.0,1.0), Rand(0.0,1.0) - 0.5));
	
		local	linear_speed = particles[i].initial_speed.Len();
		linear_speed = Max(0.0, linear_speed - dt * 0.1);		
		particles[i].initial_speed = particles[i].initial_speed.Normalize().MulReal(linear_speed);
		
		//if (particles[i].age < 0.0)
		particles[i].fade -= dt;
		
		particles[i].age -= dt;
					
		MaterialSetSelfIllum(particles[i].particle_material, Vector(particles[i].fade, particles[i].fade, particles[i].fade));
		ItemSetPosition(particles[i].item, particles[i].position);
	}

	//---------------------
	function OnUpdate(item)
	{
		timer += g_dt_frame;
		
		ramped_velocity = (ramped_velocity + ItemGetLinearVelocity(item).Len2()) * 0.5;
		
		// Get Emitter information.
		emitter_speed = (ItemGetWorldPosition(item) - prev_emitter_pos).Reverse();
		
		if (timer > spawn_rate + Rand(0.0 , spawn_rate_jitter))
		{
			timer = 0.0;
			if (	!velocity_emit
				|| (velocity_emit && ramped_velocity > velocity_threshold)
				|| (velocity_emit && ramped_velocity > Mtrs(0.125) && ramped_velocity < Mtrs(0.75))
			)
				ResetParticle(item, current_particle);
				current_particle++;
				if (current_particle >= max_particles)
					current_particle = 0;
		}
		
		for(local n = 0; n < max_particles; n++)
			UpdateParticle(item, n);
			
		prev_emitter_pos = ItemGetWorldPosition(item);
	}

}

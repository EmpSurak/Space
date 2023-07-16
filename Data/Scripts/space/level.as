const float MPI = 3.14159265359;
float time = 0.0f;

void Init(string level_name){
    SetGravity(-0.75);
}

void Update(){
    UpdateAsteroids();
}

bool HasFocus(){
    return false;
}

void SetGravity(float _grav){
    physics.gravity_vector.y = _grav;
}

void UpdateAsteroids(){
	array<int> @object_ids = GetObjectIDs();
	int num_objects = object_ids.length();
	for (int i=0; i<num_objects; ++i) {
		Object @obj = ReadObjectFromID(object_ids[i]);
		ScriptParams @pm = obj.GetScriptParams();
		
        if (pm.HasParam("Floating") && pm.HasParam("Floating Y")) {
			vec3 old = obj.GetTranslation();
		
            obj.SetTranslation(
				vec3(
					old.x,
					pm.GetFloat("Floating Y") + sin(time + i) * time_step * pm.GetFloat("Floating"),
					old.z
				)
			);
        }
		
        if (pm.HasParam("Circling Radius") && pm.HasParam("Circling X") && pm.HasParam("Circling Y")
		&& pm.HasParam("Circling Z") && pm.HasParam("Circling Speed")) {
            obj.SetTranslation(
				vec3(
					pm.GetFloat("Circling Radius") * sin(time/pm.GetFloat("Circling Speed")) + pm.GetFloat("Circling X"),
					pm.GetFloat("Circling Y"),
					pm.GetFloat("Circling Radius") * cos(time/pm.GetFloat("Circling Speed")) + pm.GetFloat("Circling Z")
				)
			);
        }
        
        quaternion rot = obj.GetRotation();
		
        if (pm.HasParam("Rotating")) {
            rot = quaternion(
                vec4(
                    0,
                    0,
                    1,
                    pm.GetFloat("Rotating")*MPI/180.0f
                )
            ) * rot;
        }
		
        if (pm.HasParam("Rotating Y")) {
            rot = quaternion(
                vec4(
                    0,
                    1,
                    0,
                    pm.GetFloat("Rotating Y")*MPI/180.0f
                )
            ) * rot;
				
        }
        
        obj.SetRotation(rot);
	}
	
	time += time_step;
}

void ReceiveMessage(string msg) {
    TokenIterator token_iter;
    token_iter.Init();
    if(!token_iter.FindNextToken(msg)){
        return;
    }
    string token = token_iter.GetToken(msg);
    if(token == "go_to_main_menu"){
        SetGravity(-9.8);
    }else if(token == "improvement_one"){
        MovementObject@ player_mo = ReadCharacter(0); // TODO: get player by name
        player_mo.Execute("jump_info.SetJumpFuel(4.0f);jump_info.SetAirControl(2.0f);");
    }else if(token == "improvement_two"){
        MovementObject@ player_mo = ReadCharacter(0); // TODO: get player by name
        player_mo.Execute("jump_info.SetJumpFuel(6.0f);jump_info.SetAirControl(4.0f);");
    }
}

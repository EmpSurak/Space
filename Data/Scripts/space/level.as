const float MPI = 3.14159265359;
float time = 0.0f;

void Init(string level_name){
    SetGravity(-1);
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
string _warning_distance_key = "Warning Distance";
string _death_distance_key = "Death Distance";
float _warning_distance_default = 200;
float _death_distance_default = 220;
int _sound_loop = 0;


void Init(){
}

void SetParameters(){
    params.AddFloat(_warning_distance_key, _warning_distance_default);
    params.AddFloat(_death_distance_key, _death_distance_default);
}

void Reset(){
}

void Update(){
    Object@ self = ReadObjectFromID(hotspot.GetID());
    
    if(!self.GetEnabled()){
        return;
    }
    
    MovementObject@ player_mo = ReadCharacter(0); // TODO: get player by name
    
    float warning_distance = params.HasParam(_warning_distance_key) ? params.GetFloat(_warning_distance_key) : _warning_distance_default;
    float death_distance = params.HasParam(_death_distance_key) ? params.GetFloat(_death_distance_key) : _death_distance_default;

    if(EditorModeActive()){
        DebugDrawWireSphere(self.GetTranslation(), warning_distance, vec3(0.0f, 1.0f, 0.0f), _delete_on_update);
        DebugDrawWireSphere(self.GetTranslation(), death_distance, vec3(0.0f, 1.0f, 1.0f), _delete_on_update);
        return;
    }
    
    float dist = distance(self.GetTranslation(), player_mo.position);
    if(dist > death_distance){
        player_mo.Execute("SetKnockedOut(_dead);Ragdoll(_RGDL_INJURED);");
    }else if(dist > warning_distance){
        if(_sound_loop == 0){
            _sound_loop = PlaySoundLoop("Data/Sounds/space/warning.wav", 1.0f);
        }
    }else{
        if(_sound_loop>0){
            StopSound(_sound_loop);
            _sound_loop = 0;
        }
    }
}
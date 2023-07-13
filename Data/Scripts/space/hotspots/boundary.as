float _warning_distance = 200;
float _death_distance = 220;
int _sound_loop = 0;

void Init(){
}

void SetParameters(){
}

void Reset(){
}

void Update(){
    Object@ self = ReadObjectFromID(hotspot.GetID());
    MovementObject@ player_mo = ReadCharacter(0); // TODO: get player by name

    float dist = distance(self.GetTranslation(), player_mo.position);
    if(dist > _death_distance){
        player_mo.Execute("SetKnockedOut(_dead);Ragdoll(_RGDL_INJURED);");
    }else if(dist > _warning_distance){
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
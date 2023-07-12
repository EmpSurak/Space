void Init(string level_name){
    SetGravity(-3);
}

void Update(){}

bool HasFocus(){
    return false;
}

void SetGravity(float _grav){
    physics.gravity_vector.y = _grav;
}
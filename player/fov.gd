extends Camera3D

var wanted_fov = 75.0

func _process(delta: float) -> void:
	if Input.is_action_pressed("zoom"):
		wanted_fov = 30.0
	else:
		wanted_fov = 75.0
func _physics_process(delta: float) -> void:
	if fov != wanted_fov:
		fov = lerp(fov, wanted_fov, 0.2)

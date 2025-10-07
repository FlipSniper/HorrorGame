extends RigidBody3D

func disable_body():
	freeze = true
	visible = false
	set_deferred("collision_layer", 0)
	set_deferred("collision_mask", 0)
	for child in get_children():
		if child is CollisionShape3D:
			child.set_deferred("disabled", true)
		if child is MeshInstance3D:
			child.visible = false

func enable_body():
	freeze = false
	visible = true
	set_deferred("collision_layer", 1)
	set_deferred("collision_mask", 1)
	for child in get_children():
		if child is CollisionShape3D:
			child.set_deferred("disabled", false)
		if child is MeshInstance3D:
			child.visible = true

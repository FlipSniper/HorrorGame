extends Node3D

var wheel = false
@export var new_wheel : PackedScene

func toggle_boiler():
	if wheel:
		$AnimationPlayer.play("boiling")

func toggle_wheel():
	print("TRYING")
	var n_wheel = new_wheel.instantiate()
	add_child(n_wheel)
	
	# rotate properly using radians
	n_wheel.global_rotation = Vector3(deg_to_rad(90),deg_to_rad(-90), deg_to_rad(-90))
	
	$AnimationPlayer.play("insert_wheel")
	
	await get_tree().create_timer(1).timeout
	wheel = true

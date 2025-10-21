extends Node3D

var wheel = false

func toggle_boiler():
	if wheel:
		$AnimationPlayer.play("boiling")

func toggle_wheel():
	$AnimationPlayer.play("insert_wheel")
	await get_tree().create_timer(1).timeout
	wheel = true

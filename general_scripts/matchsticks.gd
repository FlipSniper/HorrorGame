extends Node3D

func toggle_matchstick():
	if !$AnimationPlayer.current_animation == "take_stick":
		$AnimationPlayer.play("take_stick")

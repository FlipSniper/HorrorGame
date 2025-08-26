extends Node3D

var power = false

func toggle_power():
	if $AnimationPlayer.current_animation != "on" and !power:
		power  = !power
		if power:
			$AnimationPlayer.play("on")
		#if !power:
			#$AnimationPlayer.play_backwards("on")

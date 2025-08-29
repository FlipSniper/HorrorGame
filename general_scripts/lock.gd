extends Node3D

var opened = false
var locked = true

func toggle_lock():
	if $AnimationPlayer.current_animation != "open":
		opened  = !opened
		if opened:
			$AnimationPlayer.play("open")
		locked = false

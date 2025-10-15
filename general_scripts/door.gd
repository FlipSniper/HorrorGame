extends Node3D

var opened = false
@export var locked : bool = false
@export var play_open : AudioStreamPlayer3D
@export var play_close : AudioStreamPlayer3D

func ai_enable_door(body):
	if body.name == "enemy" and !locked and $AnimationPlayer.current_animation != "open":
		opened = true
		play_open.play()
		$AnimationPlayer.play("open")
func ai_disable_door(body):
	if body.name == "enemy" and !locked and $AnimationPlayer.current_animation != "open":
		opened = false
		play_close.play()
		$AnimationPlayer.play_backwards("open")

func toggle_door():
	if $AnimationPlayer.current_animation != "open" and !locked:
		opened  = !opened
		if !opened:
			play_close.play()
			$AnimationPlayer.play_backwards("open")
		if opened:
			play_open.play()
			$AnimationPlayer.play("open")

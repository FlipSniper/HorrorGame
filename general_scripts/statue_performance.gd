extends Node3D

@onready var anim_player = $AnimationPlayer
var fire = false

func toggle_fire():
	if !fire:
		fire = true
		$AnimationPlayer.play("fire")

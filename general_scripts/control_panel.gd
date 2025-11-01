extends Node3D

var switched_on = false
@onready var anim_player = $switch/AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func toggle_switch():
	if !switched_on:
		anim_player.play("switch_on")
		await get_tree().create_timer(1).timeout
		switched_on = true

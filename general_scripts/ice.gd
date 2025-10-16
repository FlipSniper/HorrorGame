extends Node3D

@export var key_card : PackedScene

func melt_ice():
	$AnimationPlayer.play("melt")
	await get_tree().create_timer(3).timeout
	var card = key_card.instantiate()
	card.global_position = global_position
	card.global_position.y +=.5
	$ice/CollisionShape3D.disabled = true

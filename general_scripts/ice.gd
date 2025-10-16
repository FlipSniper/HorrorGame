extends Node3D

@export var key_card : PackedScene

func melt_ice():
	$AnimationPlayer.play("melt")
	await get_tree().create_timer(3).timeout

	var card = key_card.instantiate()
	card.global_position = position
	get_parent().add_child(card)
	card.scale.x = .2
	card.scale.y = .2
	card.scale.z = .2

	$ice/CollisionShape3D.disabled = true
	$Cube_001.visible = false

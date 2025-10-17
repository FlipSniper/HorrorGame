extends Node3D

@export var key_card : PackedScene
@onready var spawn = get_tree().current_scene.get_node("NavigationRegion3D/House/Kitchen/spawn_card")

func melt_ice():
	$AnimationPlayer.play("melt")
	await get_tree().create_timer(3).timeout

	var card = key_card.instantiate()
	get_parent().add_child(card)
	card.global_position = spawn.global_position
	card.scale.x = .2
	card.scale.y = .2
	card.scale.z = .2

	$ice/CollisionShape3D.disabled = true
	$Cube_001.visible = false

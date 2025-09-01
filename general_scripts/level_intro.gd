extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("level_cutscene")
	await get_tree().create_timer(7.0,false).timeout
	$cutscene_ui/AnimationPlayer.play("fade")
	await get_tree().create_timer(1.1,false).timeout
	get_tree().change_scene_to_file("res://level/level.tscn")

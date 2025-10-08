extends Node

@onready var position_manager = get_tree().current_scene.get_node("random")
@onready var super_shiba = get_tree().current_scene.get_node("super_shiba")
@onready var key = get_tree().current_scene.get_node("key")
@onready var code_paper = get_tree().current_scene.get_node("code_paper")
@export var crystal_pos : Node3D
@export var crystal : PackedScene

func _ready():
	var shiba_pos = position_manager.get_random_position(super_shiba)
	var paper_pos = position_manager.get_random_position(code_paper)
	var key_pos = position_manager.get_random_position(key)

	if shiba_pos:
		super_shiba.global_transform.origin = shiba_pos.global_transform.origin
	if paper_pos:
		code_paper.global_transform.origin = paper_pos.global_transform.origin
	if key_pos:
		key.global_transform.origin = key_pos.global_transform.origin
	if player_level.level1 == 0:
		var crystal_in = crystal.instantiate()
		crystal_in.global_transform.origin = crystal_pos.global_transform.origin

	# Hide visuals for code_paper until confirmed
	code_paper.get_node("MeshInstance3D").visible = false
	code_paper.get_node("code_text").visible = false

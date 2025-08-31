extends Node

@onready var position_manager = get_tree().current_scene.get_node("random")
@onready var code_paper = get_tree().current_scene.get_node("code_paper")

func _ready():
	var paper_pos = position_manager.get_random_position(code_paper)

	if paper_pos:
		code_paper.global_transform.origin = paper_pos.global_transform.origin

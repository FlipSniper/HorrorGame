extends Area3D

@onready var ui = get_tree().current_scene.get_node("player/player_ui")
@onready var code_paper = get_tree().current_scene.get_node("code_paper")
@export var task_text: String
var triggered = false
@export var enable_code: bool

func enter_trigger(body):
	if body.name == "player" and !triggered:
		triggered = true
		ui.set_task(task_text)
		if enable_code:
			code_paper.confirm()

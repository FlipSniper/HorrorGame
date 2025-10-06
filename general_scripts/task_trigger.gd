extends Area3D

@onready var ui = get_tree().current_scene.get_node("player/player_ui")
@onready var tutorial = get_tree().current_scene.get_node("player/player_ui/tutorial_pop_ups")
@onready var player = get_tree().current_scene.get_node("player")
@onready var player_coffee = get_tree().current_scene.get_node("player/head/coffee")
@onready var code_paper = get_tree().current_scene.get_node("code_paper")
@export var task_text: String
var triggered = false
@export var enable_code: bool
@export var safe_arrow : bool
@export var boss_arrow : bool
@export var multi_trigger : bool
@export var exit : bool
@export var task_texture: String
var leave = false

func enter_trigger(body):
	print(player_coffee.visible)
	if body.name == "player" and !triggered or multi_trigger:
		triggered = true
		if !boss_arrow:
			ui.set_task(task_text,task_texture)
		if enable_code:
			get_tree().current_scene.get_node("enemy").process_mode = Node.PROCESS_MODE_INHERIT
			get_tree().current_scene.get_node("enemy").visible = true
			code_paper.confirm()
		if safe_arrow:
			player.change_arrow("safe")
			tutorial.start = "interact"
		if exit and leave:
			player_level.level = "level1"
			get_tree().change_scene_to_file("res://scenery/level_intro.tscn")
		if boss_arrow and player_coffee.visible:
			get_tree().current_scene.play1()
			print("trying")
			multi_trigger= false
			
	

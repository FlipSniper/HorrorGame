extends Control

var level

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = false
	print("loaded")
	$controls.visible = false


func quit_game():
	print("trying")
	get_tree().quit()

func controls():
	print("trying")
	$controls.visible = true

func close_controls():
	print("trying")
	$controls.visible = false

func play():
	print("trying")
	if player_level.level == "tutorial":
		get_tree().change_scene_to_file("res://tutorial/office.tscn")
	if player_level.level == "level1":
		get_tree().change_scene_to_file("res://level/level.tscn")

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


func select_level() -> void:
	$Buttons/play.visible = !$Buttons/play.visible
	$Buttons/settings.visible = !$Buttons/settings.visible
	$Buttons/controls.visible = !$Buttons/controls.visible
	$Buttons/quit.visible = !$Buttons/quit.visible
	$Buttons/level_1.visible = !$Buttons/level_1.visible
	$Buttons/Tutorial.visible = !$Buttons/Tutorial.visible


func _on_tutorial_pressed() -> void:
	get_tree().change_scene_to_file("res://tutorial/office.tscn")


func _on_level_1_pressed() -> void:
	if player_level.level == "tutorial":
		$Buttons/level_1/Label.visible = true
		await get_tree().create_timer(3).timeout
		$Buttons/level_1/Label.visible = false
	if player_level.level == "level1":
		get_tree().change_scene_to_file("res://level/level.tscn")

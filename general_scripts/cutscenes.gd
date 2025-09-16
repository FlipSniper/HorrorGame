extends Node3D

@onready var crowbar = get_tree().current_scene.get_node_or_null("crowbar/Cube")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AudioStreamPlayer4.playing = true
	await get_tree().create_timer(3.0,false).timeout
	$AudioStreamPlayer3.playing = true
func play2():
	$AnimationPlayer.play("cutscene2")
	$AudioStreamPlayer2.playing = true
	
	await get_tree().create_timer(18.0,false).timeout
	$player.tutorial = true
	$player.looking_for = "flashlight"
	$player.controls_enabled = true
	$flashlight2.visible = true
	var player_ui = get_tree().current_scene.get_node("player/player_ui")
	player_ui.set_task(".Take the flashlight from the boss's desk")
	crowbar.visible = true
func play1():
	$player.controls_enabled = false
	$AnimationPlayer.play("cutscene1")
	$AudioStreamPlayer.playing = true
	await get_tree().create_timer(51.0,false).timeout

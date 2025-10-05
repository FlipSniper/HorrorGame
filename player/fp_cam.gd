extends Node3D

var sensitivity = 0.2
var flashlight
@onready var player = get_tree().current_scene.get_node("player")
var main_scene_name

func _ready() -> void:
	# Show a prompt to click before locking mouse
	var current_scene = get_tree().current_scene
	if current_scene != null:
		main_scene_name = current_scene.name  # "Office" or "Level" etc.
	var powerbox = false
	if main_scene_name == "level":
		flashlight = get_tree().current_scene.get_node("flashlight")

func _process(delta: float) -> void:
	if player.controls_enabled:
		if Input.is_action_just_pressed("flashlight") and main_scene_name == "level":
			flashlight.visible = !flashlight.visible

func _input(event: InputEvent) -> void:
	# Keep your original reset logic
	if not player.controls_enabled:
		player.rotation_degrees.x = 0
		player.rotation_degrees.y = 0
		player.rotation_degrees.z = 0
		rotation_degrees.x = 0
		rotation_degrees.y = 0
		rotation_degrees.z = 0

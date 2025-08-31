extends RayCast3D

@onready var crosshair = get_parent().get_parent().get_node("player_ui/CanvasLayer/crosshair")
@onready var player_ui = get_parent().get_parent().get_node("player_ui")
@onready var player = get_tree().current_scene.get_node_or_null("player/head/player_key")
var key
var key_collider
var lock_opened
var main_scene_name = ""
var powerbox
func _ready() -> void:
	var current_scene = get_tree().current_scene
	if current_scene != null:
		main_scene_name = current_scene.name  # "Office" or "Level" etc.
		print("Current main scene: ", main_scene_name)
	var powerbox = false
	if main_scene_name == "level":
		lock_opened = get_tree().current_scene.get_node_or_null("house/lock")
		key_collider = get_tree().current_scene.get_node_or_null("key/CollisionShape3D")
		key = get_tree().current_scene.get_node_or_null("key/Node3D")

func _physics_process(delta: float) -> void:
	if is_colliding():
		var hit = get_collider()
		
		if hit.name == "safe" and (powerbox or main_scene_name == "office"):
			crosshair.visible = true
			if Input.is_action_just_pressed("interact"):
				player_ui.open_safe_password()

		elif hit.name == "light_switch" and powerbox:
			crosshair.visible = true
			if Input.is_action_just_pressed("interact"):
				hit.get_parent().toggle_light()

		elif hit.name == "powerbox" and !powerbox:
			crosshair.visible = true
			if Input.is_action_just_pressed("interact"):
				hit.get_parent().get_parent().toggle_power()
				player_ui.set_task(".Find the safe")
				powerbox = true

		elif hit.name == "door":
			crosshair.visible = true
			if Input.is_action_just_pressed("interact"):
				hit.get_parent().get_parent().get_parent().toggle_door()

		elif hit.name == "drawer":
			crosshair.visible = true
			if Input.is_action_just_pressed("interact"):
				hit.get_parent().get_parent().toggle_door()

		elif hit.name == "door_bell":
			crosshair.visible = true
			if Input.is_action_just_pressed("interact"):
				hit.get_parent().ring_bell()

		elif hit.name == "lock" and lock_opened != null and player.visible == true:
			crosshair.visible = true
			if Input.is_action_just_pressed("interact"):
				hit.get_parent().toggle_lock()

		elif hit.name == "key":
			crosshair.visible = true
			if Input.is_action_just_pressed("interact"):
				key_collider.visible = false
				key.visible = false
				player.visible = true
				player_ui.set_task(".Nice work. Now open the lock")

		elif hit.name == "trapdoor":
			crosshair.visible = true
			if Input.is_action_just_pressed("interact"):
				hit.get_parent().get_parent().get_parent().toggle_lock()
				player_ui.set_task(".Find the powerbox")
		
		else:
			crosshair.visible = false
	else:
		crosshair.visible = false

extends RayCast3D

@onready var crosshair = get_parent().get_parent().get_node("player_ui/CanvasLayer/crosshair")
@onready var player_ui = get_parent().get_parent().get_node("player_ui")
@onready var player = get_tree().current_scene.get_node("player/head/player_key")
@onready var key = get_tree().current_scene.get_node("key/Node3D")
@onready var key_collider = get_tree().current_scene.get_node("key/CollisionShape3D")
@onready var lock_opened = get_tree().current_scene.get_node("house/lock")
var powerbox = false

func _physics_process(delta: float) -> void:
	if is_colliding():
		var hit = get_collider()
		if hit.name == "safe":
			if !crosshair.visible:
				crosshair.visible = true
			if Input.is_action_just_pressed("interact") and powerbox:
				player_ui.open_safe_password()
		elif hit.name == "light_switch":
			if !crosshair.visible:
				crosshair.visible = true
			if Input.is_action_just_pressed("interact") and powerbox:
				hit.get_parent().toggle_light()
		elif hit.name == "powerbox":
			if !crosshair.visible:
				crosshair.visible = true
			if Input.is_action_just_pressed("interact") and !powerbox:
				hit.get_parent().get_parent().toggle_power()
				player_ui.set_task(".Find the safe")
				powerbox = !powerbox
		elif hit.name == "door":
			if !crosshair.visible:
				crosshair.visible = true
			if Input.is_action_just_pressed("interact"):
				hit.get_parent().get_parent().get_parent().toggle_door()
		elif hit.name == "drawer":
			if !crosshair.visible:
				crosshair.visible = true
			if Input.is_action_just_pressed("interact"):
				hit.get_parent().get_parent().toggle_door()
		elif hit.name == "door_bell":
			if !crosshair.visible:
				crosshair.visible = true
			if Input.is_action_just_pressed("interact"):
				hit.get_parent().ring_bell()
		elif hit.name == "lock" and player.visible == true:
			if !crosshair.visible:
				crosshair.visible = true
			if Input.is_action_just_pressed("interact"):
				hit.get_parent().toggle_lock()
		elif hit.name == "key":
			if !crosshair.visible:
				crosshair.visible = true
			if Input.is_action_just_pressed("interact"):
				key_collider.visible = false
				key.visible = false
				player.visible = true
				player_ui.set_task(".Nice work. Now open the lock")
		elif hit.name == "trapdoor" and lock_opened.locked == false:
			if !crosshair.visible:
				crosshair.visible = true
			if Input.is_action_just_pressed("interact"):
				hit.get_parent().get_parent().get_parent().toggle_lock()
				player_ui.set_task(".Find the powerbox")
		else:
			if crosshair.visible:
				crosshair.visible = false
	else:
		if crosshair.visible:
			crosshair.visible = false

extends RayCast3D

@onready var crosshair = get_parent().get_parent().get_node("player_ui/CanvasLayer/crosshair")
@onready var player_ui = get_parent().get_parent().get_node("player_ui")
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
				player_ui.set_task("Crack the safe.... there are absolutely 0 clues for now")
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
		else:
			if crosshair.visible:
				crosshair.visible = false
	else:
		if crosshair.visible:
			crosshair.visible = false

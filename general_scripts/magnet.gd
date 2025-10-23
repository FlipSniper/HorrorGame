extends Node3D

@onready var battery = get_tree().current_scene.get_node_or_null("NavigationRegion3D/House/room3/batteries")
var magnet_on = false
var move_speed = 5.0
var close = false

func _process(delta: float) -> void:
	if magnet_on and battery and close:
		print("here")
		battery.global_position = battery.global_position.move_toward(global_position, move_speed * delta)


func attract(body: Node3D) -> void:
	if body == battery:
		close = true


func repel(body: Node3D) -> void:
	if body == battery:
		close = false

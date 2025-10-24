extends Node3D

@onready var battery = get_tree().current_scene.get_node_or_null("NavigationRegion3D/House/room3/batteries")
var magnet_on = false
var move_speed = 5.0
var close = false

func _process(delta: float) -> void:
	if magnet_on and battery and close and visible:
		print("here")
		battery.global_position = battery.global_position.move_toward(global_position, move_speed * delta)


func attract(body: Node3D) -> void:
	print(body.name)
	if body.name == "battery":
		print("yep")
		close = true


func repel(body: Node3D) -> void:
	if body.name == "battery":
		close = false

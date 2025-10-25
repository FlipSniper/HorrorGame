extends Node3D

@export var rigid_spawns : Array[Node3D]
@export var static_spawns : Array[Node3D]
@onready var rng = RandomNumberGenerator.new()
@export var matchsticks : PackedScene
@export var boiler_wheel : PackedScene
@export var magnets : PackedScene
@export var batteries : PackedScene
var pos

func _ready() -> void:
	var wheel = boiler_wheel.instantiate()
	pos = rng.randi_range(0,static_spawns.size()-1)
	add_child(wheel)
	wheel.global_position = static_spawns[pos].global_position
	print(pos)
	static_spawns.remove_at(pos)
	var matchstick = matchsticks.instantiate()
	pos = rng.randi_range(0,static_spawns.size()-1)
	add_child(matchstick)
	matchstick.global_position = static_spawns[pos].global_position
	matchstick.position.y +=.035
	print(pos)
	static_spawns.remove_at(pos)
	var magnet = magnets.instantiate()
	pos = rng.randi_range(0,static_spawns.size()-1)
	add_child(magnet)
	magnet.global_position = static_spawns[pos].global_position
	magnet.position.y +=.035
	print(pos)
	static_spawns.remove_at(pos)
	var battery = batteries.instantiate()
	pos = rng.randi_range(0,rigid_spawns.size()-1)
	add_child(battery)
	battery.global_position = rigid_spawns[pos].global_position
	battery.global_rotation = Vector3(deg_to_rad(90),0,0)
	print(pos)
	rigid_spawns.remove_at(pos)

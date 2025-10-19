extends Node3D

@export var rigid_spawns : Array[Node3D]
@export var static_spawns : Array[Node3D]
@onready var rng = RandomNumberGenerator.new()
@export var matchsticks : PackedScene
@export var boiler_wheel : PackedScene
@export var magnet : PackedScene
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

extends Node3D

@onready var rng = RandomNumberGenerator.new()

func enter_trigger(body):
	if body.name == "enemy" and body.destination == self:
		await get_tree().create_timer(rng.randf_range(1.0, 10.0), false).timeout
		body.pick_destination(body.destination_value)

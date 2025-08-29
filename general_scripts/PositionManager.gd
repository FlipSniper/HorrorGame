extends Node

@export var available_positions: Array[Node3D]
@onready var key = get_tree().current_scene.get_node("key")

func get_random_position(target_node) -> Node3D:
	if available_positions.is_empty():
		return null
	var rng = RandomNumberGenerator.new()
	var index = rng.randi_range(0, available_positions.size() - 1)
	var pos = available_positions.pop_at(index)
	# Extract number from node name (e.g., "rand_pos25" → 25)
	var num = int(pos.name.trim_prefix("rand_pos"))
	print(num)
	if num > 20 and target_node != key:
		target_node.toggle_body()
	if target_node ==key:
		return available_positions[0] # Call function on super_shiba or code_paper
	return pos

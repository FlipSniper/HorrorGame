extends Node3D

@export var plank_nodes: Array[NodePath]   # Paths to planks
var planks: Array[RigidBody3D] = []
var unlocked = 0
var fallen: Array[bool] = []   # keep track of which ones have fallen

func _ready() -> void:
	for path in plank_nodes:
		var plank = get_node(path)
		if plank and plank is RigidBody3D:
			planks.append(plank)
			fallen.append(false)
			plank.freeze = true
			plank.sleeping = true

func toggle_plank(index: int) -> void:
	if index < 0 or index >= planks.size():
		return  # invalid index

	if fallen[index]:
		return  # already dropped

	var plank = planks[index]
	if plank:
		unlocked +=1
		plank.freeze = false
		plank.sleeping = false
		plank.apply_impulse(Vector3(randf() - 0.5, 1, randf() - 0.5) * 3.0)
		fallen[index] = true

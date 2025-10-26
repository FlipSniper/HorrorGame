extends RigidBody3D

@export var screw_nodes: Array[NodePath]   # Paths to planks
var screws: Array[RigidBody3D] = []
var unlocked = 0
var fallen: Array[bool] = []   # keep track of which ones have fallen

func _ready() -> void:
	for path in screw_nodes:
		var screw = get_node(path)
		if screw and screw is RigidBody3D:
			screws.append(screws)
			fallen.append(false)
			screw.freeze = true
			screw.sleeping = true

func toggle_plank(index: int) -> void:
	if index < 0 or index >= screws.size():
		return  # invalid index

	if fallen[index]:
		return  # already dropped

	var screw = screws[index]
	if screw:
		unlocked +=1
		screw.freeze = false
		screw.sleeping = false
		screw.apply_impulse(Vector3(randf() - 0.5, 1, randf() - 0.5) * 3.0)
		fallen[index] = true

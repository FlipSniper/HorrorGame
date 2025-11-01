extends Node3D

@export var screw_nodes: Array[NodePath]   # Paths to planks
var screws: Array[RigidBody3D] = []
var unlocked = 0
var fallen: Array[bool] = []   # keep track of which ones have fallen

func _ready() -> void:
	for path in screw_nodes:
		print("yo 1st")
		var screw = get_node(path)
		if screw and screw is RigidBody3D:
			print("yo 2nd")
			screws.append(screw)
			fallen.append(false)
			screw.freeze = true
			screw.sleeping = true
			print(screws)

func toggle_screw(index: int) -> void:
	print("hehe")
	if index < 0 or index >= screws.size():
		print(index >= screws.size())
		print(screws.size())
		return  # invalid index

	if fallen[index]:
		print("sthu")
		return  # already dropped

	var screw = screws[index]
	print("screw")
	if screw:
		print("yoooo")
		var anim = screw.get_node("AnimationPlayer")
		anim.play("unscrew")
		await get_tree().create_timer(1.5).timeout
		unlocked +=1
		screw.freeze = false
		screw.sleeping = false
		screw.apply_impulse(Vector3(randf() - 0.5, 1, randf() - 0.5) * 3.0)
		fallen[index] = true

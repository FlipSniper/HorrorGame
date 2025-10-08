extends Node3D

@export var gate_door : Node3D

func toggle_crystal():
	gate_door.locked = false

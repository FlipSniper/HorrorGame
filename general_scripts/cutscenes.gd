extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("cutscene2")
	$AudioStreamPlayer.playing = true
func play2():
	await get_tree().create_timer(2.0).timeout
	$AudioStreamPlayer2.playing = true

extends Control

func _ready() -> void:
	$AnimationPlayer.play("death")
	await get_tree().create_timer(4.9,true).timeout
	get_tree().quit()

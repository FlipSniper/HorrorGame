extends Node3D

var level = "ground"

func elevator(button: String):
	if level == "ground" and button == "floor":
		level = ""
		$AnimationPlayer.play_backwards("open")
		await get_tree().create_timer(2).timeout
		for i in range(90):
			global_position.y += .1
			await get_tree().create_timer(.11).timeout
		$AnimationPlayer.play("open")
		await get_tree().create_timer(2).timeout
		level = "floor"
	elif level == "floor" and button == "ground":
		level = ""
		$AnimationPlayer.play_backwards("open")
		await get_tree().create_timer(2).timeout
		for i in range(90):
			global_position.y -= .1
			await get_tree().create_timer(.1).timeout
		$AnimationPlayer.play("open")
		await get_tree().create_timer(2).timeout
		level = "ground"
	elif level == "ground" and button == "back":
		level = ""
		$AnimationPlayer.play_backwards("open")
		await get_tree().create_timer(2).timeout
		for i in range(90):
			global_position.y += .1
			await get_tree().create_timer(.11).timeout
		$AnimationPlayer.play("open")
		await get_tree().create_timer(2).timeout
		level = "floor"

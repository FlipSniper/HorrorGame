extends Node3D

var level = "ground"

func elevator(button: String):
	print(level,button)
	if level == "ground" and button == "floor":
		level = ""
		$AnimationPlayer.play_backwards("open")
		await get_tree().create_timer(2).timeout
		for i in range(90):
			global_position.y += .1
			await get_tree().create_timer(.1).timeout
		$AnimationPlayer.play("open")
		await get_tree().create_timer(6).timeout
		$AnimationPlayer.play_backwards("open")
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
		await get_tree().create_timer(6).timeout
		$AnimationPlayer.play_backwards("open")
		await get_tree().create_timer(2).timeout
		level = "ground"
	elif level == "ground" and button == "f_back":
		level = ""
		await get_tree().create_timer(2).timeout
		for i in range(90):
			global_position.y += .1
			await get_tree().create_timer(.1).timeout
		$AnimationPlayer.play("open")
		await get_tree().create_timer(2).timeout
		level = "floor"
	elif level == "floor" and button == "g_back":
		level = ""
		await get_tree().create_timer(2).timeout
		for i in range(90):
			global_position.y -= .1
			await get_tree().create_timer(.1).timeout
		$AnimationPlayer.play("open")
		await get_tree().create_timer(2).timeout
		level = "ground"
	elif level == "floor" and button == "f_back":
		return true
	elif level == "ground" and button == "g_back":
		return true
	elif level == "floor" and button == "floor":
		level = ""
		$AnimationPlayer.play("open")
		await get_tree().create_timer(6).timeout
		level = "floor"
	elif level == "ground" and button == "ground":
		level = ""
		$AnimationPlayer.play("open")
		await get_tree().create_timer(6).timeout
		level = "ground"

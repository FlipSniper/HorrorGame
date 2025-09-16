extends OmniLight3D
var num = randi_range(1, 10)

func _process(delta: float) -> void:
	var num = randi_range(1, 200)
	if num>195:
		visible = !visible
		

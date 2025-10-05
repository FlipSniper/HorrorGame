extends CharacterBody2D

var scrolling = false
var of = Vector2(0,0)
@export var moving : Node2D

func _physics_process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()-of
	if scrolling:
		moving.position.y = mouse_pos.y
		
	move_and_slide()
	if Input.is_action_just_pressed("click"):
		scrolling = true
		of = get_global_mouse_position() - moving.position
	
	else:
		scrolling = false

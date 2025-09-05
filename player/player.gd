extends CharacterBody3D

var speed = 3.5
const JUMP_VELOCITY = 4.5
var crouching = false
var look_sensitivity = 0.005 # Smaller for mouse precision
var camera_pitch := 0.0

@onready var head = $head # Camera or Node3D for vertical rotation
@onready var ray = $head/pointer/Arrow
@export var code_paper: RigidBody3D
@export var safe: Node3D
@export var boss: Node3D
@export var exit: Node3D
@export var flash: Node3D
var main_scene_name
var looking_for
var controls_enabled = true
var tutorial

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # Lock cursor
	$head/player_key.visible = false
	$head/coffee.visible = false
	$head/arm.visible = false
	var current_scene = get_tree().current_scene
	if current_scene != null:
		main_scene_name = current_scene.name  # "Office" or "Level" etc.
	if main_scene_name == "office":
		$head/pointer.visible = true
		looking_for = "code_paper"
		tutorial = true
	if main_scene_name == "level":
		tutorial = false
		$head/pointer.visible = false
		

func _input(event):
	if controls_enabled:
		if event is InputEventMouseMotion:
			rotation.y -= event.relative.x * look_sensitivity
			camera_pitch = clamp(camera_pitch - event.relative.y * look_sensitivity, -1.2, 1.2)
			head.rotation.x = camera_pitch

func _process(delta: float) -> void:
	if controls_enabled:
		if Input.is_action_just_pressed("crouch"):
			crouching = !crouching
		speed = 1.25 if crouching else 3.5

		handle_arrow_look(delta)
		var pointer = $head/pointer

		# Always point to code_paper, unless it's directly in sight
		var obj = ray.get_collider()
		if looking_for == "code_paper":
			if not obj or obj.name != "code_paper":
				var target_pos = code_paper.global_transform.origin
				#target_pos.y = pointer.global_transform.origin.y  # lock vertical rotation
				pointer.look_at(target_pos, Vector3.UP)
		elif looking_for == "safe":
			if not obj or obj.name != "safe":
				var target_pos = safe.global_transform.origin
				#target_pos.y = pointer.global_transform.origin.y  # lock vertical rotation
				pointer.look_at(target_pos, Vector3.UP)
		elif looking_for == "flashlight":
			if not obj or obj.name != "flashlight2":
				var target_pos = flash.global_transform.origin
				#target_pos.y = pointer.global_transform.origin.y  # lock vertical rotation
				pointer.look_at(target_pos, Vector3.UP)
		elif looking_for == "exit":
			if not obj or obj.name != "exit":
				var target_pos = exit.global_transform.origin
				#target_pos.y = pointer.global_transform.origin.y  # lock vertical rotation
				pointer.look_at(target_pos, Vector3.UP)

		elif looking_for == "boss":
			if not obj or obj.name != "boss":
				var target_pos = boss.global_transform.origin
				#target_pos.y = pointer.global_transform.origin.y  # lock vertical rotation
				pointer.look_at(target_pos, Vector3.UP)
	if !controls_enabled:
			$head/pointer.visible = false
	elif tutorial:
		$head/pointer.visible = true






		
func change_arrow(find: String):
	looking_for = find

func handle_arrow_look(delta: float) -> void:
	var look_x = 0.0
	var look_y = 0.0

	if Input.is_action_pressed("look_left"):
		look_x -= .5
	if Input.is_action_pressed("look_right"):
		look_x += .5
	if Input.is_action_pressed("look_up"):
		look_y += .5
	if Input.is_action_pressed("look_down"):
		look_y -= .5

	rotation.y -= look_x * look_sensitivity * 10.0 # Boost for arrows
	camera_pitch = clamp(camera_pitch + look_y * look_sensitivity * 10.0, -1.2, 1.2)
	head.rotation.x = camera_pitch

func _physics_process(delta: float) -> void:
	if controls_enabled:
		if crouching and $CollisionShape3D.shape.height > 0.75:
			$CollisionShape3D.shape.height = lerp($CollisionShape3D.shape.height, 0.75, 0.2)
		elif !crouching and $CollisionShape3D.shape.height < 2.0:
			$CollisionShape3D.shape.height = lerp($CollisionShape3D.shape.height, 2.0, 0.2)

		if not is_on_floor():
			velocity += get_gravity() * delta

		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		var input_dir := Input.get_vector("left", "right", "forward", "backwards")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			velocity.z = move_toward(velocity.z, 0, speed)

		move_and_slide()

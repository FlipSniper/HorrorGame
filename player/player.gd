extends CharacterBody3D

var speed = 3.5
const JUMP_VELOCITY = 4.5
var crouching = false
var look_sensitivity = 0.005
var camera_pitch := 0.0

@onready var footstep_player = $FootstepPlayer
@export var footstep_sound = load("res://sound/footstep1.mp3") # single 0.448s step
var step_timer = 0.0

@onready var head = $head
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
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$head/player_key.visible = false
	$head/coffee.visible = false
	$head/arm.visible = false

	var current_scene = get_tree().current_scene
	if current_scene != null:
		main_scene_name = current_scene.name

	if main_scene_name == "office":
		$head/pointer.visible = true
		looking_for = "code_paper"
		tutorial = true
	if main_scene_name == "level":
		tutorial = false
		$head/pointer.visible = false

func _input(event):
	if controls_enabled and event is InputEventMouseMotion:
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

		var obj = ray.get_collider()
		match looking_for:
			"code_paper":
				if not obj or obj.name != "code_paper":
					pointer.look_at(code_paper.global_transform.origin, Vector3.UP)
			"safe":
				if not obj or obj.name != "safe":
					pointer.look_at(safe.global_transform.origin, Vector3.UP)
			"flashlight":
				if not obj or obj.name != "flashlight2":
					pointer.look_at(flash.global_transform.origin, Vector3.UP)
			"exit":
				if not obj or obj.name != "exit":
					pointer.look_at(exit.global_transform.origin, Vector3.UP)
			"boss":
				if not obj or obj.name != "boss":
					pointer.look_at(boss.global_transform.origin, Vector3.UP)

	if not controls_enabled:
		$head/pointer.visible = false
	elif tutorial:
		$head/pointer.visible = true

func change_arrow(find: String):
	looking_for = find

func handle_arrow_look(delta: float) -> void:
	var look_x = 0.0
	var look_y = 0.0
	if Input.is_action_pressed("look_left"): look_x -= 0.5
	if Input.is_action_pressed("look_right"): look_x += 0.5
	if Input.is_action_pressed("look_up"): look_y += 0.5
	if Input.is_action_pressed("look_down"): look_y -= 0.5

	rotation.y -= look_x * look_sensitivity * 10.0
	camera_pitch = clamp(camera_pitch + look_y * look_sensitivity * 10.0, -1.2, 1.2)
	head.rotation.x = camera_pitch

func _physics_process(delta: float) -> void:
	if not controls_enabled:
		return

	# Smooth crouch collision height
	if crouching:
		if $CollisionShape3D.shape.height > 0.75:
			$CollisionShape3D.shape.height = lerp($CollisionShape3D.shape.height, 0.75, 0.2)
	else:
		if $CollisionShape3D.shape.height < 2.0:
			$CollisionShape3D.shape.height = lerp($CollisionShape3D.shape.height, 2.0, 0.2)

	# Gravity + jumping
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get input
	var input_dir = Input.get_vector("left", "right", "forward", "backwards")
	var direction = Vector3(input_dir.x, 0, input_dir.y)

	if direction.length() > 0.01:
		# Rotate movement relative to camera/player yaw
		direction = direction.rotated(Vector3.UP, rotation.y).normalized()
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed

		# Footsteps
		if is_on_floor():
			step_timer -= delta
			if step_timer <= 0.0:
				play_footstep()
				if crouching:
					step_timer = 0.6
				else:
					step_timer = 0.4
	else:
		# Smooth stop when no input
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		step_timer = 0.0  # reset timer when stopped

	move_and_slide()

func play_footstep() -> void:
	if not footstep_player.playing:
		footstep_player.stream = footstep_sound
		footstep_player.play()

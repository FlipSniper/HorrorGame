extends CharacterBody3D

# --- MOVEMENT / CAMERA ---
var speed = 3.5
const JUMP_VELOCITY = 4.5
var crouching = false
var look_sensitivity = 0.005
var camera_pitch := 0.0

@onready var head = $head
@onready var ray = $head/pointer/Arrow
@onready var footstep_player = $FootstepPlayer
@export var footstep_sound: Array[AudioStream]
var step_timer = 0.0

# --- ITEMS / OBJECTIVES ---
@export var code_paper: RigidBody3D
@export var safe: Node3D
@export var boss: Node3D
@export var exit: Node3D
@export var flash: Node3D

var main_scene_name
var looking_for
var controls_enabled = true
var tutorial

# --- PLAYER PICKUPS ---
@onready var player_key = $head/player_key
@onready var player_matchstick = $head/matchstick
@onready var player_coffee = $head/coffee
@onready var player_crowbar = $head/crowbar
@onready var player_flashlight = $head/flashlight
@onready var player_keycard = $head/keycard
@onready var player_arm = $head/arm
@onready var equipped_item: String = ""
@onready var rng = RandomNumberGenerator.new()

@export var key_scene: PackedScene
@export var coffee_scene: PackedScene
@export var crowbar_scene: PackedScene
@export var flashlight_scene: PackedScene
@export var keycard_scene: PackedScene
@export var matchstick_scene: PackedScene

# --- OPTIONAL DROP SCALES ---
var drop_scales = {
	"KEY": Vector3(1,1,1),
	"COFFEE": Vector3(0.5,0.5,0.5),
	"CROWBAR": Vector3(0.2,0.2,0.2),
	"KEY_CARD": Vector3(0.2,0.2,0.2),
	"MATCHSTICK_RIGID": Vector3(0.1,0.1,0.1)
}

func footsteps():
	if !$feet.playing:
		$feet.stream = footstep_sound[rng.randi_range(0, footstep_sound.size() - 1)]
		$feet.play()

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	player_key.visible = false
	player_coffee.visible = false
	player_crowbar.visible = false

	var current_scene = get_tree().current_scene
	if current_scene != null:
		main_scene_name = current_scene.name

	if main_scene_name == "office":
		$head/pointer.visible = true
		looking_for = "code_paper"
		tutorial = true
	elif main_scene_name in ["level", "level2"]:
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

		if Input.is_action_just_pressed("drop"):
			drop_item()

		handle_arrow_look(delta)
		update_pointer()

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

func update_pointer() -> void:
	if tutorial:
		var pointer = $head/pointer
		var obj = ray.get_collider()
		match looking_for:
			"code_paper":
				if not obj or obj.name != "code_paper": pointer.look_at(code_paper.global_transform.origin, Vector3.UP)
			"safe":
				if not obj or obj.name != "safe": pointer.look_at(safe.global_transform.origin, Vector3.UP)
			"flashlight":
				if not obj or obj.name != "flashlight2": pointer.look_at(flash.global_transform.origin, Vector3.UP)
			"exit":
				if not obj or obj.name != "exit": pointer.look_at(exit.global_transform.origin, Vector3.UP)
			"boss":
				if not obj or obj.name != "boss": pointer.look_at(boss.global_transform.origin, Vector3.UP)

		if not controls_enabled:
			pointer.visible = false
		elif tutorial:
			pointer.visible = true

func change_arrow(find: String):
	looking_for = find

# Helper: checks if player is actually moving
func is_moving() -> bool:
	return abs(velocity.x) > 0.1 or abs(velocity.z) > 0.1

func _physics_process(delta: float) -> void:
	if not controls_enabled:
		return

	# Smooth crouch
	if crouching:
		$CollisionShape3D.shape.height = lerp($CollisionShape3D.shape.height, 0.75, 0.2)
	else:
		$CollisionShape3D.shape.height = lerp($CollisionShape3D.shape.height, 2.0, 0.2)

	# Gravity + Jump
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Movement input
	var input_dir = Input.get_vector("left", "right", "forward", "backwards")
	var direction = Vector3(input_dir.x, 0, input_dir.y)

	if direction.length() > 0.01:
		# Player is actively moving
		direction = direction.rotated(Vector3.UP, rotation.y).normalized()
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed

		if is_on_floor():
			step_timer -= delta
			if step_timer <= 0.0:
				footsteps()
				step_timer = 0.6 if crouching else 0.4
	else:
		# No input = instantly stop footsteps + zero out velocity drift
		velocity.x = move_toward(velocity.x, 0, speed * 2)
		velocity.z = move_toward(velocity.z, 0, speed * 2)
		step_timer = 0.0
		if $feet.playing:
			$feet.stop()

	move_and_slide()


func play_footstep() -> void:
	pass

func equip_item(item_name: String) -> void:
	if item_name == "" or not Inventory:
		return

	# Unequip previous item visuals
	if equipped_item != "":
		match equipped_item:
			"KEY": player_key.visible = false
			"COFFEE": player_coffee.visible = false
			"CROWBAR": player_crowbar.visible = false
			"FLASHLIGHT": player_flashlight.visible = false
			"KEY_CARD": player_keycard.visible = false
			"MATCHSTICK_RIGID": player_matchstick.visible = false

	# Equip new item
	equipped_item = item_name
	match item_name:
		"KEY": player_key.visible = true
		"COFFEE": player_coffee.visible = true
		"CROWBAR": player_crowbar.visible = true
		"FLASHLIGHT": player_flashlight.visible = true
		"KEY_CARD": player_keycard.visible = true
		"MATCHSTICK_RIGID": player_matchstick.visible = true
		_: pass

# --- DROP ITEM ---
func drop_item() -> void:
	if equipped_item == "" or not Inventory:
		return

	var scene: PackedScene = null
	match equipped_item:
		"KEY": scene = key_scene
		"COFFEE": scene = coffee_scene
		"CROWBAR": scene = crowbar_scene
		"FLASHLIGHT": scene = flashlight_scene
		"KEY_CARD": scene = keycard_scene
		"MATCHSTICK_RIGID": scene = matchstick_scene
		_: scene = null

	if scene:
		var dropped = scene.instantiate()
		dropped.scale = drop_scales.get(equipped_item, Vector3.ONE)

		var spawn_pos = head.global_transform.origin + -head.global_transform.basis.z * 1.2 + Vector3.UP * 0.5

		if dropped is RigidBody3D:
			dropped.global_transform.origin = spawn_pos
			dropped.apply_central_impulse(-head.global_transform.basis.z * 3)
		else:
			var space_state = get_world_3d().direct_space_state
			var from = spawn_pos + Vector3.UP * 5.0
			var to = spawn_pos - Vector3.UP * 10.0
			var params = PhysicsRayQueryParameters3D.new()
			params.from = from
			params.to = to
			params.collide_with_bodies = true
			var result = space_state.intersect_ray(params)
			if result:
				spawn_pos.y = result.position.y + 0.1
			else:
				spawn_pos.y = 0.0
			dropped.global_transform.origin = spawn_pos

		get_tree().current_scene.add_child(dropped)
		dropped.name = equipped_item.to_lower()

	var slot_index = Inventory.slots.find(equipped_item)
	if slot_index != -1:
		Inventory.slots[slot_index] = null
	Inventory.emit_signal("inventory_updated")

	# Hide visuals
	match equipped_item:
		"KEY": player_key.visible = false
		"COFFEE": player_coffee.visible = false
		"CROWBAR": player_crowbar.visible = false
		"FLASHLIGHT": player_flashlight.visible = false
		"KEY_CARD": player_keycard.visible = false
		"MATCHSTICK_RIGID": player_matchstick.visible = false

	equipped_item = ""

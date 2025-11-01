extends CharacterBody3D

@export var patrol_destinations: Array[Node3D]
@onready var player = get_tree().current_scene.get_node("player")
var speed = 3.0
@onready var rng = RandomNumberGenerator.new()
var destination
var chasing = false
var killed = false
var chase_timer = 0
@export var footstep_sound: Array[AudioStream]

@onready var anim: AnimationPlayer = $monster_enemy/AnimationPlayer

func _ready() -> void:
	anim.play("idle")
	pick_destination()

func footsteps():
	if not chasing and $feet.pitch_scale != 1.0:
		$feet.pitch_scale = 1.0
	elif chasing and $feet.pitch_scale != 1.5:
		$feet.pitch_scale = 1.5
	if not $feet.playing:
		$feet.stream = footstep_sound[rng.randi_range(0, footstep_sound.size() - 1)]
		$feet.play()

func _process(delta: float) -> void:
	if killed:
		if anim.current_animation != "jumpscare":
			anim.play("jumpscare")
		return

	if speed > 0:
		footsteps()

	if chasing:
		speed = 3.0
	else:
		speed = 2.0

	if chasing:
		if chase_timer < 15.0:
			chase_timer += delta
		else:
			chase_timer = 0
			if $killcast/killcast.enabled:
				$killcast/killcast.enabled = false
			chasing = false
			pick_destination()

	if destination != null:
		var look_dir = lerp_angle(
			deg_to_rad(global_rotation_degrees.y),
			atan2(-velocity.x, -velocity.z),
			0.5
		)
		global_rotation_degrees.y = rad_to_deg(look_dir)
		update_target_location()

func chase_player(chasecast: RayCast3D):
	if chasecast.is_colliding():
		var hit = chasecast.get_collider()
		if hit.name == "player":
			chasing = true
			destination = player

func _physics_process(delta: float) -> void:
	if killed:
		return

	if chasing:
		kill_player()

	chase_player($chasecast)
	chase_player($chasecast2)
	chase_player($chasecast3)
	chase_player($chasecast4)
	chase_player($chasecast5)

	if destination != null:
		var current_location = global_transform.origin
		var next_location = $NavigationAgent3D.get_next_path_position()
		var new_velocity = (next_location - current_location).normalized() * speed
		velocity = velocity.move_toward(new_velocity, 0.25)
		move_and_slide()

		if not chasing and current_location.distance_to(destination.global_transform.origin) < 1.0:
			await get_tree().create_timer(rng.randf_range(1.0, 3.0)).timeout
			pick_destination()

	if velocity.length() > 0.1:
		if anim.current_animation != "walk":
			anim.play("walk")
	else:
		if anim.current_animation != "idle":
			anim.play("idle")

func kill_player():
	if not $killcast/killcast.enabled:
		$killcast/killcast.enabled = true
	$killcast.look_at(player.global_transform.origin)
	if $killcast/killcast.is_colliding():
		var hit = $killcast/killcast.get_collider()
		if hit.name == "player" and not killed:
			killed = true
			$jumpscare_cam.current = true
			anim.play("jumpscare")
			anim.speed_scale = 2
			player.process_mode = Node.PROCESS_MODE_DISABLED
			velocity = Vector3.ZERO
			move_and_slide()
			await get_tree().create_timer(2.5, false).timeout
			get_tree().change_scene_to_file("res://scenery/death.tscn")

func pick_destination():
	if killed or chasing:
		return

	var available_destinations: Array[Node3D] = []

	for dest in patrol_destinations:
		if dest != null and (not dest.has_method("locked") or not dest.locked):
			available_destinations.append(dest)

	if available_destinations.size() == 0:
		return

	var new_destination: Node3D = available_destinations[rng.randi_range(0, available_destinations.size() - 1)]

	if destination != null and available_destinations.size() > 1:
		while new_destination == destination:
			new_destination = available_destinations[rng.randi_range(0, available_destinations.size() - 1)]

	destination = new_destination

func update_target_location():
	$NavigationAgent3D.target_position = destination.global_transform.origin

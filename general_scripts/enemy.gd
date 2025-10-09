extends CharacterBody3D

@export var patrol_destinations: Array[Node3D]
@onready var player = get_tree().current_scene.get_node("player")
var speed = 3.0
@onready var rng = RandomNumberGenerator.new()
var destination
var chasing = false
var destination_value
var killed = false
var chase_timer = 0

@onready var anim = $monster_enemy/AnimationPlayer

func _ready() -> void:
	anim.play("idle")
	pick_destination()

func _process(delta: float) -> void:
	if !killed:
		if !chasing:
			if speed != 3.0:
				speed = 3.0
		if chasing:
			if speed != 5.0:
				speed = 5.0
			if chase_timer < 15.0:
				chase_timer += 1 * delta
			else:
				chase_timer = 0
				if $killcast.enabled:
					$killcast.enabled = false
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
			if !$killcast.enabled:
				$killcast.enabled = true
			destination = player

func _physics_process(delta: float) -> void:
	if !killed:
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

		# Animation switch
		if velocity.length() > 0.1:
			if anim.current_animation != "walk":
				anim.play("walk")
		else:
			if anim.current_animation != "idle":
				anim.play("idle")

func kill_player():
	$killcast.look_at(player)
	if $killcast.is_colliding():
		var hit = $killcast.get_collider()
		if hit.name == "player" and !killed:
			killed = true
			$jumpscare_cam.cuurent = true
			$monster_enemy/AnimationPlayer.play("jumpscare")
			$monster_enemy/AnimationPlayer.speed_scale = 1
			player.process_mode = Node.PROCESS_MODE_DISABLED

func pick_destination(dont_choose = null):
	if !chasing and !killed:
		var num = rng.randi_range(0, patrol_destinations.size()-1)
		destination_value = num
		destination = patrol_destinations[num]
		if destination != null and dont_choose != null and destination == patrol_destinations[dont_choose]:
			if dont_choose < 1:
				destination = patrol_destinations[dont_choose + 1]
			if dont_choose > 0 and dont_choose <= patrol_destinations.size() - 1:
				destination = patrol_destinations[dont_choose - 1]

func update_target_location():
	$NavigationAgent3D.target_position = destination.global_transform.origin

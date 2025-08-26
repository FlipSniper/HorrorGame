extends CharacterBody3D


var speed = 3.5
const JUMP_VELOCITY = 4.5

var crouching = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("crouch"):
		crouching = !crouching
	if crouching and speed !=1.25:
		speed = 1.25
	if !crouching and speed !=3.5:
		speed = 3.5

func _physics_process(delta: float) -> void:
	if crouching  and $CollisionShape3D.shape.height > 0.25:
		var chrouch_height = lerp($CollisionShape3D.shape.height,0.25,0.2)
		$CollisionShape3D.shape.height = chrouch_height
	if !crouching  and $CollisionShape3D.shape.height < 2.0:
		var chrouch_height = lerp($CollisionShape3D.shape.height,2.0,0.2)
		$CollisionShape3D.shape.height = chrouch_height
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backwards")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()

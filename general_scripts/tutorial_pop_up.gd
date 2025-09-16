extends CanvasLayer

var tutorial = false
var wasd = false
var interacter = false
var start = "move"
var main_scene_name

@onready var movement_parent = get_tree().current_scene.get_node("player/player_ui/tutorial_pop_ups/movement")
@onready var movement = [
	movement_parent.get_node("TextureRect"),
	movement_parent.get_node("TextureRect2"),
	movement_parent.get_node("TextureRect3"),
	movement_parent.get_node("TextureRect4")
]

@onready var interact_parent = get_tree().current_scene.get_node("player/player_ui/tutorial_pop_ups/interact")
@onready var interact_tex = interact_parent.get_node("TextureRect")

func _ready() -> void:
	var current_scene = get_tree().current_scene
	if current_scene != null:
		main_scene_name = current_scene.name
		print("Current main scene: ", main_scene_name)

	if main_scene_name == "office":
		tutorial = true
	elif main_scene_name == "level":
		tutorial = false
		visible = false

	# Reset scales just in case
	for rect in movement:
		rect.scale = Vector2.ONE
	interact_tex.scale = Vector2.ONE

	# Hide whole parents initially
	movement_parent.visible = true
	interact_parent.visible = false

	# Start movement wiggles
	if tutorial and start == "move":
		for i in range(movement.size()):
			wiggle_loop(movement[i], func(): return !wasd)

func _process(delta: float) -> void:
	# ---------------- MOVEMENT ----------------
	if tutorial and !wasd and start == "move":
		# Show movement, hide interact so they never overlap
		movement_parent.visible = true
		interact_parent.visible = false

		if Input.is_action_just_pressed("forward") \
		or Input.is_action_just_pressed("backwards") \
		or Input.is_action_just_pressed("left") \
		or Input.is_action_just_pressed("right"):
			wasd = true
			movement_parent.visible = false
	else:
		if wasd:
			movement_parent.visible = false

	# ---------------- INTERACT ----------------
	if tutorial and !interacter and start == "interact":
		# Show interact, hide movement so they never overlap
		movement_parent.visible = false

		if Input.is_action_just_pressed("interact"):
			interacter = true
			interact_parent.visible = false
		elif !interact_parent.visible:
			# First time showing interact
			interact_parent.visible = true
			wiggle_loop(interact_tex, func(): return !interacter)
	else:
		if interacter:
			interact_parent.visible = false

# ---------------- WIGGLE ANIMATION ----------------
func wiggle_loop(rect: TextureRect, should_continue: Callable) -> void:
	await get_tree().process_frame
	while tutorial and should_continue.call():
		var tween = get_tree().create_tween()
		tween.set_trans(Tween.TRANS_SINE)
		tween.set_ease(Tween.EASE_IN_OUT)

		# Scale up
		tween.tween_property(rect, "scale", Vector2(1.2, 1.2), 0.3)
		# Scale down
		tween.tween_property(rect, "scale", Vector2.ONE, 0.3)

		await tween.finished

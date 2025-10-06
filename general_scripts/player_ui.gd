extends Control

var safe_anim
@onready var rng = RandomNumberGenerator.new()
@onready var code_paper = get_tree().current_scene.get_node("code_paper")
var safe_password
var safe_interactable = true
var main_scene_name = ""
var safe

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$fade_ui/AnimationPlayer.play("fade")
	var current_scene = get_tree().current_scene
	if current_scene != null:
		main_scene_name = current_scene.name  # "Office" or "Level" etc.
		print("Current main scene: ", main_scene_name)
	var powerbox = false
	if main_scene_name == "level":
		safe_anim = get_tree().current_scene.get_node("house/safe/AnimationPlayer")
		safe = get_tree().current_scene.get_node("house/safe/safe/CollisionShape3D")
		set_task("Ring the door bell... twice for good measure",null)
	if main_scene_name == "office":
		safe_anim = get_tree().current_scene.get_node("office_layout/safe/AnimationPlayer")
		set_task(".Follow the arrow to the code. Use WASD and mouse or arrow keys to look around. You may use a controller", null)
		safe = get_tree().current_scene.get_node("office_layout/safe/safe/CollisionShape3D")
		
	$safe_ui.visible = false
	$pause_menu.visible = false
	$controls.visible = false
	$Set.visible = true
	var p1 = rng.randi_range(0,9)
	var p2 = rng.randi_range(0,9)
	var p3 = rng.randi_range(0,9)
	var p4 = rng.randi_range(0,9)
	safe_password = str(p1) + str(p2) + str(p3) + str(p4)
	code_paper.get_node("code_text").mesh.text =  safe_password
	print(safe_password)
	await  get_tree().create_timer(1.1,false).timeout
	$fade_ui.visible = false

func resume_game():
	get_tree().paused = false
	$pause_menu.visible = false
	$Set.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func quit_game():
	get_tree().quit()

func main_menu():
	get_tree().change_scene_to_file("res://Main/main_menu.tscn")
	
func open_safe_password():
	if safe_interactable:
		$safe_ui.visible = true
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if main_scene_name == "office":
			set_task("!Go back and memorise the code",null)
		else:
			set_task("!Find the code... it must be in the drawers",null)
func confirm_password():
	if $safe_ui/password.text == safe_password:
		safe_anim.play("open")
		safe_interactable = false
		safe.disabled = true
		exit_safe()
		if main_scene_name == "office":
			set_task("!Grab the coffee","res://assets/icons/coffee.png")
		else:
			set_task("!Nothing here for now",null)

func exit_safe():
	$safe_ui.visible = false
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func controls():
	$pause_menu.visible = false
	$controls.visible = true

func close_controls():
	$pause_menu.visible = true
	$controls.visible = false

func settings_open():
	$Set.visible = false
	$pause_menu.visible = !$pause_menu.visible
	get_tree().paused = $pause_menu.visible
	if get_tree().paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if !get_tree().paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		$pause_menu.visible = false
		$controls.visible = false
		$Set.visible = true

func set_task(task_text:String, task_texture):
	$task_ui/task_text.text = task_text
	icon_rect.texture = load(task_texture)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause") and !$safe_ui.visible:
		settings_open()


func mian_menu() -> void:
	pass # Replace with function body.

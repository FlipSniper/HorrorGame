extends Control

@onready var safe_anim = get_tree().current_scene.get_node("house/safe/AnimationPlayer")
@onready var rng = RandomNumberGenerator.new()
@onready var code_paper = get_tree().current_scene.get_node("code_paper")
var safe_password
var safe_interactable = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$safe_ui.visible = false
	$pause_menu.visible = false
	$controls.visible = false
	set_task("Ring the door bell... twice for good measure")
	var p1 = rng.randi_range(0,9)
	var p2 = rng.randi_range(0,9)
	var p3 = rng.randi_range(0,9)
	var p4 = rng.randi_range(0,9)
	safe_password = str(p1) + str(p2) + str(p3) + str(p4)
	code_paper.get_node("code_text").mesh.text =  safe_password
	print(safe_password)

func resume_game():
	get_tree().paused = false
	$pause_menu.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func quit_game():
	get_tree().quit()
	
func open_safe_password():
	if safe_interactable:
		$safe_ui.visible = true
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		set_task("!Find the code... it must be in the drawers")
func confirm_password():
	if $safe_ui/password.text == safe_password:
		safe_anim.play("open")
		safe_interactable = false
		exit_safe()

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
	

func set_task(task_text:String):
	$task_ui/task_text.text = task_text

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause") and !$safe_ui.visible:
		$pause_menu.visible = !$pause_menu.visible
		get_tree().paused = $pause_menu.visible
		if get_tree().paused:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if !get_tree().paused:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

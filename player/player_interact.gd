extends RayCast3D

@onready var crosshair = get_parent().get_parent().get_node("player_ui/CanvasLayer/crosshair")
@onready var player_ui = get_parent().get_parent().get_node("player_ui")
@onready var player = get_tree().current_scene.get_node_or_null("player")

# Pickups
@onready var player_key = get_tree().current_scene.get_node_or_null("player/head/player_key")
@onready var player_crowbar = get_tree().current_scene.get_node_or_null("player/head/crowbar")

# Objects
@export var door: Node3D
var lock_opened
var key
var key_collider
var coffee
var coffee_collider
var flashlight
var flashlight_collider
var plank1
var plank2
var powerbox = false
var trapdoor = false
var proper_crowbar
var main_scene_name = ""
var boiler = false
var melted = false
var elevator_animplayer
var elevator
var fire

func _ready() -> void:
	var current_scene = get_tree().current_scene
	if current_scene != null:
		main_scene_name = current_scene.name

	if main_scene_name == "level":
		powerbox = false
		lock_opened = current_scene.get_node_or_null("house/lock")
		key_collider = current_scene.get_node_or_null("key/CollisionShape3D")
		key = current_scene.get_node_or_null("key/Node3D")
	elif main_scene_name == "office":
		coffee_collider = current_scene.get_node_or_null("coffee/CollisionShape3D")
		coffee = current_scene.get_node_or_null("coffee")
		flashlight_collider = current_scene.get_node_or_null("flashlight/CollisionShape3D")
		flashlight = current_scene.get_node_or_null("flashlight")
		plank1 = current_scene.get_node_or_null("planks/plank1")
		plank2 = current_scene.get_node_or_null("planks/plank2")
		proper_crowbar = current_scene.get_node_or_null("crowbar")
		proper_crowbar.disable_body()
	elif main_scene_name == "level2":
		powerbox = true
		elevator_animplayer = current_scene.get_node_or_null("NavigationRegion3D/House/Elevator/AnimationPlayer")
		plank1 = current_scene.get_node_or_null("planks/plank1")
		plank2 = current_scene.get_node_or_null("planks/plank2")
		elevator = current_scene.get_node_or_null("NavigationRegion3D/House/Elevator")
		fire = current_scene.get_node_or_null("matchstick")

func _physics_process(delta: float) -> void:
	if is_colliding():
		var hit = get_collider()
		crosshair.visible = false

		if not hit:
			return

		var hit_name = hit.name.to_lower()

		if hit_name in ["safe", "light_switch", "powerbox", "door", "drawer", "door_bell",
						"lock", "plank1", "plank2", "key", "crowbar", "flashlight", "coffee", "trapdoor","crystal","elevator","ice", "water_boiler",
						"matchstick", "elevator_ground", "elevator_floor1", "elevator_button", "elevator_button2",
						"turner"]:
			crosshair.visible = true
			if Input.is_action_just_pressed("interact"):
				handle_interaction(hit, hit_name)
		else:
			crosshair.visible = false

func handle_interaction(hit: Node, hit_name: String) -> void:
	match hit_name:
		"safe":
			if powerbox or main_scene_name == "office":
				player_ui.open_safe_password()
		"light_switch":
			if powerbox:
				hit.get_parent().toggle_light()
		"powerbox":
			if not powerbox:
				hit.get_parent().get_parent().toggle_power()
				player_ui.set_task(".Find the safe","res://assets/icons/safe.png")
				powerbox = true
		"door":
			hit.get_parent().get_parent().get_parent().toggle_door()
		"drawer":
			hit.get_parent().get_parent().toggle_door()
			hit.get_parent().get_parent().get_node("DrawerSound").play()
		"door_bell":
			hit.get_parent().ring_bell()
		"lock":
			if lock_opened and player_key.visible:
				hit.get_parent().toggle_lock()
				trapdoor = true
				player_ui.set_task(".Crouch and open the trapdoor, make sure you find the right place to lift it from","res://assets/icons/trapdoor.png")
		"plank1":
			print(player_crowbar.visible)
			if player_crowbar.visible:
				hit.get_parent().toggle_plank(0)
				if hit.get_parent().unlocked == 2:
					door.locked = false
		"plank2":
			if player_crowbar.visible:
				hit.get_parent().toggle_plank(1)
				if hit.get_parent().unlocked == 2:
					door.locked = false
		"key":
			if hit != null:
				hit.queue_free()
			Inventory.add_item("KEY")
			player_ui.set_task(".Nice work. Now open the lock","res://assets/icons/lock.png")
		"crowbar":
			print(hit != null)
			if hit != null:
				proper_crowbar.queue_free()
				print("here")
			Inventory.add_item("CROWBAR")
			player_ui.set_task(".Nice work. Now take down the planks","res://assets/icons/plank.png")
		"flashlight":
			if flashlight_collider: flashlight_collider.visible = false
			if flashlight: flashlight.visible = false
			if hit != null:
				hit.queue_free()
			Inventory.add_item("FLASHLIGHT")
			player_ui.set_task(".Now leave the office. Use the crowbar to get rid of planks","res://assets/icons/crowbar.png")
			player.change_arrow("exit")
			get_tree().current_scene.get_node("task_trigger3").leave = true
		"coffee":
			if hit != null:
				hit.queue_free()

			# Update player visuals / inventory
			Inventory.add_item("COFFEE")
			player_ui.set_task(".Nice work. Now go to the boss's office. Use R and equip the coffee","res://assets/icons/coffee.png")
			player.change_arrow("boss")


		"trapdoor":
			if trapdoor:
				hit.get_parent().get_parent().get_parent().toggle_lock()
				player_ui.set_task(".Find the powerbox","res://assets/icons/powerbox.png")
				await get_tree().create_timer(1.1,false).timeout
				hit.get_parent().get_parent().get_parent().get_parent().bake_navigation_mesh()
				trapdoor = false
		"crystal":
			if hit.get_parent() != null:
				hit.get_parent().toggle_crystal()
				print("trying")
				hit.get_parent().queue_free()
			if main_scene_name == "level":
				player_level.level1 += 1
				player_level.crystals += 1
			player_ui.set_task(".Leave the property")
		"turner":
			if !boiler:
				hit.get_parent().get_parent().toggle_boil()
				player_ui.set_task(".Nice now melt the ice")
				boiler = true
		"ice":
			if !melted and boiler:
				hit.get_parent().melt_ice()
				player_ui.set_task(".Now take the key card")
		"elevator_button":
			var same =  await elevator.elevator("g_back")
			print(same)
			if same:
				elevator_animplayer.play("open")
		"elevator_button2":
			var same = await elevator.elevator("f_back")
			if same:
				elevator_animplayer.play("open")
		"elevator_ground":
			await hit.get_parent().get_parent().elevator("ground")
		"elevator_floor1":
			print("trying")
			await hit.get_parent().get_parent().elevator("floor")

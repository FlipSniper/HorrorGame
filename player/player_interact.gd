extends RayCast3D

@onready var crosshair = get_parent().get_parent().get_node("player_ui/CanvasLayer/crosshair")
@onready var crosshair_tex = get_parent().get_parent().get_node("player_ui/CanvasLayer/crosshair/crosshairtex")
@onready var player_ui = get_parent().get_parent().get_node("player_ui")
@onready var player = get_tree().current_scene.get_node_or_null("player")

# Pickups
@onready var player_key = get_tree().current_scene.get_node_or_null("player/head/player_key")
@onready var player_boilerwheel = get_tree().current_scene.get_node_or_null("player/head/boiler_wheel")
@onready var player_crowbar = get_tree().current_scene.get_node_or_null("player/head/crowbar")
@onready var player_battery = get_tree().current_scene.get_node_or_null("player/head/battery")
@onready var player_keycard = get_tree().current_scene.get_node_or_null("player/head/keycard")
@onready var player_screwdriver = get_tree().current_scene.get_node_or_null("player/head/screwdriver")
@onready var scan = get_tree().current_scene.get_node_or_null("player/scan")

# Objects
@export var door: Node3D
@export var door2: Node3D
var y_impulse
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
var control_panel
var main_scene_name = ""
var boiler = false
var wheel_in = false
var melted = false
var panel
var elevator_animplayer
var elevator
var scanned = false
var fire
var flash
var library
var battery_in = 0

func _ready() -> void:
	var current_scene = get_tree().current_scene
	if current_scene != null:
		main_scene_name = current_scene.name

	if main_scene_name == "level":
		flash = false
		powerbox = false
		lock_opened = current_scene.get_node_or_null("house/lock")
		key_collider = current_scene.get_node_or_null("key/CollisionShape3D")
		key = current_scene.get_node_or_null("key/Node3D")
	elif main_scene_name == "office":
		flash = true
		coffee_collider = current_scene.get_node_or_null("coffee/CollisionShape3D")
		coffee = current_scene.get_node_or_null("coffee")
		flashlight_collider = current_scene.get_node_or_null("flashlight/CollisionShape3D")
		flashlight = current_scene.get_node_or_null("flashlight")
		plank1 = current_scene.get_node_or_null("planks/plank1")
		plank2 = current_scene.get_node_or_null("planks/plank2")
		proper_crowbar = current_scene.get_node_or_null("crowbar")
		proper_crowbar.disable_body()
	elif main_scene_name == "level2":
		panel = get_tree().current_scene.get_node_or_null("NavigationRegion3D/control_panel/meshes/top_panel")
		library = current_scene.get_node_or_null("NavigationRegion3D/House/shelf2")
		flash = false
		powerbox = true
		elevator_animplayer = current_scene.get_node_or_null("NavigationRegion3D/House/Elevator/AnimationPlayer")
		plank1 = current_scene.get_node_or_null("planks/plank1")
		plank2 = current_scene.get_node_or_null("planks/plank2")
		elevator = current_scene.get_node_or_null("NavigationRegion3D/House/Elevator")
		fire = current_scene.get_node_or_null("matchstick")
		control_panel = current_scene.get_node_or_null("NavigationRegion3D/control_panel")
		panel.freeze = true
		panel.sleeping = true

func _physics_process(delta: float) -> void:
	if !is_colliding():
		crosshair_tex.modulate = "ffffff4c"
	if is_colliding():
		var hit = get_collider()

		if not hit:
			return

		var hit_name = hit.name.to_lower()
		if hit_name in ["safe", "light_switch", "powerbox", "door", "drawer", "door_bell",
						"lock", "plank1", "plank2", "key", "crowbar", "flashlight", "coffee", "trapdoor","crystal","elevator","ice", "water_boiler",
						"matchstick", "elevator_ground", "elevator_floor1", "elevator_button", "elevator_button2",
						"key_card", "matchstick_box", "matchstick","fire","boiler_wheel","missing_wheel"
						,"screwdriver","screw","screw2","screw3","magnet_spawn", "magnet","holder","battery","scanner",
						"screw4","screw5","screw6","screw7","screw8","control_switch"]:
			crosshair_tex.modulate = "ffffffff"
			if hit.name == "screw":
				print("wth bro")
			if Input.is_action_just_pressed("interact"):
				handle_interaction(hit, hit_name)
		else:
			crosshair_tex.modulate = "ffffff4c"

func handle_interaction(hit: Node, hit_name: String) -> void:
	match hit_name:
		"control_switch":
			hit.get_parent().get_parent().get_parent().toggle_switch()
			player_ui.set_task(".The scanner and other electricty requiring appliances work now")
		"screwdriver":
			if hit != null:
				var added = Inventory.add_item("SCREWDRIVER")
				if added:
					hit.queue_free()
					player_ui.set_task(".You can now unscrew the screws of the control panel")
				else:
					print("Inventory full! Couldn't pick up screwdriver.")
		"screw":
			if player_screwdriver.visible:
				hit.get_parent().toggle_screw(0)
				await get_tree().create_timer(1.8).timeout
				print(hit.get_parent().unlocked)
				if hit.get_parent().unlocked == 8:
					player_ui.set_task(".Turn the lever on")
					print("yeye")
					panel.freeze = false
					panel.sleeping = false
					panel.apply_impulse(Vector3(randf() - 0.5, 1.0, randf() - 1.0) * 3.0)
		"screw2":
			if player_screwdriver.visible:
				hit.get_parent().toggle_screw(1)
				await get_tree().create_timer(1.8).timeout
				print(hit.get_parent().unlocked)
				if hit.get_parent().unlocked == 8:
					player_ui.set_task(".Turn the lever on")
					print("yeye")
					panel.freeze = false
					panel.sleeping = false
					panel.apply_impulse(Vector3(randf() - 0.5, 1.0, randf() - 1.0) * 3.0)
		"screw3":
			if player_screwdriver.visible:
				hit.get_parent().toggle_screw(2)
				await get_tree().create_timer(1.8).timeout
				print(hit.get_parent().unlocked)
				if hit.get_parent().unlocked == 8:
					player_ui.set_task(".Turn the lever on")
					print("yeye")
					panel.freeze = false
					panel.sleeping = false
					panel.apply_impulse(Vector3(randf() - 0.5, 1.0, randf() - 1.0) * 3.0)
		"screw4":
			if player_screwdriver.visible:
				hit.get_parent().toggle_screw(3)
				await get_tree().create_timer(1.8).timeout
				print(hit.get_parent().unlocked)
				if hit.get_parent().unlocked == 8:
					player_ui.set_task(".Turn the lever on")
					print("yeye")
					panel.freeze = false
					panel.sleeping = false
					panel.apply_impulse(Vector3(randf() - 0.5, 1.0, randf() - 1.0) * 3.0)
		"screw5":
			if player_screwdriver.visible:
				hit.get_parent().toggle_screw(4)
				await get_tree().create_timer(1.8).timeout
				print(hit.get_parent().unlocked)
				if hit.get_parent().unlocked == 8:
					player_ui.set_task(".Turn the lever on")
					print("yeye")
					panel.freeze = false
					panel.sleeping = false
					panel.apply_impulse(Vector3(randf() - 0.5, 1.0, randf() - 1.0) * 3.0)
		"screw6":
			if player_screwdriver.visible:
				hit.get_parent().toggle_screw(5)
				await get_tree().create_timer(1.8).timeout
				print(hit.get_parent().unlocked)
				if hit.get_parent().unlocked == 8:
					player_ui.set_task(".Turn the lever on")
					print("yeye")
					panel.freeze = false
					panel.sleeping = false
					panel.apply_impulse(Vector3(randf() - 0.5, 1.0, randf() - 1.0) * 3.0)
		"screw7":
			if player_screwdriver.visible:
				hit.get_parent().toggle_screw(6)
				await get_tree().create_timer(1.8).timeout
				print(hit.get_parent().unlocked)
				if hit.get_parent().unlocked == 8:
					player_ui.set_task(".Turn the lever on")
					print("yeye")
					panel.freeze = false
					panel.sleeping = false
					panel.apply_impulse(Vector3(randf() - 0.5, 1.0, randf() - 1.0) * 3.0)
		"screw8":
			if player_screwdriver.visible:
				hit.get_parent().toggle_screw(7)
				await get_tree().create_timer(1.8).timeout
				print(hit.get_parent().unlocked)
				if hit.get_parent().unlocked == 8:
					player_ui.set_task(".Turn the lever on")
					print("yeye")
					panel.freeze = false
					panel.sleeping = false
					panel.apply_impulse(Vector3(randf() - 0.5, 1.0, randf() - 1.0) * 3.0)
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
				var added = Inventory.add_item("KEY")
				if added:
					hit.queue_free()
					player_ui.set_task(".Nice work. Now open the lock","res://assets/icons/lock.png")
				else:
					print("Inventory full! Couldn't pick up key.")
		"crowbar":
			if hit != null:
				var added = Inventory.add_item("CROWBAR")
				if added:
					proper_crowbar.queue_free()
					print("Picked up crowbar.")
					player_ui.set_task(".Nice work. Now take down the planks","res://assets/icons/plank.png")
				else:
					print("Inventory full! Couldn't pick up crowbar.")
		"flashlight":
			if hit != null:
				var added = Inventory.add_item("FLASHLIGHT")
				if added:
					if flashlight_collider: flashlight_collider.visible = false
					if flashlight: flashlight.visible = false
					hit.queue_free()
					print("ye mint")
					if flash:
						print("stupid")
						player_ui.set_task(".Now leave the office. Use the crowbar to get rid of planks","res://assets/icons/crowbar.png")
						player.change_arrow("exit")
						get_tree().current_scene.get_node("task_trigger3").leave = true
					flash = false
				else:
					print("Inventory full! Couldn't pick up flashlight.")
		"coffee":
			if hit != null:
				var added = Inventory.add_item("COFFEE")
				if added:
					hit.queue_free()
					player_ui.set_task(".Nice work. Now go to the boss's office. Use R and equip the coffee","res://assets/icons/coffee.png")
					player.change_arrow("boss")
				else:
					print("Inventory full! Couldn't pick up coffee.")
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
		"ice":
			if !melted and boiler:
				hit.get_parent().melt_ice()
				player_ui.set_task(".Now take the key card")
				melted = true
		"elevator_button":
			if battery_in == 2:
				var same =  await elevator.elevator("g_back")
				if same:
					elevator_animplayer.play("open")
		"elevator_button2":
			var same = await elevator.elevator("f_back")
			if same:
				elevator_animplayer.play("open")
		"elevator_ground":
			await hit.get_parent().get_parent().elevator("ground")
		"elevator_floor1":
			await hit.get_parent().get_parent().elevator("floor")
		"key_card":
			if hit != null:
				var added = Inventory.add_item("KEY_CARD")
				if added:
					hit.queue_free()
					player_ui.set_task(".Scan the card on the scanner")
				else:
					print("Inventory full! Couldn't pick up key card.")
		"matchstick_box":
			if hit != null:
				var added = Inventory.add_item("MATCHSTICK")
				if added:
					hit.get_parent().toggle_matchstick()
					player_ui.set_task(".Light up the fire on the statue, to reveal a secret")
				else:
					print("Inventory full! Couldn't pick up matchstick.")
		"matchstick":
			if hit != null:
				var added = Inventory.add_item("MATCHSTICK")
				if added:
					hit.queue_free()
					player_ui.set_task(".Light up the fire on the statue, to reveal a secret")
				else:
					print("Inventory full! Couldn't pick up matchstick.")
		"magnet_spawn":
			if hit != null:
				var added = Inventory.add_item("MAGNET")
				if added:
					hit.get_parent().queue_free()
					player_ui.set_task(".Use this to get the hidden battery")
				else:
					print("Inventory full! Couldn't pick up magnet.")
		"magnet":
			if hit != null:
				var added = Inventory.add_item("MAGNET")
				if added:
					hit.queue_free()
					player_ui.set_task(".Use this to get the hidden battery")
				else:
					print("Inventory full! Couldn't pick up magnet.")
		"battery":
			if hit != null:
				var added = Inventory.add_item("BATTERY")
				if added:
					hit.queue_free()
					player_ui.set_task(".This is needed to be placed on the battery holder. Opposite of the elevator")
				else:
					print("Inventory full! Couldn't pick up battery.")
		"boiler_wheel":
			if hit != null:
				if !hit.get_parent().get_parent().name == "boiler":
					var added = Inventory.add_item("BOILER_WHEEL")
					if added:
						if hit is StaticBody3D:
							hit.get_parent().queue_free()
							player_ui.set_task(".You found the missing wheel. Place it onto the boiler")
							print("here")
						else:
							hit.queue_free()
					else:
						print("Inventory full! Couldn't pick up BOILER_WHEEL.")
				else:
					if wheel_in and !boiler:
						hit.get_parent().get_parent().toggle_boiler()
						boiler = true
						player_ui.set_task(".The boiler is now on. Melt the ice")
		"missing_wheel":
			if !wheel_in and player_boilerwheel.visible:
				var item_index = Inventory.find_item("BOILER_WHEEL")
				if item_index != -1:
					Inventory.remove_item(item_index)
					player_boilerwheel.visible = false
					player.equipped_item = ""
					print("YEEEEEEE MINT")
					print(Inventory.slots)
					hit.get_parent().toggle_wheel()
					wheel_in = true
					player_ui.set_task(".Turn the wheel to switch the boiler on")
		"holder":
			if battery_in != 2 and player_battery.visible:
				var item_index = Inventory.find_item("BATTERY")
				if item_index != -1:
					Inventory.remove_item(item_index)
					player_battery.visible = false
					player.equipped_item = ""
					print("YEEEEEEE MINT")
					print(Inventory.slots)
					hit.get_parent().toggle_battery()
					battery_in += 1
				else:
					print("You don’t have the BATTERY!")
				if battery_in == 2:
					player_ui.set_task(".The elevator is now powered")
		"scanner":
			if player_keycard.visible == true and !scanned and control_panel.switched_on:
				scanned = true
				door2.locked = false
				scan.play()
				player_ui.set_task(".Open the door and access the elevator")
		"fire":
			if player.equipped == "MATCHSTICK":
				library.play("open")
				player_ui.set_task(".The secret passage is open")

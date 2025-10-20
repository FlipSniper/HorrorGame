extends CanvasLayer

@onready var player = get_tree().current_scene.get_node("player")

@export var max_slots: int = 8
var item_icons := {
	"KEY": "res://assets/icons/key.png",
	"CROWBAR": "res://assets/icons/crowbar.png",
	"COFFEE": "res://assets/icons/coffee.png",
	"FLASHLIGHT": "res://assets/icons/flashlight.png",
	"KEY_CARD": "res://assets/icons/keycard.png",
	"MATCHSTICK": "res://assets/icons/matchstick.png",
	"BOILER_WHEEL": "res://assets/icons/boilerwheel.png"
}

func _ready() -> void:
	print("Inventory UI ready")  # Debug
	visible = false
	
	# Connect inventory signals
	Inventory.connect("inventory_updated", Callable(self, "update_inventory_ui"))
	Inventory.connect("slot_unlocked", Callable(self, "update_inventory_ui"))

	# Connect all slots
	for i in range(1, max_slots + 1):
		var slot_path = "Panel/slots/Slot" + str(i)
		if has_node(slot_path):
			var slot = get_node(slot_path)
			if slot is Button:
				print("Connecting slot:", slot.name) # Debug
				# Children like Icon/Highlight should ignore mouse
				for child in slot.get_children():
					if child is Control:
						child.mouse_filter = Control.MOUSE_FILTER_IGNORE
				# Connect signals
				if not slot.is_connected("pressed", Callable(self, "_on_slot_pressed")):
					slot.connect("pressed", Callable(self, "_on_slot_pressed").bind(i))
				if not slot.is_connected("mouse_entered", Callable(self, "_on_slot_hover")):
					slot.connect("mouse_entered", Callable(self, "_on_slot_hover").bind(i))
				if not slot.is_connected("mouse_exited", Callable(self, "_on_slot_unhover")):
					slot.connect("mouse_exited", Callable(self, "_on_slot_unhover").bind(i))
			else:
				push_warning("Slot at %s is not a Button!" % slot_path)
		else:
			push_warning("Missing slot node at path: %s" % slot_path)

	update_inventory_ui()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("inventory"):
		visible = !visible
		if visible:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func update_inventory_ui() -> void:
	for i in range(1, max_slots + 1):
		var slot_path = "Panel/slots/Slot" + str(i)
		if not has_node(slot_path):
			continue
		var slot = get_node(slot_path)
		var icon_rect = slot.get_node("Icon")
		var highlight = slot.get_node("Highlight")

		# grey out locked slots
		if i > Inventory.unlocked_slots:
			icon_rect.texture = null
			icon_rect.modulate = Color(0.3, 0.3, 0.3, 0.5)
			highlight.visible = false
			continue

		var item_name = Inventory.slots[i - 1]

		if item_name != null and item_icons.has(item_name):
			icon_rect.texture = load(item_icons[item_name])
			icon_rect.modulate = Color(1, 1, 1, 0.9)
		else:
			icon_rect.texture = null
			icon_rect.modulate = Color(1, 1, 1, 0.2)

		highlight.visible = false


func _on_slot_pressed(index: int) -> void:
	print("Pressed slot:", index)
	if index <= Inventory.unlocked_slots:
		var item_name = Inventory.slots[index - 1]
		if item_name != null:
			print("Equipping:", item_name)
			player.equip_item(item_name)


func _on_slot_hover(index: int) -> void:
	if index <= Inventory.unlocked_slots:
		var slot = get_node("Panel/slots/Slot" + str(index))
		var highlight = slot.get_node("Highlight")
		highlight.visible = true
		highlight.modulate = Color(0.8, 0, 0, 0.6)


func _on_slot_unhover(index: int) -> void:
	if index <= Inventory.unlocked_slots:
		var slot = get_node("Panel/slots/Slot" + str(index))
		var highlight = slot.get_node("Highlight")
		highlight.visible = false

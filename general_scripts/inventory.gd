extends Node

signal inventory_updated()
signal slot_unlocked(new_total_slots)

@export var max_slots: int = 8
@onready var unlocked_slots: int = 1

# Slots array: each slot stores a string (item name) or null
var slots: Array = []

func _ready():
	slots.resize(max_slots)
	for i in range(max_slots):
		slots[i] = null

# Unlock next slot
func unlock_slot() -> void:
	if unlocked_slots < max_slots:
		unlocked_slots += 1
		emit_signal("slot_unlocked", unlocked_slots)
		print("Unlocked slot ", unlocked_slots, "/", max_slots)

# Add unique item to first empty unlocked slot
func add_item(item_name: String) -> bool:
	for i in range(unlocked_slots):
		if slots[i] == null:
			slots[i] = item_name
			emit_signal("inventory_updated")
			print("Added ", item_name, " to slot ", i + 1)
			return true
	print("No free slots! Item not added: ", item_name)
	return false

# Remove item from slot
func remove_item(slot_index: int) -> void:
	if slot_index >= 0 and slot_index < unlocked_slots:
		if slots[slot_index] != null:
			print("Removed ", slots[slot_index], " from slot ", slot_index + 1)
			slots[slot_index] = null
			emit_signal("inventory_updated")
		else:
			print("Slot is already empty.")
	else:
		print("Invalid slot index.")

func find_item(item_name: String) -> int:
	for i in range(unlocked_slots):
		if slots[i] == item_name:
			return i
	return -1

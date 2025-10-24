extends Node3D
@onready var battery = $battery
@onready var battery2 = $battery2

func toggle_battery():
	if !battery.visible:
		battery.visible = true
		$AnimationPlayer.play("battery1")
	if battery.visible and !battery2.visible and !$AnimationPlayer.is_playing():
		battery2.visible = true
		$AnimationPlayer.play("battery2")

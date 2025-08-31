extends Node3D

@onready var anim_player = $AnimationPlayer  # Path to your AnimationPlayer

func _ready():
	# Play the animation called "Run" in a loop
	anim_player.play("Armature|Armature|mixamo_com|Layer0")
	anim_player.get_animation("Armature|Armature|mixamo_com|Layer0").loop = true

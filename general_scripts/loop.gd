extends AudioStreamPlayer

@export var delay_time: float = 2.0
@onready var delay_timer = get_tree().current_scene.get_node("AudioStreamPlayer2/Timer")  # Fixed capitalization

func _ready():
	stream.loop = false
	delay_timer.wait_time = delay_time
	
	connect("finished", Callable(self, "_on_audio_finished"))
	delay_timer.connect("timeout", Callable(self, "_on_delay_timeout"))
	
	play()

func _on_audio_finished():
	delay_timer.start()

func _on_delay_timeout():
	play()

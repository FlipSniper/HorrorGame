extends CanvasLayer

var quest = 0
var prev_quest = -1

func _on_button_pressed() -> void:
	if quest == 0:
		$FirstQuest.visible = !$FirstQuest.visible
	if quest == 1:
		$SecondQuest.visible = !$SecondQuest.visible
		
	

func _process(delta: float) -> void:
	if quest != prev_quest:
		_on_button_pressed()
		if prev_quest == 0:
			$FirstQuest.visible = false
	prev_quest = quest

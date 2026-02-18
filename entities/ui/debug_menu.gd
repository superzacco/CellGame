extends Control

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("f2"):
		if self.visible:
			hide()
		else:
			show()


@export var population: Label


func _on_timer_timeout() -> void:
	population.text = "%s" % GameManager.allCells.size()

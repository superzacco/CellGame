extends DraggableWindow

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("f2"):
		if self.visible:
			close_menu()
		else:
			open_menu()

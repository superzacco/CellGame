extends Control
class_name DraggableWindow

var mouseOver: bool = false
var dragging: bool = false

func _on_mouse_entered() -> void:
	mouseOver = true
	SignalBus.disable_view_drag.emit() 
func _on_mouse_exited() -> void:
	mouseOver = false

func open_menu():
	show()
func close_menu():
	SignalBus.enable_view_drag.emit()
	hide()

var clickPos: Vector2

func _physics_process(delta: float) -> void:
	if !self.visible:
		return
	
	if Input.is_action_just_pressed("mouse0"):
		if mouseOver:
			SignalBus.disable_view_drag.emit() 
		clickPos = (get_global_mouse_position() - self.global_position)
	
	if Input.is_action_pressed("mouse0") and (mouseOver or dragging):
		var mousePos: Vector2 = get_global_mouse_position()
		dragging = true
		
		self.global_position = mousePos - clickPos
	
	if Input.is_action_just_released("mouse0"):
		dragging = false
		SignalBus.enable_view_drag.emit()

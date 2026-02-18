extends Camera2D

@export var speed: float
var wishDir: Vector2

var clicking: bool = false
var canDrag: bool = true


func _ready() -> void:
	SignalBus.enable_view_drag.connect(enable_drag)
	SignalBus.disable_view_drag.connect(disable_drag)
	
	SignalBus.set_cam_pos.connect(set_cam_pos)


func _process(delta: float) -> void:
	wishDir.y = Input.get_axis("up", "down")
	wishDir.x = Input.get_axis("left", "right")
	
	self.global_position += wishDir.normalized() * speed


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse0"):
		clicking = true
	if event.is_action_released("mouse0"):
		clicking = false
	
	if event.is_action_pressed("mwheeldown"):
		self.zoom -= Vector2(0.1, 0.1) * zoom
	if event.is_action_pressed("mwheelup"):
		self.zoom += Vector2(0.1, 0.1) * zoom
	
	if event is InputEventMouseMotion:
		if clicking and canDrag:
			self.global_position -= event.relative / zoom


func set_cam_pos(pos: Vector2):
	self.global_position = pos


func disable_drag():
	canDrag = false
func enable_drag():
	canDrag = true

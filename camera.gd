extends Camera2D

@export var speed: float
var wishDir: Vector2

func _process(delta: float) -> void:
	wishDir.y = Input.get_axis("up", "down")
	wishDir.x = Input.get_axis("left", "right")
	
	self.global_position += wishDir.normalized() * speed

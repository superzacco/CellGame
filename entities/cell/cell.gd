extends Sprite2D
class_name Cell

var cellTexture := preload("res://entities/cell/cell.png")

func _init(size: float, color: Color) -> void:
	self.texture = cellTexture
	self.scale = Vector2(size, size)
	self.modulate = color

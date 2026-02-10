extends Resource
class_name CellData

var cellTexture := preload("res://entities/cell/cell.png")

var cellSize: float
var cellColor: Color


func _init(size: float, color: Color) -> void:
	cellSize = size
	cellColor = color

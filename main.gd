extends Node2D


func _ready() -> void:
	for i in 200:
		spawn_cell()


func spawn_cell():
	var randSize = randf_range(0.1, 0.25)
	var randColor = Color(randf_range(0.0, 1.0), randf_range(0.0, 1.0), randf_range(0.0, 1.0))
	var x = randf_range(-1000.0, 1000.0)
	var y = randf_range(-1000.0, 1000.0)
	
	var cell := Cell.new(randSize, randColor)
	self.add_child(cell)
	cell.global_position += Vector2(x, y)

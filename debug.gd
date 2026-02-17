extends Node

var squareTexture := preload("res://entities/square.png")
var squarePositions = []
func spawn_debug_square(pos: Vector2):
	if squarePositions.has(pos):
		return
	
	var square := Sprite2D.new()
	var gridSize = GameManager.main.grid_cell_size / 33.3
	
	square.texture = squareTexture
	square.global_position = pos
	square.scale = Vector2(gridSize, gridSize)
	square.modulate = Color(1.0, 1.0, 1.0, 0.02)
	square.z_index = 10
	
	self.add_child(square)
	squarePositions.append(square.global_position)
	
	await get_tree().create_timer(0.1).timeout
	kill_square(square)


func kill_square(s:Sprite2D):
	squarePositions.erase(s.global_position)
	s.queue_free()

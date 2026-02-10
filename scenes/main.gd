extends Node2D
class_name Main

@export var amtOfCells: int

@export var grid_cell_size: int
var grid: Dictionary = {}

var cellsAlive: Array[Cell]


func _ready() -> void:
	GameManager.main = self
	
	for i in amtOfCells:
		spawn_cell()


func _physics_process(delta: float) -> void:
	update_grid()





func spawn_cell():
	var randSize = randf_range(0.1, 0.25)
	var randColor = Color(randf_range(0.0, 1.0), randf_range(0.0, 1.0), randf_range(0.0, 1.0))
	var x = randf_range(-5000.0, 5000.0)
	var y = randf_range(-5000.0, 5000.0)
	
	var cellData := CellData.new(randSize, randColor)
	
	var cell := Cell.new(cellData, self)
	$Cells.add_child(cell)
	
	cell.global_position += Vector2(x, y)
	cellsAlive.append(cell)


#region // GRID
func update_grid(): # all this does is put cells into grid pos (no checking) 
	grid.clear()
	
	for cell in cellsAlive:
		var gridPos = _get_grid_position(cell.global_position)
		
		if !grid.has(gridPos):
			grid[gridPos] = []
		
		grid[gridPos].append(cell)
		#Debug.spawn_debug_square(gridPos * grid_cell_size)

func get_nearby_cells(pos: Vector2):
	var centerGridPos = _get_grid_position(pos)
	var nearbyCells = []
	
	for x in range(-1, 2):
		for y in range(-1, 2):
			var key = centerGridPos + Vector2i(x, y)
			
			if grid.has(key):
				nearbyCells.append_array(grid.get(key))
	
	return nearbyCells

func _get_grid_position(position: Vector2) -> Vector2i:
	return Vector2i(
		floor(position.x / grid_cell_size),
		floor(position.y / grid_cell_size)
	)
#endregion

extends Node2D
class_name Main

@export var amtOfCells: int


func _ready() -> void:
	GameManager.main = self
	
	for i in amtOfCells:
		spawn_starting_cell()
	
	var t := Timer.new()
	self.add_child(t)
	
	t.timeout.connect(tick)
	t.one_shot = false
	t.start(0.1)


func _physics_process(delta: float) -> void:
	update_grid()


func tick():
	for cell in cellsAlive:
		cell.currentCellData.update_state()
	
	if randi_range(0, 100) > 92:
		spawn_food()


func spawn_food():
	var f = Food.new(randi_range(10,30))
	self.add_child(f)
	
	var x := randf_range(-1500.0, 1500.0)
	var y := randf_range(-1500.0, 1500.0)
	
	f.z_index = 15
	f.global_position += Vector2(x, y)
	
	activeFood.append(f)




var basic_cell := preload("res://resouces/basic_cell.tres")

func spawn_starting_cell():
	var cell := Cell.new(basic_cell)
	add_cell(cell)
	
	var x := randf_range(-1500.0, 1500.0)
	var y := randf_range(-1500.0, 1500.0)
	
	cell.global_position += Vector2(x, y)


func add_cell(c: Cell):
	$Cells.add_child(c)
	cellsAlive.append(c)


#region // GRID
enum EntityType { CELL , FOOD }

@export var grid_cell_size: int
var grid: Dictionary = {}

var cellsAlive: Array[Cell]
var activeFood: Array[Food]

func update_grid():
	grid.clear()
	
	_add_nearby_entities_to_grid(cellsAlive, EntityType.CELL)
	_add_nearby_entities_to_grid(activeFood, EntityType.FOOD)
	
	for gridPos in grid.keys():
		Debug.spawn_debug_square(gridPos * grid_cell_size)


func _add_nearby_entities_to_grid(entities: Array, type: EntityType) -> void:
	for entity in entities:
		var gridPos = _get_grid_position(entity.global_position)
		
		if !grid.has(gridPos):
			grid[gridPos] =  { EntityType.CELL: [], EntityType.FOOD: [] }
		
		grid[gridPos][type].append(entity)

func get_nearby_entities(pos: Vector2, type: EntityType) -> Array:
	var center = _get_grid_position(pos)
	var result = []
	
	for x in range(-1, 2):
		for y in range(-1, 2):
			var key = center + Vector2i(x, y)
			if grid.has(key):
				result.append_array(grid[key][type])
	
	return result

func _get_grid_position(position: Vector2) -> Vector2i:
	return Vector2i(
		floor(position.x / grid_cell_size),
		floor(position.y / grid_cell_size)
	)
#endregion

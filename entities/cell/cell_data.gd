extends Resource
class_name CellData

@export var cellTexture: CompressedTexture2D


@export var health: float = 10.0
@export var hunger: float = 0.0

@export var generation: int

@export var cellSpeed: float = 1.0
@export var cellSize: float = 1.0

@export var cellColor: Color = Color.WHITE


func mutate_cell(multiplyFactor: float = 1.0):
	cellSpeed *= clamp(randf_range(0.9, 1.1), 0.1, 999.0)
	cellSize *= clamp(randf_range(0.9, 1.1), 0.25, 999.0)
	
	var rX: float = clamp(randf_range(0.9, 1.1), 0.0, 1.0)
	var rY: float = clamp(randf_range(0.9, 1.1), 0.0, 1.0)
	var rZ: float = clamp(randf_range(0.9, 1.1), 0.0, 1.0)
	
	if randi_range(0, 100) > 90: rX += (0.2 / rX) 
	if randi_range(0, 100) > 90: rY += (0.2 / rY)
	if randi_range(0, 100) > 90: rZ += (0.2 / rZ)
	
	cellColor *= Color(rX, rY, rZ)
	
	hunger = 0.0
	generation += 1
	
	print(generation)
	emit_changed()


func update_state():
	hunger += 0.01 * randf_range(0.95, 1.05)
	
	emit_changed()

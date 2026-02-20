extends Resource
class_name CellData

@export var cellTexture: CompressedTexture2D

@export_category("Setup Data")
@export var maxMinSpeed: Vector2
@export var speedSizeCurve: Curve
@export var maxMinSize: Vector2
@export var hungerSizeCurve: Curve
@export var maxMinHungerPerTick: Vector2

@export_category("Game Time Data")
@export var health: float = 10.0
@export var age: float = 0.0
@export var hungerPerTick: float = 0.01
@export var hunger: float = 0.0

@export var generation: int

@export var cellSpeed: float = 1.0
@export var cellSize: float = 1.0
 
@export var cellColor: Color = Color.WHITE



func mutate_cell(multiplyFactor: float = 1.0):
	cellSize *= randf_range(0.8, 1.2) * (hunger+0.8)
	
	cellSpeed = Util.get_inverse(cellSpeed, cellSize, 0.1, maxMinSpeed, speedSizeCurve)
	hungerPerTick = Util.get_inverse(hungerPerTick, cellSize, 0.1, maxMinHungerPerTick, hungerSizeCurve)
	
	var rX: float = clamp(randf_range(0.9, 1.1), 0.0, 1.0)
	var rY: float = clamp(randf_range(0.9, 1.1), 0.0, 1.0)
	var rZ: float = clamp(randf_range(0.9, 1.1), 0.0, 1.0)
	
	if randi_range(0, 100) > 90: rX += (0.2 / rX) 
	if randi_range(0, 100) > 90: rY += (0.2 / rY)
	if randi_range(0, 100) > 90: rZ += (0.2 / rZ)
	
	cellColor *= Color(rX, rY, rZ)
	
	hunger = 0.0
	age = 0.0
	
	generation += 1
	
	#print(generation)
	emit_changed()


func update_state():
	hunger += hungerPerTick * randf_range(0.95, 1.05)
	age += 0.001 * randf_range(0.95, 1.05)
	
	emit_changed()

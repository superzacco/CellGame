extends Sprite2D
class_name Cell

var currentCellData: CellData = null

const maxDistFromCenter: float = 3200.0

var avoidStr: float = 100.0
var avoidanceRadius: float = 100.0
var wanderStr: float = 50.0

var currentState: States = States.WANDER
enum States {
	WANDER,
	EAT
}


var reproductionTimer := Timer.new()
var closestFoodSources = []


func _init(cellData: CellData) -> void:
	currentCellData = cellData.duplicate(true)
	currentCellData.changed.connect(update_cell.bind(currentCellData))
	
	GameManager.add_cell(self)
	self.texture = cellData.cellTexture


func _ready() -> void:
	self.add_child(reproductionTimer)
	
	reproductionTimer.timeout.connect(make_new_cells)
	reproductionTimer.start(randf_range(15, 30))


func update_cell(cellData: CellData):
	var size := Vector2(cellData.cellSize, cellData.cellSize)
	
	self.scale = size * 0.1
	self.modulate = cellData.cellColor
	
	if currentCellData.hunger > 1.0 or currentCellData.age > 1.0:
		kill_cell()
		
	elif currentCellData.hunger > 0.2:
		currentState = States.EAT
	else:
		currentState = States.WANDER
	
	closestFoodSources = GameManager.main.get_nearby_entities(global_position, Main.EntityType.FOOD)


func kill_cell():
	GameManager.remove_cell(self)
	queue_free.call_deferred()
	


var velocity: Vector2
var wishDir: Vector2

var wanderDir: Vector2
var targetDir: Vector2
var avoidanceDir: Vector2
var pushCenter: Vector2

func _physics_process(delta: float) -> void:
	wanderDir = Vector2.ZERO
	targetDir = Vector2.ZERO
	avoidanceDir = Vector2.ZERO
	pushCenter = Vector2.ZERO
	
	velocity *= 0.98
	
	
	if currentState == States.EAT and closestFoodSources.size() > 0:
		var closestFood: Food = get_closest_from(closestFoodSources)
		
		if closestFood == null:
			return
		
		var distanceToFood := closestFood.global_position.distance_to(self.global_position)
		
		targetDir = self.global_position.direction_to(closestFood.global_position)
		if currentCellData.hunger > 0.2 and distanceToFood < 100:
			eat_food(closestFood)
	
	calc_wander_dir()
	calc_push_toward_center()
	calc_avoid_neighbors()
	
	wishDir = ((wanderDir*wanderStr) + (avoidanceDir*avoidStr) + (targetDir * 15) + pushCenter)
	velocity += wishDir * (currentCellData.cellSpeed * 0.005)



func _process(delta: float) -> void:
	self.global_position += velocity

func make_new_cells():
	if currentCellData.hunger > 0.2:
		return
	
	for i in randi_range(1,2):
		var cellData = currentCellData.duplicate(true) 
		cellData.mutate_cell()
		
		var newCell := Cell.new(cellData)
		
		newCell.global_position = self.global_position + Vector2(randf_range(-5, 5), randf_range(-5, 5))


func eat_food(food: Food):
	food.get_eaten()
	currentCellData.hunger = 0.0



func get_closest_from(array: Array):
	var closestDist := INF
	var closest = null
	
	for item in array:
		if item == null:
			return
		
		var dist = item.global_position.distance_to(self.global_position)
		if dist < closestDist:
			closestDist = dist
			closest = item
	
	return closest


func calc_wander_dir():
	var wanderNoise := Vector2(randf_range(-0.25, 0.25), randf_range(-0.25, 0.25))
	wanderDir = Vector2(wanderDir + wanderNoise).normalized()


func calc_push_toward_center():
	var distToCenter := self.global_position.distance_to(Vector2(0,0))
	#var distNormalized = (distToCenter / distToCenter) - 0.5
	
	if distToCenter > maxDistFromCenter:
		var away = (self.global_position - Vector2(0,0)).normalized()
		pushCenter += -away * (distToCenter - maxDistFromCenter)


func calc_avoid_neighbors():
	for n in GameManager.main.get_nearby_entities(self.global_position, Main.EntityType.CELL):
		if n == self: continue
		
		var dist = self.global_position.distance_to(n.global_position)
		
		if dist < avoidanceRadius:
			var away = (self.global_position - n.global_position).normalized()
			avoidanceDir += (away / (dist * 0.1))

extends Sprite2D
class_name Food

const maxDistFromCenter: float = 3200.0

const foodAvoidStr: float = 2.0
const foodAvoidanceRadius = 50.0

const cellAvoidStr: float = 0.25
const cellAvoidanceRadius: float = 50.0

const congealStr: float = 0.01
const congealRadius: float = 600.0

var amtOfFood: int = 0:
	set(v):
		amtOfFood = v
		
		if amtOfFood <= 0:
			GameManager.main.activeFood.erase(self)
			queue_free()
		
		scale = Vector2(amtOfFood+2, amtOfFood+2) * 0.02


func _init(amt: int) -> void:
	amtOfFood = amt
	
	self.texture = load("res://entities/cell/cell.png")
	self.modulate = Color.WEB_GREEN





var velocity: Vector2
var wishDir: Vector2

var foodAvoidanceDir: Vector2
var cellAvoidanceDir: Vector2
var congealDir: Vector2
var pushCenter: Vector2

func _physics_process(delta: float) -> void:
	foodAvoidanceDir = Vector2.ZERO
	cellAvoidanceDir = Vector2.ZERO
	congealDir = Vector2.ZERO
	pushCenter = Vector2.ZERO
	
	velocity *= 0.9
	
	calc_push_toward_center()
	calc_congeal_food()
	calc_avoid_food()
	calc_avoid_cells()
	
	wishDir = ((cellAvoidanceDir*cellAvoidStr) + (foodAvoidanceDir*foodAvoidStr) + (congealDir*congealStr) + pushCenter)
	velocity += wishDir 



func _process(delta: float) -> void:
	self.global_position += velocity



func get_eaten():
	amtOfFood -= 1




func calc_push_toward_center():
	var distToCenter := self.global_position.distance_to(Vector2(0,0))
	
	if distToCenter > maxDistFromCenter:
		var away = (self.global_position - Vector2(0,0)).normalized()
		pushCenter += -away * (distToCenter - maxDistFromCenter)


func calc_congeal_food():
	var foodNearby = GameManager.main.get_nearby_entities(self.global_position, Main.EntityType.FOOD)
	if foodNearby.size() <= 0:
		return
	
	for food: Food in foodNearby:
		if food == self: continue
		
		var dist = self.global_position.distance_to(food.global_position)
		if dist < congealRadius:
			
			congealDir += (food.global_position-self.global_position) / foodNearby.size()
	congealDir /= foodNearby.size()


func calc_avoid_cells():
	for n in GameManager.main.get_nearby_entities(self.global_position, Main.EntityType.CELL):
		if n == self: continue
		
		var dist = self.global_position.distance_to(n.global_position)
		if dist < cellAvoidanceRadius:
			var away = (self.global_position - n.global_position).normalized()
			cellAvoidanceDir += (away / (dist * 0.1))


func calc_avoid_food():
	for n in GameManager.main.get_nearby_entities(self.global_position, Main.EntityType.FOOD):
		if n == self: continue
		
		var dist = self.global_position.distance_to(n.global_position)
		if dist < foodAvoidanceRadius:
			var away = (self.global_position - n.global_position).normalized()
			foodAvoidanceDir += (away / (dist * 0.1))

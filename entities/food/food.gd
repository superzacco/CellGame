extends Sprite2D
class_name Food

const maxDistFromCenter: float = 1600.0
const avoidStr: float = 0.2
const avoidanceRadius: float = 150.0

var amtOfFood: int = 0


func _init(amt: int) -> void:
	amtOfFood = amt
	
	self.texture = load("res://entities/cell/cell.png")
	
	self.modulate = Color.WEB_GREEN
	self.scale = Vector2(amt, amt) * 0.02





var velocity: Vector2
var wishDir: Vector2

var avoidanceDir: Vector2
var pushCenter: Vector2

func _physics_process(delta: float) -> void:
	avoidanceDir = Vector2.ZERO
	pushCenter = Vector2.ZERO
	
	velocity *= 0.98
	
	calc_push_toward_center()
	calc_avoid_neighbors()
	
	wishDir = ((avoidanceDir*avoidStr) + pushCenter)
	velocity += wishDir 



func _process(delta: float) -> void:
	self.global_position += velocity



func get_eaten():
	amtOfFood -= 1
	scale = Vector2(amtOfFood, amtOfFood) * 0.02
	
	if amtOfFood <= 0:
		GameManager.main.activeFood.erase(self)
		queue_free()




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

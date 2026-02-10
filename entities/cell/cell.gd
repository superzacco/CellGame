extends Sprite2D
class_name Cell


var main: Main = null

const avoidStr: float = 100.0
const wanderStr: float = 50.0

const speed: float = 0.01
const avoidanceRadius: float = 100.0
const maxDistFromCenter: float = 1600.0

func _init(cellData: CellData, m: Main) -> void:
	var size := Vector2(cellData.cellSize, cellData.cellSize)
	
	self.main = m
	
	self.scale = size
	self.modulate = cellData.cellColor
	self.texture = cellData.cellTexture



var velocity: Vector2
var wishDir: Vector2

var wanderDir: Vector2
var avoidanceDir: Vector2
var pushCenter: Vector2

func _physics_process(delta: float) -> void:
	wanderDir = Vector2.ZERO
	avoidanceDir = Vector2.ZERO
	pushCenter = Vector2.ZERO
	
	velocity *= 0.99
	
	var wanderNoise := Vector2(randf_range(-0.25, 0.25), randf_range(-0.25, 0.25))
	wanderDir = Vector2(wanderDir + wanderNoise).normalized()
	
	calc_push_toward_center()
	calc_avoid_neighbors()
	
	wishDir = ((wanderDir*wanderStr) + (avoidanceDir*avoidStr) + pushCenter)
	velocity += wishDir * speed



func _process(delta: float) -> void:
	self.global_position += velocity


func calc_push_toward_center():
	var distToCenter := self.global_position.distance_to(Vector2(0,0))
	#var distNormalized = (distToCenter / distToCenter) - 0.5
	
	if distToCenter > maxDistFromCenter:
		var away = (self.global_position - Vector2(0,0)).normalized()
		pushCenter += -away * (distToCenter - maxDistFromCenter)


func calc_avoid_neighbors():
	for n in main.get_nearby_cells(self.global_position):
		if n == self: continue
		
		var dist = self.global_position.distance_to(n.global_position)
		
		if dist < avoidanceRadius:
			var away = (self.global_position - n.global_position).normalized()
			avoidanceDir += (away / (dist * 0.1))

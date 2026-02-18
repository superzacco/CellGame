extends Control

@export var tl: Control
@export var tr: Control
@export var br: Control
@export var bl: Control

@export var max: Label
@export var min: Label

var populationHistory: Array[float] = []
 
var maxRange: float
var minRange: float

var ticksProcessed: int = 0
var slicesToShow: int = 10

var N: Node2D

func _ready() -> void:
	N = Node2D.new()
	self.add_child(N)

func _draw() -> void:
	maxRange = 0.0
	for v in populationHistory:
		maxRange = max(maxRange, v)
	
	max.text = "%s" % snapped(maxRange, 0.1)
	min.text = "0"
	
	for i in range(populationHistory.size()-1):
		var vA = populationHistory[i]
		var vB = populationHistory[i+1]
		
		var startPoint = Vector2(get_x_point(i), get_y_point(vA))
		var endPoint = Vector2(get_x_point(i+1), get_y_point(vB))
		
		draw_line(startPoint, endPoint, Color.WHITE, 5)

 
func get_x_point(linesArrayIdx: int):
	var t = float(linesArrayIdx) / float(slicesToShow - 1)
	
	var leftExtent = bl.global_position.x - 300
	var rightExtent = br.global_position.x - 1300
	
	return lerp(leftExtent, rightExtent, t)

func get_y_point(val: float) -> float:
	var middleNormalized = val / maxRange
	
	var topExtent = tr.global_position.y - 150
	var bottomExtent = br.global_position.y -800
	
	return lerp(bottomExtent, topExtent, middleNormalized)


func _on_redraw_timeout() -> void:
	var cellAmt = GameManager.allCells.size() * 1.5
	populationHistory.append(cellAmt)
	
	if populationHistory.size() > slicesToShow:
		populationHistory.remove_at(0)
	
	queue_redraw()

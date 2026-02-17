extends Control
class_name ContextMenu # should be stationary -- just a little line pointing to the cell's position


var currentCell: Cell = null

@export var size_text: Label
@export var speed_text: Label
@export var color_text: Label
@export var hunger_text: Label
@export var current_state: Label
@export var generation: Label


func _ready() -> void:
	SignalBus.show_context_menu.connect(show_context_menu)


func show_context_menu(cell: Cell):
	show()
	currentCell = cell
	var cData: CellData = currentCell.currentCellData
	
	size_text.text = "Size: %s" % cData.cellSize
	speed_text.text = "Speed: %s" % cData.cellSpeed
	color_text.text = "Color: %s" % cData.cellColor
	hunger_text.text = "Hunger: %s" % cData.hunger
	current_state.text = "State: %s" % cell.States.find_key(cell.currentState)
	generation.text = "Generation: %s" % cData.generation
	


func _process(delta: float) -> void:
	if currentCell != null:
		global_position = currentCell.global_position


func _physics_process(delta: float) -> void:
	if currentCell != null:
		show_context_menu(currentCell)

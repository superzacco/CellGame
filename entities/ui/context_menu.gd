extends Control
class_name ContextMenu # should be stationary -- just a little line pointing to the cell's position


var currentCell: Cell = null
var followingCell := false

@export var size_text: Label
@export var speed_text: Label
@export var color_text: Label
@export var hunger_text: Label
@export var current_state: Label
@export var generation: Label
@export var age: Label


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		close_menu()


func _ready() -> void:
	SignalBus.show_context_menu.connect(show_context_menu)


func close_menu():
	followingCell = false
	self.hide()


func show_context_menu(cell: Cell):
	show()
	currentCell = cell
	var cData: CellData = currentCell.currentCellData
	
	size_text.text = "Size: %s" % cData.cellSize
	speed_text.text = "Speed: %s" % cData.cellSpeed
	color_text.text = "Color: %s" % cData.cellColor
	hunger_text.text = "Hunger: %s / PT: %s" % [snapped(cData.hunger, 0.01), snapped(cData.hungerPerTick, 0.00001)]
	current_state.text = "State: %s" % cell.States.find_key(cell.currentState)
	generation.text = "Generation: %s" % cData.generation
	age.text = "Age: %s" % cData.age
	


func _process(delta: float) -> void:
	if currentCell != null:
		global_position = currentCell.global_position
		
		if followingCell == true:
			SignalBus.set_cam_pos.emit(currentCell.global_position)


func _physics_process(delta: float) -> void:
	if currentCell != null:
		show_context_menu(currentCell)


func _on_focusbutton_pressed() -> void:
	if currentCell != null:
		followingCell = true

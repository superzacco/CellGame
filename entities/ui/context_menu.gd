extends Control
class_name ContextMenu # should be stationary -- just a little line pointing to the cell's position


var currentCell: Cell = null


func _ready() -> void:
	SignalBus.show_context_menu.connect(show_context_menu)


func show_context_menu(cell: Cell):
	show()
	currentCell = cell

func _process(delta: float) -> void:
	if currentCell != null:
		global_position = currentCell.global_position

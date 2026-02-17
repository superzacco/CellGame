extends Node2D


var dragDifference := Vector2.ZERO

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		dragDifference += event.relative
	
	if event.is_action_pressed("mouse0"):
		dragDifference = Vector2.ZERO
	
	if event.is_action_released("mouse0"):
		var clickPos = get_global_mouse_position()
		var cellsInChunk = GameManager.main.get_nearby_entities(clickPos, Main.EntityType.CELL)
		var closestCell := return_closest_cell(cellsInChunk, clickPos)
		
		if closestCell != null and !dragDifference.length() > 10:
			SignalBus.show_context_menu.emit(closestCell)


func return_closest_cell(array: Array, pos: Vector2) -> Cell:
	var closestDist := INF
	var closestCell = null
	
	for cell: Cell in array:
		var dist = cell.global_position.distance_to(pos)
		if dist < closestDist:
			closestDist = dist
			closestCell = cell
	
	return closestCell

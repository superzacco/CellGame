extends Node

var main: Main = null

var allCells: Array[Cell]


func add_cell(cell: Cell):
	allCells.append(cell)
	main.add_cell(cell)


func remove_cell(cell: Cell):
	allCells.erase(cell)
	main.remove_cell(cell)

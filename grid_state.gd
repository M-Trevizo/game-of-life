class_name GridState
extends Node

var grid: Dictionary


func _init() -> void:
	grid = {}


func _update_neighbors(grid_square: GridSquare) -> void:
	var neighbors: Array[Vector2i] = grid_square.get_neighbors()
	for cell in neighbors:
		if grid.has(cell):
			grid[cell].num_of_alive_neighbors += 1
		else:
			grid[cell] = GridSquare.new(cell, false)


func append(grid_square: GridSquare) -> void:
	grid[grid_square.location] = grid_square
	_update_neighbors(grid_square)

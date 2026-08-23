class_name GridSquare
extends Object

var location: Vector2i
var is_alive: bool
var num_of_alive_neighbors: int


func _init(p_location: Vector2i, p_is_alive: bool) -> void:
	location = p_location
	is_alive = p_is_alive
	num_of_alive_neighbors = 0


func get_neighbors() -> Array[Vector2i]:
	var neighbors: Array[Vector2i] = []
	neighbors.append(location + Vector2i.UP)
	neighbors.append(location + Vector2i.DOWN)
	neighbors.append(location + Vector2i.LEFT)
	neighbors.append(location + Vector2i.RIGHT)
	neighbors.append(location + Vector2i(-1, -1))
	neighbors.append(location + Vector2i(1, -1))
	neighbors.append(location + Vector2i(-1, 1))
	neighbors.append(location + Vector2i(1, 1))
	return neighbors

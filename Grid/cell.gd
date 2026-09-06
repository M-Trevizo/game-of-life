class_name Cell
extends Object

var location: Vector2i
var is_alive: bool
var num_of_alive_neighbors: int:
	set(new_value):
		if new_value >= 0 or new_value <= 8:
			num_of_alive_neighbors = new_value
		elif new_value < 0:
			num_of_alive_neighbors = 0
		else:
			num_of_alive_neighbors = 8


func _init(p_location: Vector2i, p_is_alive: bool) -> void:
	location = p_location
	is_alive = p_is_alive
	num_of_alive_neighbors = 0

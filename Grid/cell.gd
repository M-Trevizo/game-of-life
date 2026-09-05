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


#func count_live_neighbors() -> int:
	#var count: int = 0
	#var neighbors: Array[Vector2i] = get_neighbors()
	#for cell in neighbors:
		#if alive_tile_atlas_coords == tilemap_layer.get_cell_atlas_coords(cell):
			#count += 1
	#return count
#
#
#func get_neighbors() -> Array[Vector2i]:
	#var neighbors: Array[Vector2i] = []
	#neighbors.append(location + Vector2i.UP)
	#neighbors.append(location + Vector2i.DOWN)
	#neighbors.append(location + Vector2i.LEFT)
	#neighbors.append(location + Vector2i.RIGHT)
	#neighbors.append(location + Vector2i(-1, -1))
	#neighbors.append(location + Vector2i(1, -1))
	#neighbors.append(location + Vector2i(-1, 1))
	#neighbors.append(location + Vector2i(1, 1))
	#return neighbors

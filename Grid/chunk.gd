class_name Chunk
extends Node2D
## Handles all chunk related functionality
##
## Represents a square "chunk" of the grid space.
## Acts as both an instance of each chunk and containes all static variables
## and static functions needed to handle chunks.


## Sides of the chunk.
enum Sides {
	UP,
	DOWN,
	LEFT,
	RIGHT,
}

## Number of cells the chunk wide
const CHUNK_WIDTH_CELL: int = 10
## Side length of each chunk in pixels.
const CHUNK_WIDTH_PIXEL: int = CHUNK_WIDTH_CELL * 50
## Total number of cells in each chunk.
const NUM_CELLS: int = CHUNK_WIDTH_CELL ** 2


## Dictionary of all chunks created
static var chunks: Dictionary[int, Chunk] = {}
static var chunk_scene: PackedScene = preload("uid://dbffxqi58ld0")
static var next_chunk_id: int = 0:
	get:
		var current_chunk_id: int = next_chunk_id
		next_chunk_id += 1
		return current_chunk_id
static var tile_source_id: int = 1
static var alive_tile_atlas_coords := Vector2i(1, 0)
static var dead_tile_atlas_coords := Vector2i(0, 0)

## Chunk ID
var id: int
## The pseudo location of the chunk given in relation to chunk origin (0, 0)
var location: Vector2i
## Whether the chunk contains the mouse or not.
var contains_mouse: bool
## List of cells that are currently alive and the number of live neighbors.
var cells: Dictionary[Vector2i, Cell]

@onready var tilemap_layer: TileMapLayer = $TileMapLayer


## Creates a new chunk at the given global position
## Should always be used to create a new chunk instead of [method Object.new]
static func create(pos: Vector2i) -> Chunk:
	var instance: Chunk = chunk_scene.instantiate()
	instance.id = next_chunk_id
	instance.position = pos
	instance.location = Vector2i(pos.x / CHUNK_WIDTH_PIXEL, pos.y / CHUNK_WIDTH_PIXEL)
	instance.init_cells()
	chunks[instance.id] = instance
	return instance


## Creates a number of new chunks given by [param num_of_chunks]. [br]
## Returns an array of chunks to be added as child nodes.
static func generate_chunks(num_of_chunks: int, entered_from: Sides, chunk: Chunk) -> Array[Chunk]:
	var chunk_arr: Array[Chunk] = []
	var chunk_location: Vector2i = chunk.location
	match entered_from:
		Sides.UP: 
			chunk_location += Vector2i(-1, 1)
		Sides.RIGHT: 
			chunk_location += Vector2i(-1, -1)
		Sides.DOWN: 
			chunk_location += Vector2i(-1, -1)
		Sides.LEFT:
			chunk_location += Vector2i(1, -1)
	for i in range(num_of_chunks):
		# Convert starting_pos from relative grid location to global coords
		var global_pos: Vector2i = relative_to_global(chunk_location)
		# Check if a chunk already exists at a givent position
		# If it does, add that instance to the return array
		var does_exist: bool = false
		for chunk_instance: Chunk in chunks.values():
			if chunk_instance.location == chunk_location:
				chunk_arr.append(chunk_instance)
				does_exist = true
				break
		# If chunk does not already exist create a new one and add it to the return arr
		if not does_exist:
			chunk_arr.append(create(global_pos))
		if entered_from == Sides.UP or entered_from == Sides.DOWN:
			chunk_location.x += 1
		else:
			chunk_location.y += 1
	return chunk_arr
	

## Returns an array of chunks to hide. [br]
## Does [b]NOT[/b] free chunks, as doing so would remove them and their state from memory.
static func free_chunks(num_of_chunks:int, entered_from: Sides, chunk: Chunk) -> Array[Chunk]:
	var chunk_arr: Array[Chunk] = []
	var chunk_location: Vector2i = chunk.location
	match entered_from:
		Sides.UP: 
			chunk_location += Vector2i(-1, -2)
		Sides.RIGHT: 
			chunk_location += Vector2i(2, -1)
		Sides.DOWN: 
			chunk_location += Vector2i(-1, 2)
		Sides.LEFT:
			chunk_location += Vector2i(-2, -1)
	for i in range(num_of_chunks):
		# Convert starting_pos from relative grid location to global coords
		chunk_arr.append(get_chunk_by_loc(chunk_location))
		if entered_from == Sides.UP or entered_from == Sides.DOWN:
			chunk_location.x += 1
		else:
			chunk_location.y += 1
	return chunk_arr


## Returns the chunk with the given [member id] or [code]null[/code] if none exist.
static func get_chunk_by_id(chunk_id: int) -> Chunk:
	return chunks.get(chunk_id)


## Returns the chunk with the given [member location] or [code]null[/code] if none exist.
static func get_chunk_by_loc(chunk_loc: Vector2i) -> Chunk:
	for chunk: Chunk in chunks.values():
		if chunk.location == chunk_loc:
			return chunk
	return null


## Converts a chunks chunk-grid location to a global position.
## Takes [member location] as argument
static func relative_to_global(chunk_location: Vector2i) -> Vector2i:
	return Vector2i(chunk_location.x * CHUNK_WIDTH_PIXEL, chunk_location.y * CHUNK_WIDTH_PIXEL)


## Flips a tile from a dead tile to an alive tile and vice versa.
## Then marks the cell as dead or alive accordingly.
func flip_cell(map_pos: Vector2i) -> void:
	var cell: Cell = cells.get(map_pos)
	if not cell.is_alive:
		tilemap_layer.set_cell(map_pos, tile_source_id, alive_tile_atlas_coords)
		cell.is_alive = true
	else:
		tilemap_layer.set_cell(map_pos, tile_source_id, dead_tile_atlas_coords)
		cell.is_alive = false


## Updates the number of living neighbors for the cell at [param cell_pos].
func update_cell(cell_pos: Vector2i) -> void:
	var cell: Cell = cells.get(cell_pos)
	cell.num_of_alive_neighbors = _count_live_neighbors(cell)


## Initialize [member cells] with dead cells
func init_cells() -> void:
	for y in range(10):
		for x in range(10):
			cells.set(Vector2i(x, y), Cell.new(Vector2i(x, y), false))


## Returns the number of living neighboring cells of the cell at [param cell_pos]
func _count_live_neighbors(cell: Cell) -> int:
	var count: int = 0
	var neighbors: Array[Vector2i] = _get_cell_neighbors(cell.location)
	# Checks neighboring chunks when needed
	# It's not pretty though
	for neighbor in neighbors:
		var neighbor_cell: Cell = null
		var neighbor_is_alive: bool = false
		if neighbor.x < 0: # Left side chunks
			if neighbor.y < 0: # UL chunk
				var neighbor_chunk: Chunk = get_chunk_by_loc(location + Vector2i(-1, -1))
				if neighbor_chunk:
					neighbor_cell = neighbor_chunk.cells.get(Vector2i(9, 9))
					neighbor_is_alive = neighbor_cell.is_alive
			elif neighbor.y >= CHUNK_WIDTH_CELL: # LR chunk
				var neighbor_chunk: Chunk = get_chunk_by_loc(location + Vector2i(-1, 1))
				if neighbor_chunk:
					neighbor_cell = neighbor_chunk.cells.get(Vector2i(9, 0))
					neighbor_is_alive = neighbor_cell.is_alive
			else: # Left chunk
				var neighbor_chunk: Chunk = get_chunk_by_loc(location + Vector2i(-1, 0))
				if neighbor_chunk:
					neighbor_cell = neighbor_chunk.cells.get(Vector2i(9, neighbor.y))
					neighbor_is_alive = neighbor_cell.is_alive
		elif neighbor.x >= CHUNK_WIDTH_CELL: # Right side chunks
			if neighbor.y < 0: # UR chunk
				var neighbor_chunk: Chunk = get_chunk_by_loc(location + Vector2i(1, -1))
				if neighbor_chunk:
					neighbor_cell = neighbor_chunk.cells.get(Vector2i(0, 9))
					neighbor_is_alive = neighbor_cell.is_alive
			elif neighbor.y >= CHUNK_WIDTH_CELL: # LR chunk
				var neighbor_chunk: Chunk = get_chunk_by_loc(location + Vector2i(1, 1))
				if neighbor_chunk:
					neighbor_cell = neighbor_chunk.cells.get(Vector2i(0, 0))
					neighbor_is_alive = neighbor_cell.is_alive
			else: # Right chunk
				var neighbor_chunk: Chunk = get_chunk_by_loc(location + Vector2i(1, 0))
				if neighbor_chunk:
					neighbor_cell = neighbor_chunk.cells.get(Vector2i(0, neighbor.y))
					neighbor_is_alive = neighbor_cell.is_alive
		elif neighbor.y < 0: # Top chunk
			var neighbor_chunk: Chunk = get_chunk_by_loc(location + Vector2i(0, -1))
			if neighbor_chunk:
				neighbor_cell = neighbor_chunk.cells.get(Vector2i(neighbor.x, 9))
				neighbor_is_alive = neighbor_cell.is_alive
		elif neighbor.y >= CHUNK_WIDTH_CELL: # Top chunk
			var neighbor_chunk: Chunk = get_chunk_by_loc(location + Vector2i(0, 1))
			if neighbor_chunk:
				neighbor_cell = neighbor_chunk.cells.get(Vector2i(neighbor.x, 0))
				neighbor_is_alive = neighbor_cell.is_alive
		else: # Current chunk
			neighbor_cell = cells.get(neighbor)
			neighbor_is_alive = neighbor_cell.is_alive
		
		if neighbor_cell and neighbor_is_alive:
			count += 1
	return count


## Returns the position of all neighboring cells
func _get_cell_neighbors(cell_pos: Vector2i) -> Array[Vector2i]:
	var neighbors: Array[Vector2i] = tilemap_layer.get_surrounding_cells(cell_pos)
	neighbors.append(cell_pos + Vector2i(-1, -1)) # Upper Left
	neighbors.append(cell_pos + Vector2i(1, -1)) # Upper Right
	neighbors.append(cell_pos + Vector2i(-1, 1)) # Lower Left
	neighbors.append(cell_pos + Vector2i(1, 1)) # Lower Righ
	return neighbors


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and contains_mouse:
			var local_pos: Vector2 = to_local(get_global_mouse_position())
			var map_pos: Vector2i = tilemap_layer.local_to_map(local_pos)
			flip_cell(map_pos)


func _on_mouse_entered() -> void:
	contains_mouse = true


func _on_mouse_exited() -> void:
	contains_mouse = false

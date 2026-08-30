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

## Side length of each chunk.
const CHUNK_WIDTH: int = 10 * 50

## Dictionary of all chunks created
static var chunks: Dictionary = {}
static var chunk_scene: PackedScene = preload("uid://dbffxqi58ld0")
static var next_chunk_id: int = 0:
	get:
		var current_chunk_id: int = next_chunk_id
		next_chunk_id += 1
		return current_chunk_id
static var tile_source_id: int = 1
static var alive_tile_atlas_coords := Vector2i(1, 0)
static var dead_tile_atlas_coords := Vector2i(0, 0)

var id: int

## The pseudo location of the chunk given in relation to chunk origin (0, 0)
var location: Vector2i
var contains_mouse: bool

## List of cells that are currently alive
var active_cells: Array[Vector2i]

@onready var tilemap_layer: TileMapLayer = $TileMapLayer


## Creates a new chunk at the given global position
## Should always be used to create a new chunk instead of [method Object.new]
static func create(pos: Vector2i) -> Chunk:
	var instance: Chunk = chunk_scene.instantiate()
	instance.id = next_chunk_id
	instance.position = pos
	instance.location = Vector2i(pos.x / CHUNK_WIDTH, pos.y / CHUNK_WIDTH)
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
		#var global_pos: Vector2i = relative_to_global(chunk_location)
		chunk_arr.append(get_chunk_by_loc(chunk_location))
		if entered_from == Sides.UP or entered_from == Sides.DOWN:
			chunk_location.x += 1
		else:
			chunk_location.y += 1
	return chunk_arr


## Returns the chunk with the given [member id] or [code]null[/code] if none exist.
static func get_chunk_by_id(chunk_id: int) -> Chunk:
	return chunks.get(chunk_id)


static func get_chunk_by_loc(chunk_loc: Vector2i) -> Chunk:
	for chunk: Chunk in chunks.values():
		if chunk.location == chunk_loc:
			return chunk
	return null

## Converts a chunks chunk-grid location to a global position.
## Takes [member location] as argument
static func relative_to_global(chunk_location: Vector2i) -> Vector2i:
	return Vector2i(chunk_location.x * CHUNK_WIDTH, chunk_location.y * CHUNK_WIDTH)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and contains_mouse:
			var local_pos: Vector2 = to_local(get_global_mouse_position())
			var map_pos: Vector2i = tilemap_layer.local_to_map(local_pos)
			_flip_cell(map_pos)


func _flip_cell(map_pos: Vector2i) -> void:
	if dead_tile_atlas_coords == tilemap_layer.get_cell_atlas_coords(map_pos):
		tilemap_layer.set_cell(map_pos, tile_source_id, alive_tile_atlas_coords)
		active_cells.append(map_pos)
	else:
		tilemap_layer.set_cell(map_pos, tile_source_id, dead_tile_atlas_coords)
		active_cells.erase(map_pos)


func _on_mouse_entered() -> void:
	contains_mouse = true


func _on_mouse_exited() -> void:
	contains_mouse = false

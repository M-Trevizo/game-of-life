class_name Chunk
extends Node2D
## Handles all chunk related functionality
##
## Represents a square "chunk" of the grid space.
## Acts as both an instance of each chunk and containes all static variables
## and static functions needed to handle chunks.


#signal generate_chunks(chunk_pos: Vector2i, num_chunks: int)

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


static func generate_chunks(num_of_chunks: int, side: Sides, starting_pos: Vector2i) -> Array[Chunk]:
	var chunks: Array[Chunk] = []
	for i in range(num_of_chunks):
		match side:
			Sides.UP: 
				pass
			Sides.RIGHT: 
				pass
			Sides.DOWN: 
				pass
			Sides.LEFT:
				pass
				#create(starting_pos)
	return chunks


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and contains_mouse:
			var local_pos: Vector2 = to_local(get_global_mouse_position())
			var map_pos: Vector2i = tilemap_layer.local_to_map(local_pos)
			_flip_cell(map_pos)
			#print(map_pos)
			#print(active_cells)


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


func _on_left_area_entered(area: Area2D) -> void:
	print("Entered Left area of chunk id: " + str(id))
	# Get position of chunk that we enter
	# Generate chunks starting at appropriate pos offset 
	# This should generate a new row or column depending on area entered
	generate_chunks(1, Sides.LEFT, position)


func _on_left_area_exited(area: Area2D) -> void:
	print("Exited Left area of chunk id: " + str(id))


func _on_right_area_entered(area: Area2D) -> void:
	print("Entered Right area of chunk id: " + str(id))


func _on_right_area_exited(area: Area2D) -> void:
	print("Exited Right area of chunk id: " + str(id))


func _on_up_area_entered(area: Area2D) -> void:
	print("Entered Up area of chunk id: " + str(id))


func _on_up_area_exited(area: Area2D) -> void:
	print("Exited Up area of chunk id: " + str(id))


func _on_down_area_entered(area: Area2D) -> void:
	print("Entered Down area of chunk id: " + str(id))


func _on_down_area_exited(area: Area2D) -> void:
	print("Exited Down area of chunk id: " + str(id))

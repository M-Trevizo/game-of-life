extends Node2D

const MAX_CAM_SPEED: int = 800
const MIN_CAM_SPEED: int = 200

var grid_state: GridState
var global_grid_coords: Vector2
var chunk_scene: PackedScene = preload("uid://dbffxqi58ld0")

@onready var hud: HUD = $HUD
@onready var player: Player = $Player

func _ready() -> void:
	grid_state = GridState.new()
	global_grid_coords = Vector2.ZERO
	_generate_starting_chunks()
	_position_player()
	hud.update_speed_label(player.speed)
	hud.update_zoom_label(player.camera.zoom.x)


func _process(_delta: float) -> void:
	pass


func _generate_starting_chunks() -> void:
	var chunk_size := Vector2i(10 * 50, 10 * 50)
	var pos := Vector2i.ZERO - chunk_size
	var x_start: int = pos.x
	for i in range(9):
		if i != 0 and i % 3 == 0:
			pos.y += chunk_size.y
			pos.x = x_start
		var chunk: Chunk = Chunk.create(pos)
		add_child(chunk)
		pos.x += chunk_size.x


func _on_player_speed_changed(value: int) -> void:
	hud.update_speed_label(value)


func _on_player_zoom_changed(value: float) -> void:
	hud.update_zoom_label(value)


func _position_player() -> void:
	var chunk_size := Vector2i(10 * 50, 10 * 50)
	var center: Vector2i = (Vector2i.ZERO + chunk_size) / 2.0
	player.position = center


func _on_player_chunk_id_changed(chunk_side: Chunk.Sides, chunk_id: int) -> void:
	var chunk: Chunk = Chunk.get_chunk(chunk_id)
	var chunks: Array[Chunk] = Chunk.generate_chunks(3, chunk_side, chunk)
	for instance in chunks:
		call_deferred("add_child", instance)

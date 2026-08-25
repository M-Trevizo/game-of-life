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


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			#var tile_pos: Vector2 = tile_map_layer.to_local(event.global_position)
			#var tile_pos: Vector2i = tile_map_layer.local_to_map(event.position)
			print("Node2D global pos: " + str(global_position))
			print("Node2D pos: " + str(position))


func _generate_starting_chunks() -> void:
	var chunk_size := Vector2i(10 * 50, 10 * 50)
	var pos := Vector2i.ZERO - chunk_size
	var x_start = pos.x
	for i in range(9):
		if i != 0 and i % 3 == 0:
			pos.y += chunk_size.y
			pos.x = x_start
		var instance: Node2D = chunk_scene.instantiate()
		instance.position = pos
		add_child(instance)
		pos.x += chunk_size.x


func _on_player_speed_changed(value: int) -> void:
	hud.update_speed_label(value)


func _on_player_zoom_changed(value: float) -> void:
	hud.update_zoom_label(value)


func _position_player() -> void:
	var chunk_size := Vector2i(10 * 50, 10 * 50)
	var center: Vector2i = (Vector2i.ZERO + chunk_size) / 2.0
	player.position = center

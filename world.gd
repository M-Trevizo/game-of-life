extends Node2D

@export var camera_speed: int:
	set(new_value):
		if new_value > MAX_CAM_SPEED:
			camera_speed = MAX_CAM_SPEED
		elif new_value < MIN_CAM_SPEED:
			camera_speed = MIN_CAM_SPEED
		else:
			camera_speed = new_value

@onready var camera: Camera2D = $Camera2D

const MAX_CAM_SPEED: int = 800
const MIN_CAM_SPEED: int = 200

var grid_state: GridState
var global_grid_coords: Vector2
var chunk_scene: PackedScene = preload("uid://dbffxqi58ld0")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	grid_state = GridState.new()
	global_grid_coords = Vector2.ZERO
	_generate_starting_chunks()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_handle_cam_movement(delta)
	_handle_cam_zoom()
	_handle_cam_speed()


func _handle_cam_movement(delta: float) -> void:
	var velocity = Input.get_vector("cam_left", "cam_right", "cam_up", "cam_down") * camera_speed
	camera.position += velocity * delta


func _handle_cam_zoom() -> void:
	if Input.is_action_just_pressed("zoom_in") and camera.zoom <= Vector2(1.7, 1.7):
		camera.zoom += Vector2(0.1, 0.1)
	if Input.is_action_just_pressed("zoom_out") and camera.zoom >= Vector2(0.4, 0.4):
		camera.zoom -= Vector2(0.1, 0.1)


func _handle_cam_speed() -> void:
	if Input.is_action_just_pressed("inc_cam_speed"):
		camera_speed += 50
	if Input.is_action_just_pressed("dec_cam_speed"):
		camera_speed -= 50


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

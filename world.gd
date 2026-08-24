extends Node2D

@export var camera_speed: int = 100

@onready var camera: Camera2D = $Camera2D
@onready var tile_map_layer: TileMapLayer = $TileMapLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_handle_cam_movement(delta)
	_handle_cam_zoom()

func _handle_cam_movement(delta: float) -> void:
	var velocity = Input.get_vector("cam_left", "cam_right", "cam_up", "cam_down") * camera_speed
	camera.position += velocity * delta


func _handle_cam_zoom() -> void:
	if Input.is_action_just_pressed("zoom_in") and camera.zoom <= Vector2(1.7, 1.7):
		camera.zoom += Vector2(0.1, 0.1)
	if Input.is_action_just_pressed("zoom_out") and camera.zoom >= Vector2(0.4, 0.4):
		camera.zoom -= Vector2(0.1, 0.1)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			#var tile_pos: Vector2 = tile_map_layer.to_local(event.global_position)
			var tile_pos: Vector2i = tile_map_layer.local_to_map(event.position)
			print("Click on grid square: " + str(tile_pos))
			print("Global position: " + str(event.global_position))
	

extends Node2D

@export var camera_speed: int = 100

@onready var camera: Camera2D = $Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_handle_cam_movement(delta)


func _handle_cam_movement(delta: float) -> void:
	var velocity = Input.get_vector("cam_left", "cam_right", "cam_up", "cam_down") * camera_speed
	camera.position += velocity * delta

extends Node2D

const MAX_SPEED: int = 800
const MIN_SPEED: int = 200

@export var speed: int:
	set(new_value):
		if new_value > MAX_SPEED:
			speed = MAX_SPEED
		elif new_value < MIN_SPEED:
			speed = MIN_SPEED
		else:
			speed = new_value

@onready var player: Area2D = $Area2D
@onready var camera: Camera2D = $Area2D/Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_handle_movement(delta)
	_handle_zoom()
	_handle_speed()


func _handle_movement(delta: float) -> void:
	var velocity = Input.get_vector("left", "right", "up", "down") * speed
	player.position += velocity * delta


func _handle_zoom() -> void:
	if Input.is_action_just_pressed("zoom_in") and camera.zoom <= Vector2(1.7, 1.7):
		camera.zoom += Vector2(0.1, 0.1)
	if Input.is_action_just_pressed("zoom_out") and camera.zoom >= Vector2(0.4, 0.4):
		camera.zoom -= Vector2(0.1, 0.1)


func _handle_speed() -> void:
	if Input.is_action_just_pressed("inc_speed"):
		speed += 50
	if Input.is_action_just_pressed("dec_speed"):
		speed -= 50

class_name Player
extends Node2D

signal speed_changed(value: int)
signal zoom_changed(value: float)
signal chunk_id_changed(entered_from: Chunk.Sides)

#enum ChunkSides {
	#UP,
	#DOWN,
	#LEFT,
	#RIGHT,
#}

const MAX_SPEED: int = 800
const MIN_SPEED: int = 200

# Player always starts here
var current_chunk_id: int = 4:
	set(new_value):
		current_chunk_id = new_value
		chunk_id_changed.emit()
var entered_from: Chunk.Sides

@export var speed: int:
	set(new_value):
		if new_value > MAX_SPEED:
			speed = MAX_SPEED
		elif new_value < MIN_SPEED:
			speed = MIN_SPEED
		else:
			speed = new_value
			emit_signal("speed_changed", speed)

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
	var velocity: Vector2 = Input.get_vector("left", "right", "up", "down") * speed
	player.position += velocity * delta


func _handle_zoom() -> void:
	if Input.is_action_just_pressed("zoom_in") and camera.zoom <= Vector2(1.7, 1.7):
		camera.zoom += Vector2(0.1, 0.1)
		emit_signal("zoom_changed", camera.zoom.x)
	if Input.is_action_just_pressed("zoom_out") and camera.zoom >= Vector2(0.4, 0.4):
		camera.zoom -= Vector2(0.1, 0.1)
		emit_signal("zoom_changed", camera.zoom.x)


func _handle_speed() -> void:
	if Input.is_action_just_pressed("inc_speed"):
		speed += 50
	if Input.is_action_just_pressed("dec_speed"):
		speed -= 50


func _on_area_entered(area: Area2D) -> void:
	var chunk: Chunk = area.get_parent()
	if current_chunk_id != chunk.id:
		current_chunk_id = chunk.id
		var area_name: StringName = area.name
		match area_name:
			"Left":
				entered_from = Chunk.Sides.LEFT
			"Right":
				entered_from = Chunk.Sides.RIGHT
			"Up":
				entered_from = Chunk.Sides.UP
			"Down":
				entered_from = Chunk.Sides.DOWN
		print("In chunk ID: " + str(current_chunk_id))
		print("Entered from the: " + area_name)

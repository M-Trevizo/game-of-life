class_name HUD
extends CanvasLayer

signal sim_start
signal sim_step
signal sim_stop

@onready var speed: Label = %Speed
@onready var zoom: Label = %Zoom


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func update_speed_label(value: int) -> void:
	speed.text = str(value)


func update_zoom_label(value: float) -> void:
	zoom.text = "{value}x".format({"value": "%0.1f" % value})


func _on_play_button_pressed() -> void:
	sim_start.emit()


func _on_step_button_pressed() -> void:
	sim_step.emit()


func _on_stop_button_pressed() -> void:
	sim_stop.emit()

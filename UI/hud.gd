class_name HUD
extends CanvasLayer

@onready var speed: Label = $MarginContainer/LabelContainer/VBoxContainer/SpeedContainer/Speed
@onready var zoom: Label = $MarginContainer/LabelContainer/VBoxContainer/ZoomContainer/Zoom


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

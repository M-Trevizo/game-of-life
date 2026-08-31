class_name Simulation
extends Node

## Time between each simulation step
const TIME: float = 1

var is_running: bool
var timer: Timer


func _init() -> void:
	is_running = false
	timer = Timer.new()
	


func calc_next_step(chunks: Dictionary) -> void:
	#for instance in chunks.values():
	pass


func _on_simulation_started() -> void:
	pass

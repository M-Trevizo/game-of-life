class_name Simulation
extends Node

## Time between each simulation step
const TIME: float = 0.5

var is_running: bool
var timer: Timer

func _init(p_timer: Timer) -> void:
	is_running = false
	timer = p_timer
	timer.timeout.connect(_on_timer_timeout)


## Starts the simulation.
func start() -> void:
	is_running = true
	timer.start(TIME)


func step() -> void:
	if not timer.is_stopped():
		timer.stop()
		is_running = false
	_calc_next_step(Chunk.chunks)


func stop() -> void:
	is_running = false
	timer.stop()


## Calculates what the next state of each chunk should be.
func _calc_next_step(chunks: Dictionary) -> void:
	for chunk: Chunk in chunks.values():
		for position in chunk.active_cells:
			var cell: Cell = chunk.active_cells.get(position)
			if cell.is_alive:
				if cell.num_of_alive_neighbors < 2 or cell.num_of_alive_neighbors > 3:
					chunk.flip_cell(position)
			elif not cell.is_alive and cell.num_of_alive_neighbors == 3:
				chunk.flip_cell(position)


func _on_timer_timeout() -> void:
	_calc_next_step(Chunk.chunks)

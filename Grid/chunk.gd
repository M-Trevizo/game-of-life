class_name Chunk
extends Node2D

signal generate_chunks(chunk_pos: Vector2i, num_chunks: int)

const CHUNK_AREA: int = 10 ** 2

var id: int

static func create(id: int, pos: Vector2i, scene: PackedScene) -> Chunk:
	var instance: Chunk = scene.instantiate()
	instance.id = id
	instance.position = pos
	return instance


func _on_left_area_area_entered(area: Area2D) -> void:
	print("Entered Left area of chunk id: " + str(id))
	# Get position of chunk that we enter
	# Generate chunks starting at appropriate pos offset 
	# This should generate a new row or column depending on area entered


func _on_left_area_area_exited(area: Area2D) -> void:
	pass # Replace with function body.


func _on_right_area_area_entered(area: Area2D) -> void:
	print("Entered Right area of chunk id: " + str(id))


func _on_right_area_area_exited(area: Area2D) -> void:
	pass # Replace with function body.


func _on_up_area_area_entered(area: Area2D) -> void:
	print("Entered Up area of chunk id: " + str(id))
	generate_chunks.emit(position, 3)


func _on_up_area_area_exited(area: Area2D) -> void:
	pass # Replace with function body.


func _on_down_area_area_entered(area: Area2D) -> void:
	print("Entered Down area of chunk id: " + str(id))


func _on_down_area_area_exited(area: Area2D) -> void:
	pass # Replace with function body.

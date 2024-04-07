extends Node2D

func _process(delta: float) -> void:
	global_position.y -= 20.0 * delta
	if global_position.y < -100:
		queue_free()

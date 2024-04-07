extends Node2D

@export var active := true
var speed: float

func _ready() -> void:
	if active:
		speed = randf_range(50.0, 100.0);
		scale *= randf_range(0.25, 0.5);

func _process(delta: float) -> void:
	if active:
		global_position.y -= delta * speed
		if global_position.y < -50:
			queue_free()

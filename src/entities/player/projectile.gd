extends Node2D

const PROJECTILE_DESTROYED = preload("res://src/entities/player/projectile_destroyed.tscn")

var direction : Vector2
var speed := 500.0

func _process(delta: float) -> void:
	var new_global_position := global_position + (direction * speed * delta)
	look_at(new_global_position)
	global_position = new_global_position
	if (
		global_position.x < -50 or global_position.x > Globals.screen_size.x + 50
		or global_position.y < -50 or global_position.y > Globals.screen_size.y + 50
	):
		destroy()

func _on_hitbox_area_entered(area: Area2D) -> void:
	AudioManager.play_sfx("crash")
	destroy()

func destroy() -> void:
	var p := PROJECTILE_DESTROYED.instantiate()
	p.global_position = global_position
	add_sibling(p)
	queue_free()

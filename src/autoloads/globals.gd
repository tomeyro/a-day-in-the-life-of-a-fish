extends Node

var screen_size := Vector2(800.0, 800.0)

var player: Player
var player_position: Vector2:
	get:
		if player and is_instance_valid(player):
			return player.global_position
		return Vector2.ZERO
		
var level: Level
var intro_done := false


func get_window_size() -> float:
	return min(get_window().size.x, get_window().size.y)

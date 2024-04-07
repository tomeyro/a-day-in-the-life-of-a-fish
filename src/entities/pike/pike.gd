extends Node2D

@onready var sprite: Node2D = $Sprite

var sfx_timer := 0

func _ready() -> void:
	var target_position := global_position
	if target_position.x < 0 or target_position.x > Globals.screen_size.x:
		var to_border: float = abs(target_position.x) if target_position.x < 0 else (target_position.x - Globals.screen_size.x)
		target_position.x += (Globals.screen_size.x + (to_border * 2.0)) * sign(target_position.x) * -1.0
	if target_position.y < 0 or target_position.y > Globals.screen_size.y:
		var to_border: float = abs(target_position.y) if target_position.y < 0 else (target_position.y - Globals.screen_size.y)
		target_position.y += (Globals.screen_size.y + (to_border * 2.0)) * sign(target_position.y) * -1.0
		
	if target_position.x < 0:
		sprite.scale.x = -1
	elif target_position.y < 0:
		rotation_degrees = -90
	elif target_position.y > Globals.screen_size.y:
		rotation_degrees = 90
	
	var tween := create_tween()
	tween.tween_property(self, "global_position", target_position, 2.0)
	await tween.finished
	queue_free()
	
func _set_sfx_timer() -> void:
	sfx_timer = randf_range(0.25, 3.00)

func _process(delta: float) -> void:
	sfx_timer -= delta
	if sfx_timer <= 0:
		_set_sfx_timer()
		AudioManager.play_sfx("moin", true)

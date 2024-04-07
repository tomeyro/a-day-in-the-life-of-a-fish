extends Node2D

@onready var content: Node2D = $Content

func _ready() -> void:
	var t := create_tween()
	t.tween_property(content, "position:y", content.position.y, 1.0)
	t.tween_property(content, "position:y", -Globals.screen_size.y, 1.0)
	await t.finished
	SceneManager.change_scene(SceneManager.MAIN, false)

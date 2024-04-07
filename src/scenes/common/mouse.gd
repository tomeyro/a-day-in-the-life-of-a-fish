extends Node2D

enum side {
	left,
	right
}

@export var mouse_side : side = side.left

@onready var left: Polygon2D = $Sprite/Left
@onready var right: Polygon2D = $Sprite/Right


func _ready() -> void:
	var btn := left if mouse_side == side.left else right
	var t := create_tween()
	t.set_loops()
	t.tween_property(btn, "modulate", Color("ff5053"), 0.2)
	t.tween_property(btn, "modulate", Color.WHITE, 0.2)

extends CanvasLayer

@onready var curtain: ColorRect = $Curtain

const MAIN = preload("res://src/scenes/main/main.tscn")
const LEVEL = preload("res://src/scenes/level/level.tscn")
const SPLASH = preload("res://src/scenes/splash/splash.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	curtain.position.x = -800

func change_scene(scene: PackedScene, with_transition: bool = true):
	if with_transition:
		var t1 := create_tween()
		t1.tween_property(curtain, "position:x", 0, 1.0)
		await t1.finished
	get_tree().change_scene_to_packed(scene)
	if with_transition:
		var t2 := create_tween()
		t2.tween_property(curtain, "position:x", 800, 1.0)
		t2.tween_property(curtain, "position:x", -800, 0)
	

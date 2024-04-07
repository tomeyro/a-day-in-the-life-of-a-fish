@tool
extends Node2D

signal clicked

@export var text := "Credits"
@onready var label: RichTextLabel = $Label
@onready var polygon_2d: Polygon2D = $Polygon2D
@onready var polygon_color: Color = polygon_2d.color

func _ready() -> void:
	update_text()

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		update_text()

func update_text() -> void:
	label.text = "[url={}][center][wave]" + text + "[/wave][/center][/url]"

func _on_label_mouse_entered() -> void:
	polygon_2d.color = Color("ee8f57")
	AudioManager.play_sfx("pop")

func _on_label_mouse_exited() -> void:
	polygon_2d.color = polygon_color

func _on_label_meta_clicked(meta: Variant) -> void:
	clicked.emit()
	AudioManager.play_sfx("pop")

extends CommonScene

@onready var title: RichTextLabel = $Title
@onready var player: Player = $Player
@onready var ui: Node2D = $UI
@onready var credits: CanvasLayer = $Credits
@onready var sound_btn: Node2D = $UI/Sound

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	AudioManager.play_music("menu")
	_update_sound_btn_text()
	credits.visible = false
	player.intro_start()
	title.global_position.y = 850
	ui.modulate = Color.TRANSPARENT
	ui.position = Vector2(800, 800)
	var t := create_tween()
	t.tween_property(title, "global_position:y", 50.0, 2.0 if not Globals.intro_done else 0.0)
	t.tween_property(player, "global_position", Vector2(400.0, 400.0), 2.0 if not Globals.intro_done else 0.0)
	t.tween_property(ui, "position", Vector2.ZERO, 0.0)
	t.tween_property(ui, "modulate", Color.WHITE, 1.0 if not Globals.intro_done else 0.0)
	await t.finished
	player.intro_stop()
	Globals.intro_done = true

func _on_start_clicked() -> void:
	SceneManager.change_scene(SceneManager.LEVEL)

func _on_credits_clicked() -> void:
	credits.visible = true
	
func _on_close_credits_clicked() -> void:
	credits.visible = false

func _on_credits_label_meta_clicked(meta: Variant) -> void:
	var data: Dictionary = JSON.parse_string(meta)
	if data and data["url"]:
		OS.shell_open(data["url"])

func _on_sound_clicked() -> void:
	AudioManager.toggle_enabled()
	_update_sound_btn_text()
	
func _update_sound_btn_text() -> void:
	if AudioManager.enabled:
		sound_btn.text = sound_btn.text.replace("off", "on")
	else:
		sound_btn.text = sound_btn.text.replace("on", "off")
	sound_btn.update_text()

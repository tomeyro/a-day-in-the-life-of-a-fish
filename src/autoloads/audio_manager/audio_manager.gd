extends Node2D

var enabled := true

@onready var _sfx: Node2D = %Sfx
@onready var _music: Node2D = $Music
var _playing_music: AudioStreamPlayer

func play_sfx(sfx_name: String, check_if_playing := false) -> void:
	if not enabled:
		return
	if _sfx.has_node(sfx_name):
		var sfx: AudioStreamPlayer = _sfx.get_node(sfx_name).get_children().pick_random()
		if check_if_playing and sfx.playing:
			return
		sfx.play()

func play_music(music_name: String) -> void:
	if not enabled:
		return
	if _playing_music and _playing_music.playing:
		_playing_music.stop()
	if _music.has_node(music_name):
		_playing_music = _music.get_node(music_name)
		if not _playing_music.playing:
			_playing_music.play()

func toggle_enabled() -> void:
	enabled = not enabled
	if _playing_music:
		if enabled:
			_playing_music.play()
		else:
			_playing_music.stop()

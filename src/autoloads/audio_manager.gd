extends Node

var _sfx := {}

func _ready() -> void:
	var sfx_dir := "res://res/sfx"
	for file in	DirAccess.get_files_at(sfx_dir):
		if file.ends_with(".wav"):
			var sfx_name := file.replace(".wav", "")
			for i in range(10):
				if sfx_name.ends_with(str(i)):
					sfx_name = sfx_name.substr(0, len(sfx_name) - 1)
			if not (sfx_name in _sfx):
				_sfx[sfx_name] = []
			var asp := AudioStreamPlayer.new()
			asp.stream = load(sfx_dir + "/" + file)
			_sfx[sfx_name].append(asp)
			add_child.call_deferred(asp)

func play_sfx(sfx_name: String, check_if_playing := false) -> void:
	var sfx: AudioStreamPlayer = _sfx[sfx_name].pick_random()
	if check_if_playing and sfx.playing:
		return
	sfx.play()

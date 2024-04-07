extends CanvasLayer


@onready var cursor: Node2D = $Cursor


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


func _process(delta: float) -> void:
	cursor.global_position = cursor.get_global_mouse_position()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if (
		cursor.global_position.x < 0 or cursor.global_position.x > Globals.screen_size.x
		or cursor.global_position.y < 0 or cursor.global_position.y > Globals.screen_size.y
	) else Input.MOUSE_MODE_HIDDEN

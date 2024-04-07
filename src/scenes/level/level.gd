extends CommonScene
class_name Level

@onready var enemy_life_container: Node2D = $EnemyLife
@onready var enemy_life: Polygon2D = $EnemyLife/Polygon2D
@onready var player: Player = $Player
@onready var enemy: Node2D = $Barracuda
@onready var end_screen: Node2D = $EndScreen
@onready var survived: RichTextLabel = $EndScreen/Survived
@onready var failed: RichTextLabel = $EndScreen/Failed

func _ready() -> void:
	super._ready()
	
	Signals.update_enemy_life.connect(_update_enemy_life_ui)
	Signals.enemy_dead.connect(_on_enemy_dead)
	Signals.player_dead.connect(_on_player_dead)
	
	end_screen.scale = Vector2.ZERO
	survived.visible = false
	failed.visible = false
	
	_update_enemy_life_ui(100)
	intro()

func _update_enemy_life_ui(new_life):
	(enemy_life.material as ShaderMaterial).set_shader_parameter("percentage", new_life)

func _on_enemy_dead():
	survived.visible = true
	show_end_screen("triumph")
	
func _on_player_dead():
	failed.visible = true
	show_end_screen("failure")
	
func show_end_screen(sfx) -> void:
	await get_tree().create_timer(2.0, false).timeout
	var t := create_tween()
	t.tween_property(end_screen, "scale", Vector2.ONE, 1.0)
	AudioManager.play_sfx(sfx)

func intro() -> void:
	player.intro_start()
	enemy.intro_start()
	var t := create_tween()
	t.tween_property(player, "global_position:x", 100, 2.0)
	t.tween_property(enemy, "global_position", Vector2.ONE * 700, 2.0)
	t.tween_property(enemy_life_container, "global_position:y", 0, 2.0)
	await t.finished
	player.intro_stop()
	enemy.intro_stop()
	
func _on_back_button_clicked() -> void:
	SceneManager.change_scene(SceneManager.MAIN)

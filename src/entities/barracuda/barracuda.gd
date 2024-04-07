extends Node2D

const PIKE = preload("res://src/entities/pike/pike.tscn")
const BARRACUDA_DEAD = preload("res://src/entities/barracuda/barracuda_dead.tscn")

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var swim_animation: AnimationPlayer = $SwimAnimation
@onready var hurt_animation: AnimationPlayer = $HurtAnimation
@onready var sprite: Node2D = $Sprite
@onready var rotator: Node2D = Node2D.new()

enum STATES {
	idle,
	prepare_attack,
	attack,
	stop,
}
var state := STATES.idle

var life := 100
var damage := 10
var in_intro := false
var point_to := Vector2.ZERO

var stage: int:
	get:
		if life < 30:
			return 3
		if life < 60:
			return 2
		return 1
		
var speed_multiplier: float:
	get:
		return [
			1.0,
			0.8,
			0.6,
		][stage - 1]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_sibling.call_deferred(rotator)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if in_intro:
		point_to = Globals.player_position
	point_to_player(delta)
	if in_intro:
		return
	if state == STATES.idle and Globals.player:
		prepare_attack()
	elif state == STATES.prepare_attack:
		process_prepare_attack()
	
func _on_hitbox_area_entered(area: Area2D) -> void:
	animation_player.play("eat")
	stop()
	
func stop():
	state = STATES.stop

func prepare_attack():
	if state not in [STATES.idle, STATES.attack]:
		return
	state = STATES.prepare_attack
	await get_tree().create_timer(2.0, false).timeout
	attack()

func process_prepare_attack():
	point_to = Globals.player_position

func point_to_player(delta):
	if not Globals.player:
		stop()
		return
	rotator.global_position = global_position
	if rotator.global_position == point_to:
		return
	rotator.look_at(point_to)
	rotation = lerp_angle(rotation, rotator.rotation, delta * 10)
	while rotation_degrees < 0 or rotation_degrees >= 360:
		rotation_degrees = move_toward(rotation_degrees, 360.0 if rotation_degrees < 0 else 0.0, 360.0)
	if rotation_degrees > 90 and rotation_degrees < 270:
		sprite.scale.y = -1
	else:
		sprite.scale.y = 1

func attack():
	if state != STATES.prepare_attack:
		return
	state = STATES.attack
	[
		basic_attack,
		basic_attack,
		basic_attack,
		multifish_attack,
	].pick_random().call()
	
func basic_attack():
	animation_player.play("open_mouth")
	await get_tree().create_timer(0.25, false).timeout
	var player_position: Vector2 = Globals.player_position
	var target_position := player_position + (global_position.direction_to(player_position).normalized() * 10.0)
	point_to = target_position
	AudioManager.play_sfx("wiush")
	var tween := create_tween()
	tween.tween_property(
		self,
		"global_position",
		target_position,
		global_position.distance_to(target_position) * (1.0 * speed_multiplier) / Globals.screen_size.x,
	)
	await tween.finished
	animation_player.play("open_mouth", -1, -2.0, true)
	AudioManager.play_sfx("shomp")	
	await get_tree().create_timer(0.25, false).timeout
	prepare_attack()
	
func multifish_attack():
	animation_player.play("open_mouth")
	await get_tree().create_timer(0.25, false).timeout
	var player_position: Vector2 = Globals.player_position
	var target_position := player_position + (global_position.direction_to(player_position).normalized() * 1000.0)
	point_to = target_position
	var tween := create_tween()
	tween.tween_property(
		self,
		"global_position",
		target_position,
		global_position.distance_to(target_position) * (2.0 * speed_multiplier) / Globals.screen_size.x,
	)
	await tween.finished
	animation_player.play("open_mouth", -1, -2.0, true)
	
	var side := "Top"
	if global_position.x < 0:
		side = "Left"
	elif global_position.x > Globals.screen_size.x:
		side = "Right"
	elif global_position.y > Globals.screen_size.y:
		side = "Bottom"
	var repeats := []
	for i in range(10 + [0, 5, 10][stage - 1]):
		var spawn_point := Globals.level.get_random_spawn_point(side)
		while spawn_point in repeats:
			spawn_point = Globals.level.get_random_spawn_point(side)
		repeats.append(spawn_point)
		if len(repeats) > 4:
			repeats.pop_front()
		var pike := PIKE.instantiate()
		pike.global_position = spawn_point
		get_parent().add_child.call_deferred(pike)
		await get_tree().create_timer(0.2, false).timeout
	await get_tree().create_timer(1.0, false).timeout
	prepare_attack()

func _on_hurtbox_area_entered(area: Area2D) -> void:
	hurt()
	
func hurt() -> void:
	if not life:
		return
	life = max(life - damage, 0)
	hurt_animation.play("hurt")
	Signals.update_enemy_life.emit(life)
	if not life:
		die()
		
func die():
	Signals.enemy_dead.emit()
	var d := BARRACUDA_DEAD.instantiate()
	d.global_position = global_position
	add_sibling(d)
	queue_free()

func intro_start():
	in_intro = true
	swim_animation.play("swim")
	
func intro_stop():
	in_intro = false
	swim_animation.stop()

extends CharacterBody2D
class_name Player

const SPEED = 20.0
const MAX_SPEED = 500.0
const PLAYER_SKELETON = preload("res://src/entities/player/player_skeleton.tscn")
const PROJECTILE = preload("res://src/entities/player/projectile.tscn")

@onready var sprite: Node2D = $Sprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var rotator := Node2D.new()
@onready var projectile_sprite: Node2D = $Sprite/Projectile

var _original_points := {}

var dead := false
var ammo := 0
var max_ammo := 1
var shoot_cooldown := false
var in_intro := false

func _ready() -> void:
	Globals.player = self
	add_sibling.call_deferred(rotator)

func _physics_process(delta: float) -> void:
	projectile_sprite.visible = ammo > 0
	if dead or in_intro:
		return
	_point_to_mouse(delta)
	_handle_move()
	_handle_shoot()
	
func _point_to_mouse(delta):
	rotator.global_position = global_position
	rotator.look_at(get_global_mouse_position())
	rotation = lerp_angle(rotation, rotator.rotation, delta * 10)
	while rotation_degrees < 0 or rotation_degrees >= 360:
		rotation_degrees = move_toward(rotation_degrees, 360.0 if rotation_degrees < 0 else 0.0, 360.0)
	if rotation_degrees > 90 and rotation_degrees < 270:
		sprite.scale.y = -1
	else:
		sprite.scale.y = 1

func _handle_move():
	if Input.is_action_pressed("move"):
		var target_velocity := global_position.direction_to(get_global_mouse_position()) * MAX_SPEED
		velocity = velocity.move_toward(target_velocity, SPEED)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED / 2.0)
	move_and_slide()

func _on_hurtbox_area_entered(area: Area2D) -> void:
	Signals.player_dead.emit()
	dead = true
	visible = false
	AudioManager.play_sfx("yumyum")
	var skeleton := PLAYER_SKELETON.instantiate() as Node2D
	skeleton.global_position = global_position
	get_parent().add_child.call_deferred(skeleton)
	queue_free()

func _on_hitbox_area_entered(area: Area2D) -> void:
	if ammo < max_ammo:
		ammo = min(ammo + 1, max_ammo)
		area.get_parent().die()
		AudioManager.play_sfx("eat")

func _handle_shoot() -> void:
	if not shoot_cooldown and Input.is_action_just_pressed("shoot") and ammo > 0:
		shoot_cooldown = true
		_shoot()
		await get_tree().create_timer(.2, false).timeout
		shoot_cooldown = false

func _shoot():
	ammo = max(ammo - 1, 0)
	var direction := global_position.direction_to(get_global_mouse_position()).normalized()
	var proj := PROJECTILE.instantiate()
	proj.global_position = projectile_sprite.global_position
	proj.direction = direction
	get_parent().add_child.call_deferred(proj)
	AudioManager.play_sfx("spit")

func intro_start():
	in_intro = true
	animation_player.play("swim")
	
func intro_stop():
	in_intro = false
	animation_player.stop()

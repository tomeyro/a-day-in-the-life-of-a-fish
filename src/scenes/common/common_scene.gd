extends Node2D
class_name CommonScene

const BUBBLE = preload("res://src/environment/bubble/bubble.tscn")
const SARDINE = preload("res://src/entities/sardine/sardine.tscn")

@onready var spawns: Node2D = $Spawns

var spawn_bubble_chance := 30.0
var spawn_bubble_tick := 0.5
var spawn_sardine_chance := 5.0
var spawn_sardine_tick := 0.5

func _ready() -> void:
	Globals.level = self
	try_sardine_spawn()
	try_bubble_spawn()

func get_random_spawn_point(side = null) -> Vector2:
	if not side:
		side = ["Top", "Bottom", "Right", "Left"].pick_random()
	return spawns.get_node(side).get_children().pick_random().global_position
	
func try_bubble_spawn():
	await get_tree().create_timer(spawn_bubble_tick, false).timeout
	if (spawn_bubble_chance / 100.0) > randf():
		spawn_bubble_chance = 30.0
		bubble_spawn()
	else:
		spawn_bubble_chance += 2.0
	try_bubble_spawn()
		
func bubble_spawn():
	var spawn_point = get_random_spawn_point("Bottom")
	var bubble := BUBBLE.instantiate()
	bubble.global_position = spawn_point
	add_child.call_deferred(bubble)
	
func try_sardine_spawn():
	await get_tree().create_timer(spawn_sardine_tick, false).timeout
	if (spawn_sardine_chance / 100.0) > randf():
		spawn_sardine_chance = 5.0
		sardine_spawn()
	else:
		spawn_sardine_chance += 1.0
	try_sardine_spawn()
		
func sardine_spawn():
	var spawn_point = get_random_spawn_point()
	var sardine := SARDINE.instantiate()
	sardine.global_position = spawn_point
	add_child.call_deferred(sardine)

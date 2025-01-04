@tool
extends Node2D

@export var monster_scene: PackedScene
@export var spawn_interval: int = 60
@export var spawn_interval_rand_range: int = 10
@export var spawn_count: int = 1

@onready var spawn_timer: Timer = $SpawnTimer
@onready var monsters: Node2D = $Monsters
@onready var objects_node: Node2D = get_parent()
@onready var array: Array[Node2D] = []

func _ready() -> void:
	spawn_timer.wait_time = spawn_interval + randi_range(0, spawn_interval_rand_range)
	spawn_timer.start()
	spawn()

func _on_spawn_timer_timeout() -> void:
	spawn()

func spawn() -> void:
	array = array.filter(func(node: Node2D) -> bool: return is_instance_valid(node))
	if array.size() < spawn_count:
		var monster := monster_scene.instantiate()
		monster.position = position
		array.append(monster)
		objects_node.add_child.call_deferred(monster)

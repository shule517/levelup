@tool
class_name ProMinami
extends Node2D

@export var monster_scene: PackedScene = null
@export var map_width: int = 400
@export var map_height: int = 400

const CELL_SIZE: int = 16

func _ready() -> void:
	for i in 220:
		var x := randi_range(0, map_width)
		var y := randi_range(0, map_height)
		_spawn_monster(x, y)

	for i in map_width:
		_spawn_monster(0, i)
		_spawn_monster(i, 0)
		_spawn_monster(i, i)

func _spawn_monster(x: int, y: int) -> void:
	var monster := monster_scene.instantiate()
	monster.position = Vector2(x * CELL_SIZE, y * CELL_SIZE)
	$Node.add_child.call_deferred(monster)

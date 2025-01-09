extends Node
class_name GlobalAutoLoad

var player_max_hp: int = 28
var player_hp: int = 28
var player_atk: int = 11
var player_atk_speed: float = 1.7
var player_def: int = 0
var player_exp: int = 0
var player_next_exp: int = 1
var player_level: int = 1


var home_scene: PackedScene = preload("res://scene/Field/home.tscn")

# Mainシーンに切り替え
func load_home_scene() -> void:
	get_tree().change_scene_to_packed(home_scene)

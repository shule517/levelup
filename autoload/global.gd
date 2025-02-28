extends Node

# プレイヤー情報
var player_max_hp: int = 28
var player_hp: int = 28
var player_atk: int = 11
var player_atk_speed: float = 1.4
var player_def: int = 0
var player_exp: int = 0
var player_next_exp: int = 1
var player_level: int = 1

# アイテム情報
var tunip_seed_count: int = 16
var tunip_count: int = 0

# お金
var gold: int = 0

#var home_scene: PackedScene = preload("res://fields/home/home.tscn")
#
## Mainシーンに切り替え
#func load_home_scene() -> void:
	#get_tree().change_scene_to_packed(home_scene)

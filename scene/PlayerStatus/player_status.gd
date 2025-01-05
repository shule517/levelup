extends Node2D

@onready var global: GlobalAutoLoad = get_node("/root/Global")

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	$StatusLabel.text = "┌──────────────┐
│ レベル： %d
│ ちから： %d
│ まもり： %d
│ つぎのレベルまで： ＆%d
│
└━━━━━━━━━━━━━━┘" % [global.player_level, global.player_atk, global.player_def, global.player_next_exp - global.player_exp]

	$ExpProgressBar.value = global.player_exp * 100 / global.player_next_exp

#@export var player_max_hp: int = 28
#@export var player_hp: int = 28
#@export var player_atk: int = 11
#@export var player_def: int = 3
#@export var player_exp: int = 0
#@export var player_next_exp: int = 1
#@export var player_level: int = 1

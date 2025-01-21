extends Node2D

@onready var global := $/root/Global

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	$Window/MarginContainer/StatusLabel.text = "レベル： %d

ＨＰ　： %d / %d
ちから： %d
まもり： %d
はやさ： %d
" % [global.player_level, global.player_hp, global.player_max_hp, global.player_atk, global.player_def, 200 - 50/(1.0 / global.player_atk_speed)]
# global.player_next_exp - global.player_exp
	$Window/Control/ExpProgressBar.value = global.player_exp * 100 / global.player_next_exp

#@export var player_max_hp: int = 28
#@export var player_hp: int = 28
#@export var player_atk: int = 11
#@export var player_def: int = 3
#@export var player_exp: int = 0
#@export var player_next_exp: int = 1
#@export var player_level: int = 1

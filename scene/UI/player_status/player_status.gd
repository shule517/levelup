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
	$Window/Control/ExpProgressBar.value = global.player_exp * 100 / global.player_next_exp

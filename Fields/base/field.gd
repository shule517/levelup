class_name Field
extends Node2D

func _ready() -> void:
	var warp: Warp = $Warp # TODO: 本当はFieldSwitcherで保持したWarpを参照する必要がある
	FieldSwitcher.trigger_player_spawn(warp.spawn_maker_2d.global_position, warp.spawn_direction)

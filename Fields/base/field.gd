class_name Field
extends Node2D

func _ready() -> void:
	var warp: Warp = $Warp # TODO: 本当はFieldSwitcherで保持したWarpを参照する必要がある
	FieldSwitcher.trigger_player_spawn(warp.spawn_maker_2d.global_position, warp.spawn_direction)

	## TODO: 耕した
	#var cells := [Vector2i(0, 0), Vector2i(0, 1), Vector2i(1, 0), Vector2i(1, 1)]
	#$TilledSoilTileMapLayer.set_cells_terrain_connect(cells, 0, 0)

class_name GroundTileMapPlayer
extends TileMapLayer

func till_soil(position: Vector2) -> void:
	var coords := local_to_map(position)
	set_cells_terrain_connect([coords], 0, -1) # 耕す(地形を削除する)

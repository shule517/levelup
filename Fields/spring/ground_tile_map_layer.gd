class_name GroundTileMapPlayer
extends TileMapLayer

func till_soil(position: Vector2) -> bool:
	var coords := local_to_map(position)

	if _is_soiled(coords):
		return false # 耕せなかった

	set_cells_terrain_connect([coords], 0, -1) # 耕す(地形を削除する)
	return true # 耕した

func can_till_soil(position: Vector2) -> bool:
	var coords := local_to_map(position)
	return get_cell_alternative_tile(coords) != -1

# private
func _is_soiled(coords: Vector2i) -> bool:
	return get_cell_alternative_tile(coords) == -1

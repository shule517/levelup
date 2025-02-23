class_name CropsTileMapPlayer
extends TileMapLayer

func plant_crop(position: Vector2) -> void:
	var coords := local_to_map(position)
	var turnip: Turnip = get_children().filter(func(child: Node) -> bool: return local_to_map(child.position) == coords).front()

	if turnip == null and Global.tunip_seed_count > 0:
		Global.tunip_seed_count -= 1
		# Turnipの種を植える
		set_cell(coords, 0, Vector2i(0, 0), 0) # 削除
		set_cell(coords, 0, Vector2i(0, 0), 1) # 植えた

class_name CropsTileMapPlayer
extends TileMapLayer

func plant_crop(position: Vector2) -> void:
	var coords := local_to_map(position)
	var turnip: Turnip = get_children().filter(func(child: Node) -> bool: return local_to_map(child.position) == coords).front()

	# TODO: どのマスに対して植えようしているのか ガイドを表示したい

	if turnip == null:
		# Turnipの種を植える
		set_cell(coords, 0, Vector2i(0, 0), 0) # 削除
		set_cell(coords, 0, Vector2i(0, 0), 1) # 植えた

class_name CropsTileMapPlayer
extends TileMapLayer

func plant_seed(position: Vector2, inventory: Inventory) -> void:
	var coords := local_to_map(position)
	
	var turnip: Turnip = get_children().filter(func(child: Node) -> bool: return local_to_map(child.position) == coords).front()

	inventory.get_item(0).quantity

	if turnip == null and inventory.get_item(0).quantity > 0:
		inventory.get_item(0).quantity -= 1
		# Turnipの種を植える
		set_cell(coords, 0, Vector2i(0, 0), 0) # 削除
		set_cell(coords, 0, Vector2i(0, 0), 1) # 植えた

func can_plant_seed(position: Vector2, inventory: Inventory) -> bool:
	var coords := local_to_map(position)
	var node: Node2D = get_children().filter(func(child: Node) -> bool: return local_to_map(child.position) == coords).front()
	return node == null and inventory.get_item(0).quantity > 0

func is_tree(position: Vector2) -> TreeObject:
	var coords := local_to_map(position)
	var nodes := get_children().filter(func(child: Node) -> bool: return local_to_map(child.position) == coords)

	if nodes.size() > 0:
		var node :Node = nodes.front()
		if node is TreeObject:
			return node

	return null

@tool
extends TileMapLayer

func _ready() -> void:
	for i in range(20):
		set_cell(Vector2i(i, i), 1)

	for i in range(20):
		set_cell(Vector2i(-i, -i), 0)

	# TODO: MapLayerの座標の取得
	var pos: Vector2i = local_to_map(Vector2(0, 0))
	print(pos)
	
	# TODO: tunipを植える
	for i in range(20):
		set_cell(Vector2i(i, i), 0, Vector2i(0, 0), 1)

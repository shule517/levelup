extends TileMapLayer

func _ready() -> void:
	for i in range(20):
		set_cell(Vector2i(i, i), 1)

	for i in range(20):
		set_cell(Vector2i(-i, -i), 0)

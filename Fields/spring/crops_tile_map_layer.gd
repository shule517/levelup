class_name CropsTileMapPlayer
extends TileMapLayer

func plant_crop(position: Vector2) -> void:
	var coords := local_to_map(position)

	# TODO: TileMapから該当シーンを取得する方法
	# var item: Turnip = get_children().filter(func(child: Node) -> bool: return local_to_map(child.position) == coords).front()

	# Turnipの種を植える
	set_cell(coords, 0, Vector2i(0, 0), 1)

#@onready var player: Player = get_tree().get_nodes_in_group("Player")[0]

#func _ready() -> void:
	#for i in range(20):
		#set_cell(Vector2i(i, i), 1)
#
	#for i in range(20):
		#set_cell(Vector2i(-i, -i), 0)
#
	## TODO: MapLayerの座標の取得
	#var pos: Vector2i = local_to_map(Vector2(0, 0))
	#print(pos)
	#
	### TODO: tunipを植える
	##for i in range(20):
		##set_cell(Vector2i(i, i), 0, Vector2i(0, 0), 1)
#
#func _process(delta: float) -> void:
	#if Input.is_action_pressed("button_y"):
		#var coords := local_to_map(player.position)
		#set_cell(coords, 0, Vector2i(0, 0), 1)

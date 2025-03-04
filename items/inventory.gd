class_name Inventory
extends Resource

@export var items: Array[Item]

func insert(item: Item) -> void:
	items.append(item)

func get_item(index: int) -> Item:
	if index < items.size():
		return items[index]
	else:
		return null

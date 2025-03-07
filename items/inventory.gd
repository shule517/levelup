class_name Inventory
extends Resource

@export var items: Array[ItemStack]
@export var get_item_auduio: AudioStream

func insert(new_item: Item, quantity: int) -> void:
	# 既存に数を追加
	for stack in items:
		if stack.item == new_item:
			stack.quantity += quantity
			return

	# 新しいアイテムを追加
	var new_stack := ItemStack.new()
	new_stack.item = new_item
	new_stack.quantity = quantity
	items.append(new_stack)

func get_item(index: int) -> ItemStack:
	if index < items.size():
		return items[index]
	else:
		return null

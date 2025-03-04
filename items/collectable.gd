class_name Collectable
extends StaticBody2D

@export var item_resource: Item

func collect(inventory: Inventory) -> void:
	inventory.insert(item_resource)
	queue_free()

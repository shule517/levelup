class_name Collectable
extends Area2D

@export var item_resource: Item

func collect() -> void:
	queue_free()

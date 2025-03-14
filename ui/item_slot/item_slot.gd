@tool
class_name ItemSlot
extends Control

@export var item_stack: ItemStack
@onready var item_sprite: AnimatedSprite2D = $CenterContainer/MarginContainer/AnimatedSprite2D
@onready var item_count: Label = $ItemCountLabel

func _ready() -> void:
	update(item_stack)

func update(item_stack: ItemStack) -> void:
	if item_stack:
		item_sprite.visible = true
		item_sprite.frame = item_stack.item.id
		item_count.visible = true
		item_count.text = "%d" % item_stack.quantity
	else:
		item_sprite.visible = false
		item_count.visible = false

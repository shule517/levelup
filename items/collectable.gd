class_name Collectable
extends StaticBody2D

@export var item_resource: Item
@export var collect_sound: AudioStream

func collect(inventory: Inventory) -> void:
	inventory.insert(item_resource)
	Audio.play_sound_effect(collect_sound, self, randf_range(0.8, 1.5))
	queue_free()

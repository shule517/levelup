class_name FieldSwitcher
extends Node

func switch(destination_field_scene: PackedScene, destination_door_name: String) -> void:
	get_tree().change_scene_to_packed(destination_field_scene)

extends Node

func switch(field: Enums.Field) -> void:
	var scene_path := get_scene_path(field)
	get_tree().change_scene_to_file(scene_path)

func get_scene_path(field: Enums.Field) -> String:
	return "res://Fields/field_%s.tscn" % Enums.field_to_string(field)

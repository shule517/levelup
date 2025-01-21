extends Node

func switch(field: Enums.Field) -> void:
	var scene_path := get_scene_path(field)
	get_tree().change_scene_to_file(scene_path)

func get_scene_path(field: Enums.Field) -> String:
	var field_name := Enums.get_field_as_string(field)
	var path: String = "res://Fields/field_%s.tscn" % field_name
	return path

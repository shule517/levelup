extends Node

func switch(field: Enum.Field) -> void:
	var scene_path := get_scene_path(field)
	get_tree().change_scene_to_file(scene_path)

func get_scene_path(field: Enum.Field) -> String:
	return "res://Fields/field_%s.tscn" % Enum.field_to_string(field)
# TODO: HOMEにも対応する

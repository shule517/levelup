extends Node

func switch(field: Enums.Field) -> void:
	var scene_path := get_scene_path(field)
	get_tree().change_scene_to_file(scene_path)

func get_scene_path(field: Enums.Field) -> String:
	match field:
		Enums.Field.SPRING:
			return "res://Fields/field_spring.tscn"
		Enums.Field.SAND:
			return "res://Fields/field_sand.tscn"
		Enums.Field.WINTER:
			return "res://Fields/field_winter.tscn"
	return ""

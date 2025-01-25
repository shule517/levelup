extends Node

signal on_trigger_player_spawn

func switch(field: Enum.Field) -> void:
	# 画面切り替え
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished

	var scene_path := get_scene_path(field)
	get_tree().change_scene_to_file(scene_path)

func get_scene_path(field: Enum.Field) -> String:
	return "res://fields/%s/%s.tscn" % [Enum.field_to_string(field), Enum.field_to_string(field)]
# TODO: HOMEにも対応する

func trigger_player_spawn(position: Vector2, direction: Enum.Direction) -> void:
	on_trigger_player_spawn.emit(position, direction)

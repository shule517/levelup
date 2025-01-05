class_name Warp
extends Node2D

@export var scene: PackedScene

func _ready() -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_packed(scene)

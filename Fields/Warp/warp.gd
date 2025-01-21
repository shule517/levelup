@tool
class_name Warp
extends Area2D

@export var field: Enums.Field = Enums.Field.SPRING
@export var spawn_direction: Enums.Direction = Enums.Direction.LEFT

@onready var spawn_maker_2d: Marker2D = $SpawnMarker2D
@onready var label: Label = $Label

#const spring_scene: PackedScene = preload("res://Fields/field_spring.tscn")
#const sand_scene: PackedScene = preload("res://Fields/field_sand.tscn")
#const winter_scene: PackedScene = preload("res://Fields/field_winter.tscn")

func _get_enum_as_string(enum_value: int) -> String:
	for name: String in Enums.Field.keys():
		if Enums.Field[name] == enum_value:
			return name
	return "Unknown"  # 未定義の値の場合

func _ready() -> void:
	label.text = "to %s" % _get_enum_as_string(field)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		FieldSwitcher.switch(field)

#func get_scene() -> PackedScene:
	#return sand_scene

#func get_scene() -> PackedScene:
	#match field:
		#Field.SPRING:
			#return spring_scene
		#Field.SAND:
			#return sand_scene
		#Field.WINTER:
			#return winter_scene
	#return

@tool
class_name Warp
extends Area2D

@export var field: Enum.Field = Enum.Field.SPRING
@export var spawn_direction: Enum.Direction = Enum.Direction.LEFT

@onready var spawn_maker_2d: Marker2D = $SpawnMarker2D
@onready var label: Label = $Label

func _get_enum_as_string(enum_value: int) -> String:
	for name: String in Enum.Field.keys():
		if Enum.Field[name] == enum_value:
			return name
	return "Unknown"  # 未定義の値の場合

func _ready() -> void:
	label.text = "to %s" % _get_enum_as_string(field)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		FieldSwitcher.switch(field)

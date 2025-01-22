@tool
class_name Warp
extends Area2D

@export var field: Enum.Field = Enum.Field.SPRING
@export var spawn_direction: Enum.Direction = Enum.Direction.LEFT

@onready var spawn_maker_2d: Marker2D = $SpawnMarker2D
@onready var label: Label = $Label

func _ready() -> void:
	label.text = "to %s" % Enum.field_to_string(field)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		FieldSwitcher.switch(field)

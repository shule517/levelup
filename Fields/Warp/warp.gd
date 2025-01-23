@tool
class_name Warp
extends Area2D

@export var field: Enum.Field = Enum.Field.SPRING
@export var spawn_direction: Enum.Direction = Enum.Direction.LEFT

@onready var spawn_maker_2d: Marker2D = $SpawnMarker2D
@onready var label: Label = $Label

func _ready() -> void:
	if not is_valid_field(field):
		label.text = "error:【 %s 】 が みつかりません!" % Enum.field_to_string(field)
		label.label_settings.font_color = Color.RED
	else:
		label.text = "to %s" % Enum.field_to_string(field)
		label.label_settings.font_color = Color.WHITE

# TODO: ↓クラス化する
func get_scene_path(field: Enum.Field) -> String:
	return "res://Fields/%s/%s.tscn" % [Enum.field_to_string(field), Enum.field_to_string(field)]
# TODO: HOMEにも対応する

# TODO: ↓クラス化する
func is_valid_field(field: Enum.Field) -> bool:
	var scene_path := get_scene_path(field)
	var scene_resource: Resource = ResourceLoader.load(scene_path)

	# シーンが正しくロードされたかを確認
	return scene_resource and scene_resource is PackedScene

	## シーンが正しくロードされたかを確認
	#if scene_resource and scene_resource is PackedScene:
		## シーンをインスタンス化
		#return scene_resource.instantiate()
	#else:
		## ロードに失敗した場合のエラー処理
		#print("Failed to load scene at path: ", path)
		#return null

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		FieldSwitcher.switch(field)

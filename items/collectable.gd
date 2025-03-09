class_name Collectable
extends CharacterBody2D

@export var item_resource: Item
@export var collect_sound: AudioStream
@onready var player: Player = get_tree().get_nodes_in_group("Player")[0]

const SPEED: float = 80.0
var is_collect: bool = false

func _process(delta: float) -> void:
	if is_collect:
		# プレイヤーの位置に向かって進む
		var direction := (player.position - position).normalized()

		# 移動処理
		velocity = direction * SPEED
		move_and_slide()

func collect(inventory: Inventory) -> void:
	is_collect = true

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "ItemGetArea2D":
		player.inventory.insert(item_resource, 1)
		Audio.play_sound_effect(collect_sound, self, randf_range(0.8, 1.5))
		queue_free()

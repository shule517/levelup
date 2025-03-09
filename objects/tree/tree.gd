class_name TreeObject
extends Node2D

@export var chop_tree_audio: AudioStream
@export var fall_tree_audio: AudioStream
@export var get_item_audio: AudioStream
@export var hp: int = 5
@export var wood_item: Item
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _process(delta: float) -> void:
	unselect()

func select() -> void:
	if hp > 0:
		animated_sprite.material.set_shader_parameter("is_selected", true)
	else:
		unselect()

func unselect() -> void:
	animated_sprite.material.set_shader_parameter("is_selected", false)

func chop_tree(inventory: Inventory) -> void:
	if hp <= 0:
		return

	Audio.play_sound_effect(chop_tree_audio, self, randf_range(0.8, 1.1))
	hp -= 1

	if hp <= 0:
		animation_player.play("fall")
		Audio.play_sound_effect(fall_tree_audio, self, randf_range(0.8, 1.1))
		await get_tree().create_timer(2.5).timeout
		for i in range(13):
			const TurnipScene = preload("res://items/turnip/turnip.tscn")
			var turnip := TurnipScene.instantiate()
			turnip.global_position = Vector2(randf_range(global_position.x - 10, global_position.x + 10) , randf_range(global_position.y - 5, global_position.y + 5))
			#var collectable := Collectable.new()
			#collectable.item_resource = wood_item
			#collectable.position = Vector2(0, 0)
			#var turnip := preload("res://items/turnip/turnip.tscn")
			
			get_parent().get_parent().add_child(turnip)
			print(get_parent().get_parent())
			#inventory.insert(wood_item, 1)
			#Audio.play_sound_effect(get_item_audio, self, randf_range(0.8, 1.1))
			await get_tree().create_timer(randf_range(0.1, 0.01)).timeout
		queue_free()

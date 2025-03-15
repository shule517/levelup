class_name TreeObject
extends StaticBody2D

@export var chop_tree_audio: AudioStream
@export var fall_tree_audio: AudioStream
@export var get_item_audio: AudioStream
@export var hp: int = 5
@export var wood_item: ItemResource
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
	Input.start_joy_vibration(0, 0.3, 0.3, 0.2)
	hp -= 1

	if hp <= 0:
		animation_player.play("fall")
		Audio.play_sound_effect(fall_tree_audio, self, randf_range(0.8, 1.1))
		await get_tree().create_timer(2.2).timeout
		for i in range(13):
			drop_item()
		queue_free()
  
func drop_item() -> void:
	const ItemScene = preload("res://items/item/item.tscn")
	var item := ItemScene.instantiate()
	item.item_resource = load("res://items/item_resources/wood.tres")
	var base_x := global_position.x + 15
	item.global_position = Vector2(randf_range(base_x - 10, base_x + 10) , global_position.y - 7)
	get_parent().get_parent().add_child(item) # add_childされたら、itemの_readyが動く

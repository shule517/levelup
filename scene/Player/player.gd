class_name Player
extends CharacterBody2D

@export var till_sound: AudioStream

@onready var player_battle: Node = $PlayerBattle
@onready var ray_cast: RayCast2D = $RayCast2D
@onready var hal_sprite: AnimatedSprite2D = $HalAnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CellArea2D/CollisionShape2D
@onready var crops_tile_map_layer: CropsTileMapPlayer = get_tree().get_root().find_child("CropsTileMapLayer", true, false)
@onready var ground_tile_map_layer: GroundTileMapPlayer = get_tree().get_root().find_child("GroundTileMapLayer", true, false)
@onready var cell_animated_sprite_2d: AnimatedSprite2D = $CellAnimatedSprite2D

const SPEED: float    = 50.0

var crops: Array[Turnip] = []
var is_watering: bool = false  # 水やり中かどうかを判定するフラグ

func _process(delta: float) -> void:
	if is_watering:
		return  # 水やり中はフリーズ

	var ray_shape := collision_shape.shape as SeparationRayShape2D
	var local_tip_position := Vector2(position.x + ray_shape.length, position.y)

	# TODO: 該当セルの状態を確認する。耕されているか

	# 種をまく
	if Input.is_action_pressed("button_a") and crops_tile_map_layer:
		ground_tile_map_layer.till_soil(Vector2(local_tip_position.x, local_tip_position.y)) # 耕す
		crops_tile_map_layer.plant_crop(Vector2(local_tip_position.x, local_tip_position.y)) # 種を植える
		is_watering = true # 操作をフリーズ
		hal_sprite.play("soil")
		Audio.play_sound_effect(till_sound, self, randf_range(0.8, 1.5))
		await get_tree().create_timer(0.5).timeout
		is_watering = false # 操作を再開

	# TODO: 種をまくセルのガイド表示
	cell_animated_sprite_2d.global_position = Vector2(int(local_tip_position.x / 16) * 16 + 8, int(local_tip_position.y / 16) * 16 + 8)

	# 水やり、収穫
	if crops:
		var select_crop := crops[0]
		select_crop.select()

		for crop in crops:
			if crop != select_crop:
				crop.unselect()

		# 収穫
		if select_crop.can_harvest():
			if Input.is_action_pressed("button_a"):
				select_crop.harvest()
				is_watering = true # 操作をフリーズ
				hal_sprite.play("harvest")
				await get_tree().create_timer(0.3).timeout
				is_watering = false # 操作を再開

		# 水やり
		elif select_crop.need_water():
			if Input.is_action_just_pressed("button_a"):
				select_crop.water_crops()
				is_watering = true # 操作をフリーズ
				hal_sprite.play("water")
				await get_tree().create_timer(1.0).timeout
				is_watering = false # 操作を再開

	var value :Vector2 = Input.get_vector("left_stick_left", "left_stick_right", "left_stick_up", "left_stick_down")

	if value == Vector2.ZERO:
		hal_sprite.play("idle")
	else:
		hal_sprite.play("walk")
		# TODO: play_sound_effect(walk_sound)
		hal_sprite.flip_h = value.x < 0
		# TODO: ほんとは武器の向きも反転させたい
		#weapon_sprite_2d.visible = false
		collision_shape.scale.y = -1 if value.x < 0 else 1

	velocity = value * SPEED
	move_and_slide()


#func _physics_process(delta: float) -> void:
	#if ray_cast.is_colliding():
		#var colider := ray_cast.get_collider()
		#if colider is Turnip:
			#colider.select()
			#print(ray_cast.get_collider()) # TODO: 

func _on_cell_area_2d_body_entered(body: Node2D) -> void:
	if body is Turnip:
		crops.append(body)

func _on_cell_area_2d_body_exited(body: Node2D) -> void:
	if body is Turnip:
		body.unselect()
		crops.erase(body)

# public
func damage(enemy_atk: int) -> void:
	player_battle.damage(enemy_atk)

func receive_exp(monster_exp: int) -> void:
	player_battle.receive_exp(monster_exp)

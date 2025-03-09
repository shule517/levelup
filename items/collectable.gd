class_name Collectable
extends CharacterBody2D

@export var item_resource: Item
@export var collect_sound: AudioStream
@onready var player: Player = get_tree().get_nodes_in_group("Player")[0]

const SPEED: float = 80.0
var is_collect: bool = false

@export var gravity: float = 800  # 重力加速度
@export var bounce_power: float = -200  # 最初のバウンド力
@export var float_time: float = 0.1  # 浮遊する時間
@export var drag: float = 0.98  # 空中での速度減衰

var velocity_y: float = 0  # 落下速度
var floating: bool = true
var ground_y: float = 0  # 地面の高さ

func _ready() -> void:
	ground_y = position.y + 2 # アイテムの着地高さを取得
	await get_tree().create_timer(float_time).timeout  # 少し浮遊する
	floating = false  # 落下開始
	velocity.y = -200
	velocity.x = randf_range(-50.0, 50.0)

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	velocity.x *= 0.97

	# 地面に到達したらバウンド
	if position.y >= ground_y:
		position.y = ground_y
		velocity.y = bounce_power  # 反発させる
		bounce_power *= 0.6  # バウンドを小さくしていく

		# ある程度バウンドが小さくなったら停止
		if abs(bounce_power) < 5:
			floating = false
			velocity.y = 0
			bounce_power = 0

	move_and_slide()

	#velocity_y -= gravity * delta  # ゆっくり浮遊
	#position.y += velocity_y * delta  # Y方向に移動
#
	## 地面に到達したらバウンド
	#if position.y >= ground_y:
		#position.y = ground_y
		#velocity_y = bounce_power  # 反発させる
		#bounce_power *= 0.6  # バウンドを小さくしていく
#
		## ある程度バウンドが小さくなったら停止
		#if abs(bounce_power) < 5:
			#floating = false
			#velocity_y = 0
			#bounce_power = 0

#func _process(delta: float) -> void:
	#if not floating and is_collect:
		## プレイヤーの位置に向かって進む
		#var direction := (player.position - position).normalized()
#
		## 移動処理
		#velocity = direction * SPEED
		#move_and_slide()

func collect(inventory: Inventory) -> void:
	is_collect = true

func _on_area_2d_area_entered(area: Area2D) -> void:
	if not floating and area.name == "ItemGetArea2D":
		player.inventory.insert(item_resource, 1)
		Audio.play_sound_effect(collect_sound, self, randf_range(0.8, 1.5))
		queue_free()

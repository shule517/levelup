class_name Item
extends CharacterBody2D

@export var item_resource: ItemResource
@export var collect_sound: AudioStream
@onready var player: Player = get_tree().get_nodes_in_group("Player")[0]

const SPEED: float = 80.0
var is_collecting: bool = false

@export var gravity: float = 800  # 重力加速度
@export var bounce_power: float = -200  # 最初のバウンド力
@export var float_time: float = 0.1  # 浮遊する時間
@export var drag: float = 0.98  # 空中での速度減衰

var velocity_y: float = 0  # 落下速度
var floating: bool = true
var ground_y: float = 0  # 地面の高さ
var is_entered: bool = false

func _ready() -> void:
	ground_y = position.y + 2 # アイテムの着地高さを取得
	await get_tree().create_timer(float_time).timeout  # 少し浮遊する
	velocity.y = -100
	velocity.x = randf_range(-50.0, 50.0)

func _physics_process(delta: float) -> void:
	# 空中にいる時のアニメーション
	if not floating:
		return

	velocity.y += gravity * delta
	velocity.x *= 0.95

	# 地面に到達したらバウンド
	if position.y >= ground_y:
		position.y = ground_y
		velocity.y = bounce_power  # 反発させる
		bounce_power *= 0.6  # バウンドを小さくしていく

		if abs(bounce_power) < abs(-200 * 0.6 * 0.6):
			floating = false

		# ある程度バウンドが小さくなったら停止
		if abs(bounce_power) < 5:
			velocity.y = 0
			bounce_power = 0

	move_and_slide()

func _process(delta: float) -> void:
	if floating:
		return
	
	# アイテムGET
	if is_entered:
		get_item()

	if is_collecting:
		# プレイヤーの位置に向かって進む
		var direction := (player.position - position).normalized()

		# 移動処理
		velocity = direction * SPEED
		move_and_slide()

func collect(inventory: Inventory) -> void:
	is_collecting = true

# アイテムGET
func get_item() -> void:
	player.inventory.insert(item_resource, 1)
	Audio.play_sound_effect(collect_sound, self, randf_range(0.8, 1.5))
	queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "ItemGetArea2D":
		is_entered = true

func _on_area_2d_area_exited(area: Area2D) -> void:
	pass
	#is_entered = false

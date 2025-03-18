extends CharacterBody2D

@export var speed: float = 20.0  # 最大速度
@export var acceleration: float = 2.0  # 加速度
@export var max_offset: float = 0.5  # 上下移動の範囲

var direction: int = 1  # 1: 下方向, -1: 上方向
var velocity_y: float = 0.0  # 現在の速度
var sprite_start_offset: Vector2 = Vector2.ZERO  # 初期の offset

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D  # 見た目を動かすノード
@onready var player: Player = Player.get_instance()
const SPEED: float = 20.0
@export var stop_distance: float = 20.0  # この距離以内に近づいたら停止
@export var follow_delay: float = 0.8  # 追従を再開するまでの遅延時間（秒）
var is_following: bool = true  # 追従状態
var time_since_left: float = 0.0  # 離れてからの経過時間

func _ready() -> void:
	sprite_start_offset = sprite.offset  # 初期 offset を保存

func _physics_process(delta: float) -> void:
	var target_offset_y: float = sprite_start_offset.y + direction * max_offset

	# 目標地点に向かって加速
	if direction == 1 and sprite.offset.y < target_offset_y:
		velocity_y += acceleration * delta
	elif direction == -1 and sprite.offset.y > target_offset_y:
		velocity_y -= acceleration * delta

	# 最大速度を制限
	velocity_y = clamp(velocity_y, -speed, speed)

	# offset のみ変更して移動
	sprite.offset.y += velocity_y * delta

	# 目標地点に達したら方向を反転
	if direction == 1 and sprite.offset.y >= target_offset_y:
		direction = -1
	elif direction == -1 and sprite.offset.y <= sprite_start_offset.y:
		direction = 1

func _process(delta: float) -> void:
	var distance_to_player: float = position.distance_to(player.position)

	if distance_to_player <= stop_distance:
		# 慣性を持たせながら徐々に停止
		is_following = false
		time_since_left = 0.0  # 離れた時間をリセット
		velocity = velocity.move_toward(Vector2.ZERO, acceleration * delta)
	else:
		if not is_following:
			# 追従を再開するまでの時間をカウント
			time_since_left += delta
			if time_since_left >= follow_delay:
				is_following = true  # 一定時間経過後に追従再開

		if is_following:
			# プレイヤーの位置に向かって徐々に加速して進む
			var direction: Vector2 = (player.position - position).normalized()
			var target_velocity: Vector2 = direction * SPEED
			velocity = velocity.move_toward(target_velocity, acceleration * delta)

	move_and_slide()

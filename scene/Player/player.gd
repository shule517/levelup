class_name Player
extends CharacterBody2D

@export_group("SE")
@export var attack_sound: AudioStream
@export var hit_sound: AudioStream
@export var damage_sound: AudioStream
@export var levelup_sound: AudioStream

# しきい値を設定してスティックの感度を調整
const DEADZONE: float = 0.2
const SPEED: float    = 50.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var overlapping_bodies: Array[Node2D] = []
var target_index: int = 0

var audio_players: Array[AudioStreamPlayer] = []
var current_player_index: int = 0
var before_attack_time: float = Time.get_unix_time_from_system()

func _ready() -> void:
	$WeaponSprite2D.visible = false
	# AudioStreamPlayerノードを作成し、配列に追加
	for i in range(10):
		var player := AudioStreamPlayer.new()
		add_child(player)
		audio_players.append(player)

func play_sound_effect(sound_effect: AudioStream) -> void:
	# 現在のAudioStreamPlayerを取得し再生
	var player: AudioStreamPlayer = audio_players[current_player_index]
	player.stream = sound_effect
	player.play()

	# 次に使うAudioStreamPlayerを切り替え
	current_player_index = (current_player_index + 1) % audio_players.size()

func select_target() -> void:
	for i in overlapping_bodies:
		i.set_is_selected(false)

	if !overlapping_bodies.is_empty():
		select_body() && select_body().set_is_selected(true)

func select_body() -> Node2D:
	overlapping_bodies = overlapping_bodies.filter(func(node: Node2D) -> bool: return node.is_alive())
	if !overlapping_bodies.is_empty():
		return overlapping_bodies[target_index % overlapping_bodies.size()]
	return null

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy") && body.is_alive():
		overlapping_bodies.append(body)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		overlapping_bodies.erase(body)
		body.set_is_selected(false)

var attack_target: Node2D = null
func start_atack() -> void:
	if Time.get_unix_time_from_system() - before_attack_time > 1.4:
		attack_target = select_body()
		$WeaponSprite2D.visible = true
		attack()

var floating_damage_scene: PackedScene = preload("res://scene/FloatingDamage/floating_damage.tscn")
func damage(damage: int) -> void:
	play_sound_effect(damage_sound)
	var floating_damage: FloatingDamage = floating_damage_scene.instantiate()
	floating_damage.init(damage, true)
	add_child(floating_damage)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("button_left"):
		target_index += 1

	if Input.is_action_just_pressed("button_right"):
		target_index -= 1

	if Input.is_action_just_pressed("button_a"):
		start_atack()

	# 攻撃ターゲットがいる場合は、すぐに攻撃をはじめる
	if attack_target != null:
		start_atack()

	select_target()

	var value :Vector2 = Input.get_vector("left_stick_left", "left_stick_right", "left_stick_up", "left_stick_down")

	# 移動したら、攻撃をキャンセルする
	if not (value.x == 0 && value.y == 0):
		attack_target = null
		$WeaponSprite2D.visible = false

	if is_instance_valid(attack_target):
		var distance: float = attack_target.position.distance_to(position)
		if 20 < distance:
			value = (attack_target.position - position).normalized()

	if (value.x == 0 && value.y == 0):
		sprite.play("idle")
	else:
		sprite.play("walk")
		sprite.flip_h = value.x < 0
		$WeaponSprite2D.visible = false

	velocity = value * SPEED
	move_and_slide()

func attack() -> void:
	if is_instance_valid(attack_target) && attack_target.is_alive():
		var distance: float = position.distance_to(attack_target.position)
		if distance <= 20:
			before_attack_time = Time.get_unix_time_from_system()

			$AtackTimer.stop()
			$AtackTimer.start()

			$AnimationPlayer.stop()
			$AnimationPlayer.play("attack")
			play_sound_effect(attack_sound) # 攻撃
			await get_tree().create_timer(0.2).timeout
			if is_instance_valid(attack_target):
				attack_target.damage(randi_range(10, 99))
			play_sound_effect(hit_sound) # 敵にHIT
	else:
		$WeaponSprite2D.visible = false

var levelup_table: Array[int] = [1, 3, 5, 8, 11, 14, 17, 20, 25, 32, 38, 44, 52, 60, 76, 86, 97, 109, 122]
var player_exp: int = 0
var player_level: int = 1
func receive_exp(monster_exp: int) -> void:
	player_exp += monster_exp
	print("経験値をGET: %d -> 現在のレベル: %d -> next: %d" % [monster_exp, player_level, next_exp() - player_exp])
	if can_levelup():
		levelup()

func levelup() -> void:
	player_level += 1
	player_exp = 0
	play_sound_effect(levelup_sound)
	print("levelup!!!!!! %d levelになった!!" % player_level)

func can_levelup() -> bool:
	return next_exp() <= player_exp

func next_exp() -> int:
	return levelup_table[player_level - 1]

func _on_atack_timer_timeout() -> void:
	attack()

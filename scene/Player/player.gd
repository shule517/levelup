class_name Player
extends CharacterBody2D

@export_group("SE")
@export var attack_sound: AudioStream
@export var hit_sound: AudioStream
@export var damage_sound: AudioStream
@export var levelup_sound: AudioStream
@export var walk_sound: AudioStream
@export var critical_sound: AudioStream

#@export var player_max_hp: int = 28
#@export var player_hp: int = 28
#@export var player_atk: int = 11
#@export var player_def: int = 3
#@export var player_exp: int = 0
#@export var player_next_exp: int = 1
#@export var player_level: int = 1

@onready var global: GlobalAutoLoad = get_node("/root/Global")

# しきい値を設定してスティックの感度を調整
const DEADZONE: float = 0.2
const SPEED: float    = 50.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var visible_enemies: Array[Enemy] = []
var target_index: int = 0

var audio_players: Array[AudioStreamPlayer] = []
var current_player_index: int = 0
var before_attack_time: float = Time.get_unix_time_from_system()

# 初期化
func _ready() -> void:
	$WeaponSprite2D.visible = false
	# AudioStreamPlayerノードを作成し、配列に追加
	for i in range(10):
		var player := AudioStreamPlayer.new()
		add_child(player)
		audio_players.append(player)

# メインループ
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("button_plus"):
		levelup()

	if Input.is_action_just_pressed("button_minus"):
		global.player_hp = 1

	if Input.is_action_just_pressed("button_left"):
		target_index += 1

	if Input.is_action_just_pressed("button_right"):
		target_index -= 1

	if Input.is_action_just_pressed("button_a"):
		attack_target = selected_enemy()

	# 攻撃ターゲットがいる場合は、すぐに攻撃をはじめる
	if attack_target != null:
		attack()

	# HPバーの更新
	$HpProgressBar.value = global.player_hp * 100 / global.player_max_hp

	# 選択していることをEnemyに伝える
	select_enemy()

	var value :Vector2 = Input.get_vector("left_stick_left", "left_stick_right", "left_stick_up", "left_stick_down")

	# 移動したら、攻撃をキャンセルする
	if value != Vector2.ZERO:
		attack_target = null
		$WeaponSprite2D.visible = false

	if is_instance_valid(attack_target):
		var distance: float = attack_target.position.distance_to(position)
		if 20 < distance:
			value = (attack_target.position - position).normalized()

	if value == Vector2.ZERO:
		sprite.play("idle")
	else:
		sprite.play("walk")
		# TODO: play_sound_effect(walk_sound)
		sprite.flip_h = value.x < 0
		# TODO: ほんとは武器の向きも反転させたい
		$WeaponSprite2D.visible = false

	velocity = value * SPEED
	move_and_slide()

func play_sound_effect(sound_effect: AudioStream, volume_db: float = 0.0) -> void:
	# 現在のAudioStreamPlayerを取得し再生
	var audio_player: AudioStreamPlayer = audio_players[current_player_index]
	audio_player.stream = sound_effect
	audio_player.volume_db = volume_db
	audio_player.play()

	# 次に使うAudioStreamPlayerを切り替え
	current_player_index = (current_player_index + 1) % audio_players.size()

func select_enemy() -> void:
	for i in visible_enemies:
		i.set_is_selected(false)

	if selected_enemy() != null:
		selected_enemy().set_is_selected(true)

func selected_enemy() -> Enemy:
	visible_enemies = visible_enemies.filter(func(node: Node2D) -> bool: return node.is_alive())
	if not visible_enemies.is_empty():
		return visible_enemies[target_index % visible_enemies.size()]
	else:
		return null

var attack_target: Enemy = null

func calcurate_player_damege(enemy_atk: int, player_def: int) -> int:
	if randi_range(0, 3) == 0: # 25%で空振り
		return 0
	var min_damage: int = max(enemy_atk - player_def, 1)
	return randi_range(min_damage, min_damage + global.player_level)

func calcurate_enemy_damege(player_atk: int, enemy_def: int) -> int:
	var min_damage: int = max(player_atk - enemy_def, 1)
	if randi_range(0, 2) == 0: # 33%でクリティカル
		min_damage = ceil(min_damage * 2.0)
		play_sound_effect(critical_sound)
	return randi_range(min_damage, min_damage + global.player_level)

var floating_damage_scene: PackedScene = preload("res://scene/FloatingDamage/floating_damage.tscn")
func damage(enemy_atk: int) -> void:
	var damage: int = calcurate_player_damege(enemy_atk, global.player_def)
	if damage != 0:
		play_sound_effect(damage_sound, -3.0)
		# ダメージ受けた時の振動
		Input.start_joy_vibration(0, 0, 0.8, 0.1)
		global.player_hp -= damage

	var floating_damage: FloatingDamage = floating_damage_scene.instantiate()
	floating_damage.init(damage, true)
	add_child(floating_damage)

	if global.player_hp <= 0:
		await get_tree().create_timer(1.0).timeout
		global.player_hp = global.player_max_hp
		global.load_home_scene()

func attack() -> void:
	if Time.get_unix_time_from_system() - before_attack_time < 1.4:
		return

	if is_instance_valid(attack_target) && attack_target.is_alive():
		$WeaponSprite2D.visible = true
		var distance: float = position.distance_to(attack_target.position)
		if distance <= 20:
			before_attack_time = Time.get_unix_time_from_system()

			# 攻撃時の振動
			Input.start_joy_vibration(0, 0.3, 0.3, 0.2)
			$AtackTimer.stop()
			$AtackTimer.start()

			$AnimationPlayer.stop()
			$AnimationPlayer.play("attack")
			play_sound_effect(attack_sound) # 攻撃
			await get_tree().create_timer(0.2).timeout
			if is_instance_valid(attack_target):
				attack_target.damage(calcurate_enemy_damege(global.player_atk, attack_target.monster_def))
				play_sound_effect(hit_sound) # 敵にHIT
	else:
		$WeaponSprite2D.visible = false

#var levelup_table: Array[int] = [1, 3, 5, 8, 11, 14, 17, 20, 25, 32, 38, 44, 52, 60, 76, 86, 97, 109, 122]
#var levelup_attack_table: Array[int] = [1, 3, 5, 8, 11, 14, 17, 20, 25, 32, 38, 44, 52, 60, 76, 86, 97, 109, 122]

func receive_exp(monster_exp: int) -> void:
	global.player_exp += monster_exp
	print("経験値をGET: %d -> 現在のレベル: %d -> next: %d" % [monster_exp, global.player_level, next_exp() - global.player_exp])
	if can_levelup():
		levelup()

func levelup() -> void:
	global.player_level += 1

	global.player_max_hp = ceil(global.player_max_hp * 1.49)
	global.player_hp = global.player_max_hp
	global.player_atk = ceil(global.player_atk * 1.48)
	global.player_def = ceil(global.player_def * 1.46)
	global.player_next_exp = ceil(global.player_next_exp * 1.21)
	global.player_exp = 0
	
	#global.player_max_hp = ceil(global.player_max_hp * 1.09)
	#global.player_hp = global.player_max_hp
	#global.player_atk = ceil(global.player_atk * 1.08)
	#global.player_def = ceil(global.player_def * 1.06)
	#global.player_next_exp = ceil(global.player_next_exp * 1.21)
	#global.player_exp = 0

	play_sound_effect(levelup_sound)
	$LevelupAnimatedSprite2D.z_index = 1000
	$LevelupAnimatedSprite2D.play("default")
	print("levelup!!!!!! %d levelになった!!" % global.player_level)

func can_levelup() -> bool:
	return next_exp() <= global.player_exp

func next_exp() -> int:
	return global.player_next_exp

# 攻撃タイミング
func _on_atack_timer_timeout() -> void:
	attack()

# 敵が視野に入った
func _on_view_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy") && body.is_alive():
		visible_enemies.append(body)

# 敵が視野から出た
func _on_view_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		visible_enemies.erase(body)
		body.set_is_selected(false)

# 敵が攻撃範囲に入った
func _on_attack_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.

# 敵が攻撃範囲から出た
func _on_attack_area_2d_body_exited(body: Node2D) -> void:
	pass # Replace with function body.

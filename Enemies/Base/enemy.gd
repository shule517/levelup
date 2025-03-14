@tool
class_name Enemy
extends CharacterBody2D

@export_category("モンスターの基本情報")
@export var monster_name: String = "モンスター"
@export var monster_max_hp: int = 250
var monster_hp: int = 250
@export var monster_exp: int = 1
@export var monster_atk: int = 1
@export var monster_def: int = 1
@export var move_speed: float = 30.0
@export var attack_interval: float = 3.0
@export var attack_distance: float = 18.0
@export var active: bool = true
@export var no_move: bool = false

@export_category("SE")
@export var idle_sound: AudioStream = null
@export var move_sound: AudioStream = null
@export var attack_sound: AudioStream = null
@export var damage_sound: AudioStream = preload("res://enemies/nezumi/やられた声/voice028.wav")
@export var die_sound: AudioStream = preload("res://enemies/nezumi/やられた声/voice017.wav")

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: Player = get_tree().get_nodes_in_group("Player")[0]
@onready var attack_timer: Timer = $AttackTimer
@onready var name_label: Label = $NameLabel
@onready var hp_progress_bar: ProgressBar = $HpProgressBar
@onready var cursor_animated_sprite: AnimatedSprite2D = $CursorAnimatedSprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

var is_hunting := false
var is_walking := false
var walk_to_positon: Vector2 = Vector2.ZERO
var can_attack := false
var new_material := ShaderMaterial.new()

# 初期化
func _ready() -> void:
	if not Engine.is_editor_hint():
		$WalkTimer.wait_time = randi_range(5, 50)
		$WalkTimer.start()

	# 攻撃範囲を設定する
	var shape := CircleShape2D.new()
	shape.radius = attack_distance
	$AttackArea2D/CollisionShape2D.shape = shape

	monster_hp = monster_max_hp
	attack_timer.wait_time = attack_interval
	name_label.visible = false
	name_label.text = monster_name
	name_label.z_index = 100
	
	hp_progress_bar.visible = false
	hp_progress_bar.z_index = 100

	new_material.shader = sprite.material.shader
	sprite.material = new_material
	new_material.set_shader_parameter("enabled", false) # TODO: shaderを殺す

	cursor_animated_sprite.visible = false
	cursor_animated_sprite.play("idle")

# メインループ
func _physics_process(delta: float) -> void:
	if not is_alive():
		return

	# HPバーの更新
	if hp_progress_bar:
		hp_progress_bar.value = int(monster_hp * 100 / monster_max_hp)

	if is_hunting:
		# 移動
		if not can_attack and not no_move:
			play_move_sound()
			sprite.play("walk")
			var direction: Vector2 = (player.global_position - global_position).normalized()
			velocity = direction * move_speed
			sprite.flip_h = direction.x > 0 # キャラの向きをあわせる
			move_and_slide()
	elif is_walking:
		play_move_sound()
		sprite.play("walk")
		var direction: Vector2 = (walk_to_positon - position).normalized()
		velocity = direction * move_speed
		sprite.flip_h = direction.x > 0 # キャラの向きをあわせる
		move_and_slide()
		if position.distance_to(walk_to_positon) < 1.0:
			is_walking = false

	if not sprite.is_playing():
		sprite.play("idle")

func set_is_selected(value: bool) -> void:
	name_label.visible = value
	hp_progress_bar.visible = value
	cursor_animated_sprite.visible = value
	new_material.set_shader_parameter("is_selected", value)

# 歩く音を再生する
var before_play_move_sound_time: float = 0
func play_move_sound() -> void:
	var diff_time: float = Time.get_unix_time_from_system() - before_play_move_sound_time
	if move_sound != null && diff_time > 0.7:
		play_sound_effect(move_sound, -10.0)
		before_play_move_sound_time = Time.get_unix_time_from_system()

# SEを再生する
func play_sound_effect(sound_effect: AudioStream, volume_db: float = 0.0) -> void:
	audio_stream_player_2d.stream = sound_effect
	audio_stream_player_2d.volume_db = volume_db
	audio_stream_player_2d.play()

func is_alive() -> bool:
	return monster_hp > 0

var floating_damage_scene: PackedScene = preload("res://scene/floating_damage/floating_damage.tscn")
func damage(damage: int) -> void:
	if monster_hp <= 0:
		return

	# 攻撃されたら追跡開始
	is_hunting = true

	# ダメージSE
	play_sound_effect(damage_sound)

	# ダメージ表示
	var floating_damage: FloatingDamage = floating_damage_scene.instantiate()
	floating_damage.init(damage, false)
	add_child(floating_damage)

	monster_hp -= damage

	# やっつけた
	if monster_hp <= 0:
		# 経験値GET
		player.receive_exp(monster_exp)

		for i in range(3):
			drop_item()
		
		# 死ぬアニメーション
		sprite.stop()
		play_sound_effect(die_sound)
		var tween := get_tree().create_tween()
		tween.tween_property(sprite, "scale", Vector2(0, 0), 3.0)
		tween.parallel().tween_property(sprite, "modulate", Color(1, 1, 1, 0), 3.0)
		tween.play()
		tween.tween_callback(_destory)
	else:
		$AnimationPlayer.play("damaged")

# TODO: 共通化したい
func drop_item() -> void:
	const ItemScene = preload("res://items/item/item.tscn")
	var item := ItemScene.instantiate()
	item.item_resource = load("res://items/item_resources/seed.tres")
	var base_x := global_position.x
	item.global_position = Vector2(randf_range(base_x - 10, base_x + 10) , global_position.y - 7)
	get_parent().get_parent().add_child(item) # add_childされたら、itemの_readyが動く

func _destory() -> void:
	queue_free()

# 追跡範囲に入った
func _on_view_area_2d_body_entered(body: Node2D) -> void:
	if active && body.is_in_group("Player"):
		is_hunting = true

# 追跡範囲から出た
func _on_view_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_hunting = false

# 攻撃範囲に入った
func _on_attack_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		can_attack = true
		attack_timer.start()

# 攻撃範囲から出た
func _on_attack_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		can_attack = false
		attack_timer.stop()

func _on_attack_timer_timeout() -> void:
	attack()

func attack() -> void:
	if is_hunting && is_alive() && can_attack:
		play_sound_effect(attack_sound)
		sprite.play("attack")
		await get_tree().create_timer(0.3).timeout
		player.damage(monster_atk)

func distance() -> float:
	return position.distance_to(player.position)

func _on_walk_timer_timeout() -> void:
	is_walking = true
	walk_to_positon = position + Vector2(randi_range(-50, 50), randi_range(-50, 50))

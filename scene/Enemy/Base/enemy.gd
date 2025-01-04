@tool
class_name Enemy
extends CharacterBody2D

@export_category("モンスターの基本情報")
@export var monster_name: String = "モンスター"
@export var hp: int = 250
@export var move_speed: float = 30.0
@export var attack_interval: float = 3.0
@export var active: bool = true

@export_category("SE")
@export var idle_sound: AudioStream = null
@export var move_sound: AudioStream = null
@export var attack_sound: AudioStream = null
@export var damage_sound: AudioStream = preload("res://scene/Enemy/Nezumi/やられた声/voice028.wav")
@export var die_sound: AudioStream = preload("res://scene/Enemy/Nezumi/やられた声/voice017.wav")

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: Node = get_tree().get_nodes_in_group("Player")[0]
@onready var attack_timer: Timer = $AttackTimer
@onready var name_label: Label = $NameLabel

var walking: bool = false
var new_material := ShaderMaterial.new()
var floating_damage: PackedScene = preload("res://scene/FloatingDamage/floating_damage.tscn")

func _ready() -> void:
	attack_timer.wait_time = attack_interval
	name_label.visible = false
	name_label.text = monster_name
	name_label.z_index = 100
	new_material.shader = sprite.material.shader
	sprite.material = new_material

	$CursorAnimatedSprite2D.play("idle")

	# AudioStreamPlayerノードを作成し、配列に追加
	for i in range(10):
		var player := AudioStreamPlayer.new()
		add_child(player)
		audio_players.append(player)

func _physics_process(delta: float) -> void:
	new_material.set_shader_parameter("modulate", modulate)

	if active && walking && is_alive():
		# 移動
		var distance: float = player.global_position.distance_to(global_position)

		if distance >= 15.0:
			play_move_sound()
			sprite.play("walk")
			var direction: Vector2 = (player.global_position - global_position).normalized()
			velocity = direction * move_speed
			sprite.flip_h = direction.x > 0 # キャラの向きをあわせる
			move_and_slide()
		#else:
			#sprite.play("idle")
	#else:
		#sprite.play("idle")

	if not sprite.is_playing():
		sprite.play("idle")

func set_is_selected(value: bool) -> void:
	name_label.visible = value
	new_material.set_shader_parameter("is_selected", value)

# 歩く音を再生する
var before_play_move_sound_time: int = 0
func play_move_sound() -> void:
	var diff_time: int = Time.get_unix_time_from_system() - before_play_move_sound_time
	if move_sound != null && diff_time > 0.7:
		play_sound_effect(move_sound, -10.0)
		before_play_move_sound_time = Time.get_unix_time_from_system()

# SEを再生する
var audio_players: Array[AudioStreamPlayer] = []
var current_player_index: int = 0
func play_sound_effect(sound_effect: AudioStream, volume_db: float = 0.0) -> void:
	# 現在のAudioStreamPlayerを取得し再生
	var player: AudioStreamPlayer = audio_players[current_player_index]
	player.stream = sound_effect
	player.volume_db = volume_db
	player.play()

	# 次に使うAudioStreamPlayerを切り替え
	current_player_index = (current_player_index + 1) % audio_players.size()

func is_alive() -> bool:
	return hp > 0

func damage(damage: int) -> void:
	if hp <= 0:
		return

	$AnimationPlayer.play("damaged")
	var text: FloatingDamage = floating_damage.instantiate()
	var str_damage := str(damage)
	var array_str := str_damage.split()
	var str := " ".join(array_str)
	text.text = str
	add_child(text)

	hp -= damage

	# ダメージSE
	play_sound_effect(damage_sound)

	# やっつけたSE
	if hp <= 0:
		play_sound_effect(die_sound)
		var tween := get_tree().create_tween()
		tween.tween_property(sprite, "scale", Vector2(0, 0), 2.0)
		tween.play()
		tween.tween_callback(_destory)

func _destory() -> void:
	queue_free()

# プレイヤーが範囲に入った
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		#set_is_selected(true)
		walking = true

# プレイヤーが範囲から出た
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		#set_is_selected(false)
		walking = false

func _on_attack_timer_timeout() -> void:
	if walking && is_alive():
		play_sound_effect(attack_sound)
		sprite.play("attack")
		player.damage(123)

class_name Enemy
extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: Node = get_tree().get_nodes_in_group("Player")[0]
@export var speed: float = 30.0
@export var active: bool = true

var hp = 250
var walking: bool = false
var new_material = ShaderMaterial.new()

var floating_damage: PackedScene = preload("res://scene/FloatingDamage/floating_damage.tscn")

func _ready() -> void:
	$Label.visible = false
	new_material.shader = sprite.material.shader
	sprite.material = new_material
	
	$CursorAnimatedSprite2D.play("idle")

	# AudioStreamPlayerノードを作成し、配列に追加
	for i in range(10):
		var player = AudioStreamPlayer.new()
		add_child(player)
		audio_players.append(player)

func _physics_process(delta: float) -> void:
	new_material.set_shader_parameter("modulate", modulate)

	if active && walking && is_alive():
		# 移動
		var distance = player.global_position.distance_to(global_position)

		if distance >= 15.0:
			sprite.play("walk")
			var direction = (player.global_position - global_position).normalized()
			velocity = direction * speed
			sprite.flip_h = direction.x > 0 # キャラの向きをあわせる
			move_and_slide()
		else:
			sprite.play("idle")
	else:
		sprite.play("idle")

func set_is_selected(value: bool) -> void:
	$Label.visible = value
	new_material.set_shader_parameter("is_selected", value)

var audio_players: Array = []
var current_player_index = 0

func play_sound_effect(sound_effect):
	# 現在のAudioStreamPlayerを取得し再生
	var player = audio_players[current_player_index]
	player.stream = sound_effect
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
	var str_damage = str(damage)
	var array_str = str_damage.split()
	var str = " ".join(array_str)
	text.text = str
	#text.text = String(Array(.split())).join(" ")
	#text.text = ["1 3", "3 2", "4 2"].pick_random()
	var root = get_tree().root
	#text.position = position
	#root.add_child(text)
	add_child(text)

	hp -= damage

	play_sound_effect(preload("res://scene/Enemy/Nezumi/やられた声/voice028.wav")) # damage

	# やっつけた
	if hp <= 0:
		play_sound_effect(preload("res://scene/Enemy/Nezumi/やられた声/voice017.wav")) # やられた
		var tween = get_tree().create_tween()
		#tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUART)
		#tween.tween_property(sprite, "modulate", Color(1.0, 1.0, 1.0, 0.5), 2.0)
		tween.tween_property(sprite, "scale", Vector2(0, 0), 2.0)
		tween.play()
		tween.tween_callback(_destory)
		#await get_tree().create_timer(2.0).timeout

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

func _on_timer_timeout() -> void:
	if !walking:
		pass

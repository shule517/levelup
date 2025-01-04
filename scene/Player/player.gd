extends CharacterBody2D

# しきい値を設定してスティックの感度を調整
const DEADZONE: float = 0.2
const SPEED: float    = 50.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var overlapping_bodies = []
var target_index = 0

var audio_players: Array = []
var current_player_index = 0
var before_attack_time = Time.get_unix_time_from_system()

func _ready():
	$WeaponSprite2D.visible = false
	# AudioStreamPlayerノードを作成し、配列に追加
	for i in range(10):
		var player = AudioStreamPlayer.new()
		add_child(player)
		audio_players.append(player)

func play_sound_effect(sound_effect: AudioStream):
	# 現在のAudioStreamPlayerを取得し再生
	var player = audio_players[current_player_index]
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
	overlapping_bodies = overlapping_bodies.filter(func(a): return a.is_alive())
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

var attack_target = null

func _process(_delta):
	if Input.is_action_just_pressed("button_left"):
		target_index += 1

	if Input.is_action_just_pressed("button_right"):
		target_index -= 1

	if Input.is_action_just_pressed("button_a"):
		if Time.get_unix_time_from_system() - before_attack_time > 1.4:
			attack_target = select_body()
			$WeaponSprite2D.visible = true
			attack()
			$AtackTimer.start()

	select_target()

	var value :Vector2 = Input.get_vector("left_stick_left", "left_stick_right", "left_stick_up", "left_stick_down")

	if (value.x == 0 && value.y == 0):
		pass
	else:
		attack_target = null
		$WeaponSprite2D.visible = false

	if is_instance_valid(attack_target):
		var distance = attack_target.position.distance_to(position)
		if 20 < distance:
			value = (attack_target.position - position).normalized()
			#print(value)
		else:
			pass
			#print("20 >= distance")
	else:
		pass
		#print("attack_target is null")

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
		var distance = position.distance_to(attack_target.position)
		if distance <= 20:
			before_attack_time = Time.get_unix_time_from_system()
			$AnimationPlayer.stop()
			$AnimationPlayer.play("attack")
			play_sound_effect(preload("res://scene/Player/se/tm2_swing006.wav")) # 攻撃
			await get_tree().create_timer(0.2).timeout
			is_instance_valid(attack_target) && attack_target.damage(randi_range(10, 99))
			play_sound_effect(preload("res://scene/Player/se/hit_p07.wav")) # 敵にHIT
			#play_sound_effect(preload("res://scene/Player/se/決定ボタンを押す46.mp3"))
	else:
		$WeaponSprite2D.visible = false

func _on_atack_timer_timeout() -> void:
	attack()

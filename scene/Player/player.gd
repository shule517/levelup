extends CharacterBody2D

# しきい値を設定してスティックの感度を調整
const DEADZONE: float = 0.2
const SPEED: float    = 50.0

#func _input(event: InputEvent) -> void:
	#print(event)

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

func play_sound_effect(sound_effect):
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
		select_body().set_is_selected(true)

func select_body() -> Node2D:
	if !overlapping_bodies.is_empty():
		return overlapping_bodies[target_index % overlapping_bodies.size()]
	return null

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy") && body.is_alive():
		overlapping_bodies.append(body)
		#select_target()
		#for i in overlapping_bodies:
			#i.set_is_selected(false)	

		#overlapping_bodies.sort_custom(func(a, b): return global_position.distance_to(a.global_position) < global_position.distance_to(b.global_position))
		#var nearest_body = overlapping_bodies[0]

		#var nearest_body = overlapping_bodies.min(func(body): 
			#return global_position.distance_to(body.global_position)
		#)
			
		#nearest_body.set_is_selected(true)
		print(overlapping_bodies)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		overlapping_bodies.erase(body)
		#select_target()
		body.set_is_selected(false)
		print(overlapping_bodies)

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
			print(value)
		else:
			print("20 >= distance")
	else:
		print("attack_target is null")

	if (value.x == 0 && value.y == 0):
		sprite.play("idle")
	else:
		sprite.play("walk")
		sprite.flip_h = value.x < 0
		$WeaponSprite2D.visible = false

	velocity = value * SPEED
	print("velocity: %s" % velocity)
	#velocity.x += value.x * SPEED
	#print(str(value))
	move_and_slide()

	#var left_stick_x = Input.get_joy_axis(0, JOY_AXIS_LEFT_X)
	#var left_stick_y = Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)
	#print(left_stick_y)
	
	#if abs(left_stick_x) > DEADZONE:
		#if left_stick_x > 0:
			#print("Right")
		#else:
			#print("Left")
	#
	#if abs(left_stick_y) > DEADZONE:
		#if left_stick_y > 0:
			#print("Down")
		#else:
			#print("Up")

#extends CharacterBody2D
#
#
#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0
#
## Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = 0 #ProjectSettings.get_setting("physics/2d/default_gravity")
#
#func _ready():
	#Input.joy_connection_changed.connect(_on_joy_connection_changed)
#
#func _on_joy_connection_changed(device:int, connected:bool):
	#if not connected:
		#print("デバイス%sのゲームパッドが切断されました" % str(device))
	#elif connected:
		#print("デバイス%sのゲームパッドが接続されました" % str(device))
##func _input(event):
	##print(event)
#
##func _process(delta):
	##var value :Vector2 = Input.get_vector("left_stick_right", "left_stick_left", "left_stick_up", "left_stick_down")
	##print(str(value))
#
#func _unhandled_input(event):
	#print(event)
	##if event is InputEventKey:
		##if event.pressed and event.scancode == KEY_ESCAPE:
			##get_tree().quit()
#
##func _physics_process(delta):
	##move_and_slide()
#
#
##func _physics_process(delta):
	### Add the gravity.
	##if not is_on_floor():
		##velocity.y += gravity * delta
##
	### Handle jump.
	##if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		##velocity.y = JUMP_VELOCITY
##
	### Get the input direction and handle the movement/deceleration.
	### As good practice, you should replace UI actions with custom gameplay actions.
	##var direction = Input.get_axis("ui_left", "ui_right")
	##if direction:
		##velocity.x = direction * SPEED
	##else:
		##velocity.x = move_toward(velocity.x, 0, SPEED)
##
	##move_and_slide()

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

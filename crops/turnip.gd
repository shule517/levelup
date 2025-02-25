@tool
class_name Turnip
extends Node2D

# TODO: Cropを継承したい

@export var harvest_sound: AudioStream
@export var water_sound: AudioStream
@onready var seed_sprite: AnimatedSprite2D = $SeedAnimatedSprite2D
@onready var crop_sprite: AnimatedSprite2D = $CropAnimatedSprite2D
@onready var need_water_sprite: AnimatedSprite2D = $NeedWaterAnimatedSprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var timer: Timer = $Timer
@onready var player: Player = get_tree().get_nodes_in_group("Player")[0]

var is_selected: bool = false
var has_water: bool = false

func _ready() -> void:
	seed_sprite.visible = true
	seed_sprite.frame = randi_range(0, 3) # 種4種類ランダム
	crop_sprite.visible = false
	
	need_water_sprite.visible = false # 水がほしいを消す

	# TODO: 作物をランダムに設定する
	#var animation_names := crop_sprite.sprite_frames.get_animation_names()
	#crop_sprite.play(animation_names[randi_range(0, animation_names.size() - 1)], 0)
	crop_sprite.play("turnip", 0)

	var new_material := ShaderMaterial.new()
	new_material.shader = crop_sprite.material.shader
	crop_sprite.material = new_material

	var new_seed_material := ShaderMaterial.new()
	new_seed_material.shader = seed_sprite.material.shader
	seed_sprite.material = new_seed_material

func _process(delta: float) -> void:
	# 土の水分状態を更新
	$GroundAnimatedSprite2D.frame = 2 if has_water else 1

	## 水マークの更新
	if is_selected and need_water():
		set_chader_selected(true)
		need_water_sprite.visible = true
	else:
		set_chader_selected(false)
		need_water_sprite.visible = false

	#if can_harvest():
		#if is_selected && Input.is_action_pressed("button_a"):
			#harvest()
	#elif need_water():
		#if is_selected && Input.is_action_pressed("button_a"):
			#water_crops()

func select() -> void:
	is_selected = true

func unselect() -> void:
	set_chader_selected(false)
	is_selected = false

func set_chader_selected(enabled: bool) -> void:
	crop_sprite.material.set_shader_parameter("enabled", enabled)
	crop_sprite.material.set_shader_parameter("is_selected", enabled)
	seed_sprite.material.set_shader_parameter("enabled", enabled)
	seed_sprite.material.set_shader_parameter("is_selected", enabled)

# 収穫可能か？
func can_harvest() -> bool:
	# 最大フレームまでいったか？
	return crop_sprite.frame == (crop_sprite.sprite_frames.get_frame_count(crop_sprite.animation) - 1)

# 収穫する
func harvest() -> void:
	Global.tunip_count += 1
	Audio.play_sound_effect(harvest_sound, self, randf_range(0.8, 1.5))
	queue_free()

func need_water() -> bool:
	return not can_harvest() and not has_water

# 水を上げる
func water_crops() -> void:
	Audio.play_sound_effect(water_sound, self, randf_range(0.8, 1.1))
	has_water = true

	unselect()
	timer.start()

#func _on_area_2d_body_entered(body: Node2D) -> void:
	## TODO: 収穫処理はここで書くのがいいのか？ Playerからキックしたほうがいい？
	#if body.is_in_group("Player"):
		#is_selected = true
		#if can_harvest() or need_water():
			#crop_sprite.material.set_shader_parameter("enabled", true)
			#crop_sprite.material.set_shader_parameter("is_selected", true)
			#seed_sprite.material.set_shader_parameter("enabled", true)
			#seed_sprite.material.set_shader_parameter("is_selected", true)
#
#func _on_area_2d_body_exited(body: Node2D) -> void:
	#if body.is_in_group("Player"):
		#is_selected = false
		#crop_sprite.material.set_shader_parameter("enabled", false)
		#crop_sprite.material.set_shader_parameter("is_selected", false)
		#seed_sprite.material.set_shader_parameter("enabled", false)
		#seed_sprite.material.set_shader_parameter("is_selected", false)

# 植物の成長
func _on_timer_timeout() -> void:
	timer.stop()
	has_water = false
	if seed_sprite.visible:
		# 種から芽が生えた
		seed_sprite.visible = false
		crop_sprite.visible = true
		crop_sprite.frame = 0
	else:
		# 芽が成長
		crop_sprite.frame += 1

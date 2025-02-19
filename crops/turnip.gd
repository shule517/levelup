@tool
class_name Turnip
extends Node2D

# TODO: Cropを継承したい

@export var sound: AudioStream
@onready var seed_sprite: AnimatedSprite2D = $SeedAnimatedSprite2D
@onready var crop_sprite: AnimatedSprite2D = $CropAnimatedSprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var player: Player = get_tree().get_nodes_in_group("Player")[0]

var is_selected: bool = false

func _ready() -> void:
	seed_sprite.visible = true
	seed_sprite.frame = randi_range(0, 3) # 種4種類ランダム
	crop_sprite.visible = false

	var new_material := ShaderMaterial.new()
	new_material.shader = crop_sprite.material.shader
	crop_sprite.material = new_material

func _process(delta: float) -> void:
	if is_selected && can_harvest():
		if Input.is_action_pressed("button_a"):
			harvest()

# 収穫可能か？
func can_harvest() -> bool:
	# 最大フレームまでいったか？
	return crop_sprite.frame == (crop_sprite.sprite_frames.get_frame_count(crop_sprite.animation) - 1)

# 収穫する
func harvest() -> void:
	Audio.play_sound_effect(sound, self, randf_range(0.8, 1.5))
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	# TODO: 収穫処理はここで書くのがいいのか？ Playerからキックしたほうがいい？
	if body.is_in_group("Player"):
		is_selected = true
		if can_harvest():
			crop_sprite.material.set_shader_parameter("enabled", true)
			crop_sprite.material.set_shader_parameter("is_selected", true)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_selected = false
		crop_sprite.material.set_shader_parameter("enabled", false)
		crop_sprite.material.set_shader_parameter("is_selected", false)

# 植物の成長
func _on_timer_timeout() -> void:
	if seed_sprite.visible:
		# 種から芽が生えた
		seed_sprite.visible = false
		crop_sprite.visible = true
		crop_sprite.frame = 0
	else:
		# 芽が成長
		crop_sprite.frame += 1

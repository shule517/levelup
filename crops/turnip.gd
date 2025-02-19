@tool
class_name Turnip
extends Node2D

@export var sound: AudioStream
@onready var seed_sprite: AnimatedSprite2D = $SeedAnimatedSprite2D
@onready var crop_sprite: AnimatedSprite2D = $CropAnimatedSprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var player: Player = get_tree().get_nodes_in_group("Player")[0]

func _ready() -> void:
	seed_sprite.visible = true
	seed_sprite.frame = randi_range(0, 3)
	crop_sprite.visible = false
	audio_stream_player_2d.finished.connect(_on_finished)

func level() -> int:
	return crop_sprite.frame

# メインループ
func _process(_delta: float) -> void:
	pass

func _on_finished() -> void:
	get_parent().remove_child(self) # queue_freeだけしても、参照が残ってしまうため
	queue_free()

# 収穫可能か？
func can_harvest() -> bool:
	# 最大フレームまでいったか？
	return crop_sprite.frame == (crop_sprite.sprite_frames.get_frame_count(crop_sprite.animation) - 1)

func _on_area_2d_body_entered(body: Node2D) -> void:
	# TODO: 収穫処理はここで書くのがいいのか？ Playerからキックしたほうがいい？
	if body.is_in_group("Player") and Input.is_action_pressed("button_a"):
		if can_harvest():
			Audio.play_sound_effect(sound, self, randf_range(0.8, 1.5))
			queue_free()

# TODO: SEを再生する仕組みをAutoloadでやりたい
# TODO: Autoloadですると、このオブジェクトの位置から音を再生。ができなくなるので、
#       音声再生用のNodeをposition付きで生成したほうがよいのでは？
# SEを再生する
func play_sound_effect(sound_effect: AudioStream, pitch_scale: float = 1.0, volume_db: float = 0.0) -> void:
	audio_stream_player_2d.stream = sound_effect
	audio_stream_player_2d.pitch_scale = pitch_scale
	audio_stream_player_2d.volume_db = volume_db
	audio_stream_player_2d.play()
	await audio_stream_player_2d.finished

func _on_timer_timeout() -> void:
	if seed_sprite.visible:
		seed_sprite.visible = false
		crop_sprite.visible = true
		crop_sprite.frame = 0
	else:
		crop_sprite.frame += 1

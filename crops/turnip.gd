@tool
extends Node2D

@export var sound: AudioStream
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	sprite.frame = 0
	audio_stream_player_2d.finished.connect(_on_finished)

func _on_finished() -> void:
	queue_free()

# 収穫可能か？
func is_harvestable() -> bool:
	# 最大フレームまでいったか？
	return sprite.frame == (sprite.sprite_frames.get_frame_count(sprite.animation) - 1)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if 	is_harvestable() and Input.is_action_pressed("button_a"):
			visible = false
			play_sound_effect(sound, randf_range(0.8, 1.5))

# SEを再生する
func play_sound_effect(sound_effect: AudioStream, pitch_scale: float = 1.0, volume_db: float = 0.0) -> void:
	audio_stream_player_2d.stream = sound_effect
	audio_stream_player_2d.pitch_scale = pitch_scale
	audio_stream_player_2d.volume_db = volume_db
	audio_stream_player_2d.play()
	await audio_stream_player_2d.finished

func _on_timer_timeout() -> void:
	sprite.frame += 1

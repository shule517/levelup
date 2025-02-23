extends Node2D

@export var sound: AudioStream
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var is_selected: bool = false

func _process(delta: float) -> void:
	if is_selected and Input.is_action_pressed("button_a"):
		if Global.tunip_count > 0:
			Global.tunip_count -= 1
			Global.tunip_seed_count += 2
			Audio.play_sound_effect(sound, self, randf_range(0.8, 1.5))

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_selected = true
		animated_sprite.play()

func _on_area_2d_body_exited(body: Node2D) -> void:
	is_selected = false
	animated_sprite.play_backwards()
	#animated_sprite.frame = 0

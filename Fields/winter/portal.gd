extends Node2D

@export var audio_stream :AudioStream
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var shader_material: ShaderMaterial = ShaderMaterial.new()

func _process(delta: float) -> void:
	animated_sprite.play("default")

	shader_material.shader = animated_sprite.material.shader
	animated_sprite.material = shader_material

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Audio.play_sound_effect(audio_stream, self)
		shader_material.set_shader_parameter("enabled", true)
		shader_material.set_shader_parameter("is_selected", true)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		shader_material.set_shader_parameter("is_selected", false)

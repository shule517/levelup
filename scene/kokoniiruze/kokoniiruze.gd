extends Node2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var message_animated_sprite: AnimatedSprite2D = $MessageSprite2D

var is_selected: bool = false
var is_crying: bool = false

func _ready() -> void:
	animated_sprite.play("idle")
	message_animated_sprite.play("idle")
	#animated_sprite.play("default")

func _process(delta: float) -> void:
	if is_selected:
		if Input.is_action_just_pressed("button_a"):
			is_crying = true

		if is_crying:
			animated_sprite.play("cry")
			message_animated_sprite.play("cry")
		else:
			animated_sprite.play("default")
			message_animated_sprite.play("default")
	else:
		animated_sprite.play("idle")
		message_animated_sprite.play("idle")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_selected = true
		message_animated_sprite.material.set_shader_parameter("is_selected", true)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_selected = false
		is_crying = false
		message_animated_sprite.material.set_shader_parameter("is_selected", false)

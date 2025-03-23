extends Node2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var is_selected: bool = false

func _ready() -> void:
	animated_sprite.play("idle")
	#animated_sprite.play("default")


func _process(delta: float) -> void:
	if is_selected:
		if Input.is_action_pressed("button_a"):
			animated_sprite.play("default")
		else:
			animated_sprite.play("cry")
	else:
		animated_sprite.play("idle")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_selected = true
		#animated_sprite.material.set_shader_parameter("is_selected", true)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_selected = false
		#animated_sprite.material.set_shader_parameter("is_selected", false)

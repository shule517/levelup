extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: Node = get_tree().get_nodes_in_group("Player")[0]
@export var speed: float = 20.0

var walking: bool = false

func _physics_process(delta: float) -> void:
	if walking:
		var distance = player.global_position.distance_to(global_position)
		if distance >= 15.0:
			sprite.play("walk")
			# 移動
			var direction = (player.global_position - global_position).normalized()
			velocity = direction * speed
			sprite.flip_h = direction.x > 0 # キャラの向きをあわせる
			move_and_slide()
		else:
			sprite.play("idle")
	else:
		sprite.play("idle")

func set_is_selected(value: bool) -> void:
	pass
	#new_material.set_shader_parameter("is_selected", value)

# プレイヤーが範囲に入った
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		walking = true

# プレイヤーが範囲から出た
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		walking = false

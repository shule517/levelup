extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var target: Node = get_parent().get_node("Player")

#func _process(_delta):
	#print(target.position)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		sprite.play("idle")
	else:
		sprite.play("sleep")

func _on_area_2d_body_exited(body: Node2D) -> void:
	await get_tree().create_timer(1).timeout
	sprite.play("sleep")

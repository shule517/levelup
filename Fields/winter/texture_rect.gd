extends TextureRect

func _process(delta: float) -> void:
	var speed: float = 10.0
	position = Vector2(position.x - delta * speed, position.y + delta * speed)

	# ループさせる
	if position.x > -1200.0:
		position = Vector2(-2500.0, -2500.0)

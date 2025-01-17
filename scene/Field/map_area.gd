extends Area2D

@onready var camera: Camera2D = get_tree().get_nodes_in_group("Camera")[0]

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("_on_body_entered")
		var shape: RectangleShape2D = $CollisionShape2D.shape
		var shape_rect: Rect2 = shape.get_rect()
		print(shape_rect)

		# RectangleShape2D の AABB を計算
		var shape_position: Vector2 = $CollisionShape2D.global_position - shape.size / 2
		var shape_size: Vector2 = shape.size

		# カメラのリミットを設定
		camera.limit_left = int(shape_position.x)
		camera.limit_top = int(shape_position.y)
		camera.limit_right = int(shape_position.x + shape_size.x)
		camera.limit_bottom = int(shape_position.y + shape_size.y)
		camera.limit_smoothed = true
		print("camera.limit_left: ", camera.limit_left)
		print("camera.limit_top: ", camera.limit_top)
		print("camera.limit_right: ", camera.limit_right)
		print("camera.limit_bottom: ", camera.limit_bottom)

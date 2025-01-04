extends Marker2D

class_name FloatingDamage

var velocity := Vector2(0,-90)
var gravity := Vector2(0,1.0)
var mass: int = 100
#var text_scale = Vector2.ONE * 1
var text: String:
	get:
		return $Label.text
	set(value):
		$Label.text = value

func _ready() -> void:
	# 初期値
	scale = Vector2.ONE * 1.5

	var tween := create_tween()
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUART)
	# 文字を徐々に透明にする
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0), 2.0)
	# 文字を大きくする
	tween.parallel()
	tween.tween_property(self, "scale", Vector2.ONE * 1, 2.0)
	tween.tween_callback(_destory)

func _process(delta: float) -> void:
	velocity += gravity * mass * delta
	position += velocity * delta
	position.x -= 0.5

func _destory() -> void:
	queue_free()

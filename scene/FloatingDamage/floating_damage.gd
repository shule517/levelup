class_name FloatingDamage
extends Marker2D

var move_x: float = -0.5
var font_color: Color = Color.WHITE

var velocity := Vector2(0, -90)
const GRAVITY := Vector2(0, 1.0)
const MASS: int = 100

var damage: int:
	set(value):
		if value == 0:
			$Label.text = "miss"
		else:
			$Label.text = " ".join(str(value).split()) # 文字と文字の間にスペースを入れる

func set_font_color(color: Color) -> void:
	var label_settings:LabelSettings = $Label.label_settings.duplicate()
	label_settings.font_color = color
	$Label.label_settings = label_settings

func init(damage: int, is_damege := false) -> void:
	self.damage = damage
	if is_damege:
		self.move_x *= -1
		self.font_color = Color.RED

func _ready() -> void:
	set_font_color(font_color)
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
	velocity += GRAVITY * MASS * delta
	position += velocity * delta
	position.x += move_x

func _destory() -> void:
	pass
	#queue_free()

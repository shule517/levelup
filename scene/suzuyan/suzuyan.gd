extends Node

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var message_balloon: MessageBolloon = $MessageBalloon

var is_selected: bool = false

@export var text_list: Array[String] = [
	"ほな、最初に農業の仕方、教えたるで！",
	"わいは『スズやん』っちゅーんや！
	たこ焼きみたいに丸っとしてるけど、ちゃんと畑仕事も得意なんやで！",
	"これからよろしゅうな！
	いろいろ教えたるで～！",
	"おやおや、あんさん畑仕事はじめてか？
	ほなまずは畑からやな！",
	"畑仕事っちゅうくらいやし、まずは畑こしらえなアカンわ！",
	"ええか？ 地面に向かって (Ｙボタン) 押すんや！	間違うたらアカンで〜！",
]

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("button_a"):
		message_balloon.visible = true
		message_balloon.text_list = text_list
		Player.get_instance().can_control = false
		animated_sprite.material.set_shader_parameter("is_selected", false)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_selected = true
		animated_sprite.material.set_shader_parameter("is_selected", true)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_selected = false
		animated_sprite.material.set_shader_parameter("is_selected", false)

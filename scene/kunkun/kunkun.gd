extends Node2D

@onready var kunkun_animated_asprite: AnimatedSprite2D = $KunKunAnimatedSprite2D
@onready var message_balloon: MessageBolloon = $MessageBalloon

var messages: Array[String] = [
	"ｸﾝｸﾝ…	 いいにおいする…", # 最初は顔をつっこんでない。おいしそうなご飯を持ってると、顔を出してきて、イベントがはじまる
	"だ、だれかいるの？",
	"あ…	えっと	 はじめまして…
	くんくんだよ！",
	"あのね、	ぼく、	わんわん だけど、	こわくないよ？",
	"いいにおいする…	 おともだちになれるかな？",
	"えへへ、	うれしいな！	 あなたも、ぼくのこと…	 すきかな？",
	"ほんとに？ 	うれしいな
	これからも	たくさんあそぼうね！",
]

var is_selected: bool = false

func _ready() -> void:
	kunkun_animated_asprite.play("default")
	message_balloon.set_messsage(messages)

func _process(delta: float) -> void:
	if is_selected:
		if Input.is_action_just_pressed("button_a"):
			message_balloon.start()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_selected = true
		#message_animated_sprite.material.set_shader_parameter("is_selected", true)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_selected = false
		#message_animated_sprite.material.set_shader_parameter("is_selected", false)

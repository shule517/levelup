extends Control

@onready var label: Label = $Label
@onready var timer: Timer = $Timer

@export var voice_sounds: Array[AudioStream] = []

var text_list: Array[String] = [
	"わいは『スズやん』っちゅーんや！
	これからよろしゅうな！",
	"おやおや、あんさん畑仕事はじめてか？
	ほなまずは畑からやな！",
	"畑仕事っちゅうくらいやし、まずは畑こしらえなアカンわ！",
	"ええか？ 地面に向かって Yボタン 押すんや！	間違うたらアカンで〜！",
]

var full_text := ""
var current_index := 0
var text_index := 0
var is_typing := false  # 文字送り中かどうか

func _ready() -> void:
	start_typing(text_list[text_index])

func start_typing(text: String) -> void:
	full_text = text
	current_index = 0
	label.text = ""

	# サイズ計算
	label.text = full_text
	label.text = ""  # 表示は空に戻す

	is_typing = true
	timer.start()

func _on_timer_timeout() -> void:
	if current_index < full_text.length():
		var char := full_text[current_index]
		label.text += char
		current_index += 1

		# 改行の後は少し長めに待つ（次の文字送りの前に待つイメージ）
		if char == '\n' or char == '\t':
			timer.start(0.4)  # 改行の時だけ間を空ける
		else:
			play_random_voice()
			timer.start(0.1)  # 通常の文字送り速度
	else:
		is_typing = false
		timer.stop()

func play_random_voice() -> void:
	if voice_sounds.size() > 0:
		Audio.play_sound_effect(voice_sounds[randi() % voice_sounds.size()], self, randf_range(0.8, 1.5))

func _process(delta: float) -> void:
	# Aボタン押したら
	if Input.is_action_just_pressed("button_a"):
		if is_typing:
			# 文字送り中なら全文表示スキップ
			timer.stop()
			label.text = full_text
			is_typing = false
		else:
			# 次のテキストへ進む
			text_index += 1
			if text_index < text_list.size():
				start_typing(text_list[text_index])
			else:
				# すべての文章が終わった
				queue_free()  # 画面から消す

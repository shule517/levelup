class_name MessageBolloon
extends Control

@onready var label: Label = $Label
@onready var timer: Timer = $Timer
@onready var cursor_animated_sprite: AnimatedSprite2D = $CursorAnimatedSprite2D

@export var voice_sounds: Array[AudioStream] = []
var text_list: Array[String] = []

var full_text := ""
var current_index := 0
var text_index := 0
var is_typing := false  # 文字送り中かどうか
var is_talking := false  # 会話中か
var is_start_frame := false

func _ready() -> void:
	cursor_animated_sprite.visible = false
	cursor_animated_sprite.play("default")

func set_messsage(list: Array[String]) -> void:
	text_list = list
	current_index = 0

func start() -> void:
	if not is_start_frame and not is_talking and not text_list.is_empty():
		is_start_frame = true
		is_talking = true
		visible = true
		text_index = 0
		Player.get_instance().can_control = false
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
		if char == '\n' or char == '\t' or char == ' ':
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
	if text_list.is_empty():
		return

	# Cursorを表示する
	cursor_animated_sprite.visible = not is_typing

	# 開始フレームはスキップする
	if is_start_frame:
		is_start_frame = false
		return

	# Aボタン押したら
	if is_talking and Input.is_action_just_pressed("button_a"):
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
				visible = false
				is_typing = false
				is_talking = false
				text_index = 0
				Player.get_instance().can_control = true
				#queue_free()  # 画面から消す

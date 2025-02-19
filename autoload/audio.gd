extends Node

# SEを再生する
func play_sound_effect(sound_effect: AudioStream, node: Node, pitch_scale: float = 1.0, volume_db: float = 0.0) -> void:
	var player := AudioStreamPlayer2D.new()
	player.stream = sound_effect
	player.pitch_scale = pitch_scale
	player.volume_db = volume_db
	player.global_position = node.global_position # 再生位置を設定
	player.autoplay = true
	get_tree().current_scene.add_child(player)

	# 再生終了後に削除
	player.finished.connect(player.queue_free)

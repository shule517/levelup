extends Node2D

@onready var animated_asprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	animated_asprite.play("default")

extends Node2D

@onready var label: Label = $Label
var time: int = 60*8

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	label.text = to_full_width_numbers("%02d%s%02d" % [time/60, ":", time%60])

func _on_timer_timeout() -> void:
	time += 1

func to_full_width_numbers(input: String) -> String:
	return input.replace("0", "０").replace("1", "１").replace("2", "２").replace("3", "３").replace("4", "４").replace("5", "５").replace("6", "６").replace("7", "７").replace("8", "８").replace("9", "９")

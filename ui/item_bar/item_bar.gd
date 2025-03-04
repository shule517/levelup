extends Node2D

@onready var item1_count_label: Label = $Item1CountLabel
@onready var item2_count_label: Label = $Item2CountLabel
@onready var item3_count_label: Label = $Item3CountLabel

@onready var inventory: Inventory = preload("res://items/inventory.tres")

func _process(delta: float) -> void:
	#item1_count_label.text = "%s" % Global.tunip_seed_count
	#item2_count_label.text = "%s" % Global.tunip_count
	#item3_count_label.text = "%s" % Global.gold
	item1_count_label.text = "%s" % inventory.get_item(0)
	item2_count_label.text = "%s" % inventory.get_item(1)
	item3_count_label.text = "%s" % inventory.get_item(2)

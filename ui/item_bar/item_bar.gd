extends Control

@onready var item1_count_label: Label = $Item1CountLabel
@onready var item2_count_label: Label = $Item2CountLabel
@onready var item3_count_label: Label = $Item3CountLabel

@onready var inventory: Inventory = preload("res://items/inventory.tres")
@onready var slots: Array = $GridContainer.get_children() # TODO: Array[ItemSlot]と書きたい

func _process(delta: float) -> void:
	# TODO: inventoryの中身を反映する
	for i in range(len(inventory.items)):
		slots[i].update(inventory.items[i])

	#item1_count_label.text = "%s" % Global.tunip_seed_count
	#item2_count_label.text = "%s" % Global.tunip_count
	#item3_count_label.text = "%s" % Global.gold
	#item1_count_label.text = "%s" % inventory.get_item(0)
	#item2_count_label.text = "%s" % inventory.get_item(1)
	#item3_count_label.text = "%s" % inventory.get_item(2)

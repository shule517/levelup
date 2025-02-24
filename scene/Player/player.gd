class_name Player
extends CharacterBody2D

@onready var player_battle: Node = $PlayerBattle

func damage(enemy_atk: int) -> void:
	player_battle.damage(enemy_atk)

func receive_exp(monster_exp: int) -> void:
	player_battle.receive_exp(monster_exp)

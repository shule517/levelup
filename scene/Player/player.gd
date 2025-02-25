class_name Player
extends CharacterBody2D

@onready var player_battle: Node = $PlayerBattle
@onready var right_ray_cast: RayCast2D = $RightRayCast2D

func _physics_process(delta: float) -> void:
	if right_ray_cast.is_colliding():
		print(right_ray_cast.get_collider()) # TODO: 

func damage(enemy_atk: int) -> void:
	player_battle.damage(enemy_atk)

func receive_exp(monster_exp: int) -> void:
	player_battle.receive_exp(monster_exp)

# Handles sending damage

class_name AttackComponent
extends Node

@export var stats: Stats = null
@export var moveset: Array[Moves] = []

signal attacked(move: Moves)

func _ready():
	if  not stats:
		push_error("Stats invalid!\n At: %s" % [self.get_path()])
		queue_free()
		return
	
func send_attack(target: HealthComponent, move: Moves) -> void:
	var damage = move.raw_damage + stats.attack * move.multiplier
	target.decrease_health(damage, move.type)
	attacked.emit(move)

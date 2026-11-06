# Handles sending damage

class_name AttackComponent
extends Node

@export var attack_target: HealthComponent
@export var moveset: Array[Moves] = []

signal attacked(move: Moves)

func _ready():
	if  not get_stats():
		push_error("Stats invalid!\n At: %s" % [self.get_path()])
		queue_free()
		return

## Returns stats resource from StatsComponent
func get_stats() -> Dictionary:
	if get_parent().has_node("StatsComponent"):
		return get_parent().get_node("StatsComponent").final_stats
	else:
		return {}
	
func send_attack(target: HealthComponent, move: Moves) -> void:
	var damage = move.raw_damage + get_stats()["attack"] * move.multiplier
	target.decrease_health(damage, move.type)
	attacked.emit(move)

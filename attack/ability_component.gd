# Handles abilities

class_name AbilityComponent
extends Node

@export var moveset: Array[Move] = []

signal ability_used(move: Move)

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

func use_ability(target, move: Move) -> void:
	match move.action:
		Move.Action.ATTACK: send_attack(target, move)
		Move.Action.BUFF: send_buff(target, move)
		Move.Action.BUFF: send_debuff(target, move)
	ability_used.emit(move)
	
func send_attack(target: HealthComponent, move: Move) -> void:
	var damage = move.raw_power + get_stats()["attack"] * move.multiplier
	target.decrease_health(damage, move.type)

func send_buff(target: StatsComponent, move: Move) -> void:
	pass
	
func send_debuff(target: StatsComponent, move: Move) -> void:
	pass

# Handles recieving damage

class_name HealthComponent
extends Node

@export var low_health_treshhold: float = 0.30 ## Threshhold that determines if the health amount is considered low.

var health: float = 0.0
var was_low_health: bool = false ## Whether health was low before damaged.

# Stat constants for modifiers
const DEFENSE_CONSTANT = 0.3 ## Constant for defense modifier
const IMMUNITY_CONSTANT = 0.3 ## Constant for resistance modifier

# Signals
signal died
signal just_reached_below_low_health
signal just_restored_above_low_health
signal damaged
signal healed
signal health_changed(old_value: float, new_value: float)

func _ready() -> void:
	# Checks if stats are valid.
	if  not get_stats():
		push_error("Stats invalid!\n At: %s" % [self.get_path()])
		queue_free()
		return
	
	print(get_stats())
	
	set_health(get_stats().max_health)

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass

## Returns stats resource from StatsComponent
func get_stats() -> Dictionary:
	if get_parent().has_node("StatsComponent"):
		return get_parent().get_node("StatsComponent").final_stats
	else:
		return {}

## Sets health into x amount.
func set_health(amount: float) -> void:
	_update_health(amount)
	
## Resets health to max health
func reset_health() -> void:
	_update_health(get_stats()["max_health"])

## Returns the health from 0.0 - 1.0
func get_health_percent() -> float:
	return health / get_stats()["max_health"]

## Increase health by x amount.
func increase_health(amount: float) -> void:
	if is_full(): 
		print("%s's health is full! Cannot increase health further." % [get_parent().name])
		return
	
	if is_dead():
		print("%s is dead! Cannot increase health." % [get_parent().name])
		return
	
	_update_health(health + amount)
	healed.emit()
	print("%s healed %d HP" % [get_parent().name, int(amount)])

## Decrease health by x amount.
func decrease_health(damage: float, type: Stats.Type) -> void:
	if is_dead(): # Don't decrease health if already dead
		print("%s is dead! Unable to decrease health further." % [get_parent().name])
		return
	
	var modifier: float = DEFENSE_CONSTANT * get_stats()["defense"]
	
	if is_resistant_to(type):
		modifier += IMMUNITY_CONSTANT * get_stats()["immunity"]
		print("%s is resistant to %s!" % [get_parent().name, str(Stats.Type.find_key(type))])
	if is_weak_to(type):
		modifier = -(0.5 * damage)
		print("%s is weak to %s!" % [get_parent().name, str(Stats.Type.find_key(type))])
	#var modifier = DEFENSE_CONSTANT * stats.defense
	#defense_penetration = clampf(defense_penetration, 0.0, 1.0)
	damage = max(damage - modifier, 0.0) # Apply damage reduction by defense
	
	# Lowers health by damage, doesn't go below 0
	_update_health(health - damage)
	damaged.emit()
	print("%s lost %d HP" % [get_parent().name, int(damage)])

func _update_health(new_value: float) -> void:
	var prev_health = health
	
	# Changes health within limit (0 - max health).
	health = clampf(new_value, 0.0, get_stats()["max_health"])
	
	if health != prev_health: # Emit signal only if health changes
		health_changed.emit(prev_health, health)
	
	if is_dead(): # Announce death
		died.emit()
		return
		
	var now_low_health = is_low()
	if now_low_health and not was_low_health:
		just_reached_below_low_health.emit()
	elif not now_low_health and was_low_health:
		just_restored_above_low_health.emit()
	was_low_health = now_low_health

## Checks if the entity holding this HealthComponent is weak to the specified type.
func is_weak_to(type: Stats.Type) -> bool:
	match get_stats()["type"]:
		Stats.Type.IGNIS:
			return type == Stats.Type.AQUA
		Stats.Type.AQUA:
			return type == Stats.Type.ELECTRUM or Stats.Type.FOLIUM
		Stats.Type.FOLIUM:
			return type == Stats.Type.IGNIS
		Stats.Type.ELECTRUM:
			return type == Stats.Type.TERRA
		Stats.Type.TERRA:
			return type == Stats.Type.AQUA or Stats.Type.FOLIUM
	return false

## Checks if the entity holding this HealthComponent is resistant to the specified type.
func is_resistant_to(type: Stats.Type) -> bool:
	match get_stats()["type"]:
		Stats.Type.IGNIS:
			return type == Stats.Type.FOLIUM
		Stats.Type.AQUA:
			return type == Stats.Type.IGNIS or Stats.Type.TERRA
		Stats.Type.FOLIUM:
			return type == Stats.Type.TERRA or Stats.Type.AQUA
		Stats.Type.ELECTRUM:
			return type == Stats.Type.AQUA
		Stats.Type.TERRA:
			return type == Stats.Type.ELECTRUM
	return false

## Checks if health is considered low.
func is_low() -> bool:
	return health <= low_health_treshhold * get_stats()["max_health"]

## Checks if health is full.
func is_full() -> bool:
	return health >= get_stats()["max_health"]

## Checks if node is dead. 
func is_dead() -> bool:
	return health <= 0.0

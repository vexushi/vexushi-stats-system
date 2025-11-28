class_name HealthComponent
extends Node

@export var stats:Stats = null
@export var low_health_treshhold: float = 0.25 ## Threshhold that determines if the health amount is considered low.

var health: float = 0.0
var was_low_health: bool = false ## Whether health was low before damaged.

# Stat constants for modifiers
const DEFENSE_CONSTANT = 0.3 ## Constant for defense modifier

# Signals
signal died
signal just_reached_low_health
signal damaged
signal healed
signal health_changed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Checks if stats are valid.
	if  not stats:
		push_error("Stats invalid!\n At: %s" % [self.get_path()])
		queue_free()
		return
		
	set_health(stats.max_health)

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass

## Sets health into x amount.
func set_health(amount: float) -> void:
	health = amount
	health_changed.emit()
	
## Resets health to max health
func reset_health() -> void:
	health = stats.max_health
	health_changed.emit()

## Returns the health percentage
func get_health_percent() -> float:
	return health / stats.max_health

## Increase health by x amount.
func increase_health(amount: float) -> void:
	if is_full(): 
		print("%s's health is full! Cannot increase health further." % [get_parent().name])
		return
	
	if is_dead():
		print("%s is dead! Cannot increase health." % [get_parent().name])
		return
		
	var prev_health = health
	
	# Increases health by amount, doesn't go above max health
	health = min(health + amount, stats.max_health)
	
	# Makes sure to only emit signal if health was not at max before increasing.
	if health > prev_health:
		healed.emit()
		health_changed.emit()
	
	was_low_health = is_low() # Resets state after heal for signal in decrease_health()

## Decrease health by x amount.
func decrease_health(damage: float, defense_penetration: float = 0.0) -> void:
	if is_dead(): # Don't decrease health if already dead
		print("%s is dead! Unable to decrease health further." % [get_parent().name])
		return
	
	var modifier = DEFENSE_CONSTANT * stats.defense
	defense_penetration = clampf(defense_penetration, 0.0, 1.0)
	damage = damage - modifier + (modifier * defense_penetration) # Apply damage reduction by defense
	
	# Lowers health by damage, doesn't go below 0
	health = max(health - damage, 0.0)
	damaged.emit()
	print("%s lost %d HP" % [get_parent().name, int(damage)])
	
	health_changed.emit()
	
	if is_dead(): # Checks if died after applied damage
		died.emit()
		return
	
	var now_low_health = is_low()
	if now_low_health and not was_low_health:
		just_reached_low_health.emit()
	was_low_health = now_low_health

## Checks if health is considered low.
func is_low() -> bool:
	return health/stats.max_health <= low_health_treshhold

## Checks if health is full.
func is_full() -> bool:
	return health == stats.max_health

## Checks if node is dead. 
func is_dead() -> bool:
	return health == 0.0

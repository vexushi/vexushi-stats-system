class_name HealthComponent
extends Node

@onready var health: float = 0.0

@export var max_health: float = 20.0 ## Sets max health
@export var low_health_treshhold: float = 0.25 ## Threshhold that determines if the health amount is considered low.

signal died
signal just_reached_low_health
signal damaged
signal healed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !is_assigned(): # Checks if health component is assigned to a node
		print_debug("ERROR: Health component is not assigned to a node!")
		
		queue_free()
	set_health(max_health)

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass

## Sets health into x amount.
func set_health(amount: float) -> void:
	health = amount

## Increase health by x amount.
func increase_health(amount: float) -> void:
	if is_full(): 
		print("%s's health is full! Cannot increase health further." % [get_parent().name])
		return
	
	health += amount # Increases health by amount
	healed.emit()
	
	if health >= max_health: # Makes sure it doesn't increase over the maximum value
		health = max_health

## Decrease health by x amount.
func decrease_health(damage: float) -> void:
	@warning_ignore("unused_variable")
	var triggered_low_health_signal: bool
	
	if is_dead(): # Don't decrease health if already dead
		print("%s is dead! Unable to decrease health further." % [get_parent().name])
		return
	
	health -= damage # Lowers health by damage
	damaged.emit()
	
	if health <= 0.0: # Sets minimum health value to 0.0
		health = 0.0
		died.emit()
		return
	
	if triggered_low_health_signal: return # Don't send low health signal more that once
	if is_low():
		just_reached_low_health.emit()
		triggered_low_health_signal = true
	else:
		triggered_low_health_signal = false

## Checks if health is considered low.
func is_low() -> bool:
	if health/max_health <= low_health_treshhold:
		return true
	else: 
		return false

## Checks if health is full.
func is_full() -> bool:
	if health == max_health:
		return true
	else:
		return false

## Checks if node is dead. 
func is_dead() -> bool:
	if health == 0.0:
		return true
	else: 
		return false

## Checks if component is assigned to a node.
func is_assigned() -> bool:
	if self.get_parent() is not Window:
		return true
	else:
		return false

extends Node2D

@onready var nametag: Label = $Nametag
@onready var sprite: Sprite2D = $Sprite
@export var move_1: Button

@onready var health_label: Label = $Stats/VBoxContainer/Health
@onready var health_percentage_label: Label = $Stats/VBoxContainer/HealthPercentage
@onready var low_health_label: Label = $Stats/VBoxContainer/LowHealth

@export var health_bar: ProgressBar
@export var health_component: HealthComponent = null
@export var ability_component: AbilityComponent = null

@export var ability_target: HealthComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	nametag.text = self.name
	
	if !health_component:
		print("Health component not found!\n At %s" % [self.get_path()])

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	set_stats()
	pass
	
## Sets stats values for debug
func set_stats() -> void:
	if health_component:
		health_label.text = "Health: " + str(health_component.health)
		health_percentage_label.text = "HP%: " + str(ceil(health_component.get_health_percent() * 100))
		low_health_label.text = "Low HP: " + str(health_component.is_low())
	else: return


func _on_damage_button_up() -> void:
	if health_component:
		health_component.decrease_health(30, Stats.Type.NEUTER)
	pass # Replace with function body.


func _on_heal_button_up() -> void:
	if health_component:
		health_component.increase_health(20)
	pass # Replace with function body.

func _on_kill_button_up() -> void:
	if health_component:
		health_component.set_health(0.0)
	pass # Replace with function body.

func _on_health_component_just_reached_below_low_health() -> void:
	health_bar.fill_color_to_low()
	print("Health is now low!")
	pass # Replace with function body.

@warning_ignore("unused_parameter")
func _on_health_component_health_changed(old_value: float, new_value: float) -> void:
	health_bar.value = ceil(new_value)
	pass # Replace with function body.

func _on_health_component_just_restored_above_low_health() -> void:
	if health_bar:
		health_bar.fill_color_to_normal()
	pass # Replace with function body.

func _on_ability_component_ability_used(move: Move) -> void:
	print("%s used %s!" % [self.name, move.name])
	pass # Replace with function body.

func _on_move_1_button_up() -> void:
	if ability_component:
		ability_component.use_ability(ability_target, ability_component.moveset[0])
	pass # Replace with function body.

func _on_move_2_button_up() -> void:
	if ability_component:
		ability_component.use_ability(ability_target, ability_component.moveset[1])
	pass # Replace with function body.

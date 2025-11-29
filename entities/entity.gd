extends Node2D

@onready var nametag: Label = $Nametag
@onready var sprite: Sprite2D = $Sprite

@onready var health_label: Label = $Stats/VBoxContainer/Health
@onready var health_percentage_label: Label = $Stats/VBoxContainer/HealthPercentage
@onready var low_health_label: Label = $Stats/VBoxContainer/LowHealth

@export var health_bar: ProgressBar
@export var health_component: HealthComponent = null
@export var attack_component: AttackComponent = null

@export var attack_target: HealthComponent

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
		health_component.decrease_health(30, Stats.Types.NORMAL)
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

func _on_attack_component_attacked(move: Moves) -> void:
	print("%s used %s!" % [self.name, move.name])
	pass # Replace with function body.

func _on_move_1_button_up() -> void:
	if attack_component:
		var i: int = 0
		var move_id: int
		for move in attack_component.moveset:
			if move.name == "Slash":
				move_id = i
			i += 1
		attack_component.send_attack(attack_target, attack_component.moveset[move_id])
	pass # Replace with function body.

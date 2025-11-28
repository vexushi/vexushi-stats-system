extends Node2D

@onready var nametag: Label = $Nametag
@onready var sprite: Sprite2D = $Sprite

@onready var health: Label = $Stats/VBoxContainer/Health
@onready var health_percentage: Label = $Stats/VBoxContainer/HealthPercentage
@onready var low_health: Label = $Stats/VBoxContainer/LowHealth


@export var texture: CompressedTexture2D = load("res://icon.svg")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	nametag.text = self.name
	sprite.texture = texture
	
	if !has_node("HealthComponent"):
		print("Health component not found!\n At %s" % [self.get_path()])

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	set_stats()
	pass
	
## Sets stats values for debug
func set_stats() -> void:
	if has_node("HealthComponent"):
		var health_component:HealthComponent = get_node("HealthComponent")
		health.text = "Health: " + str(health_component.health)
		health_percentage.text = "HP%: " + str(int(health_component.get_health_percent() * 100))
		low_health.text = "Low HP: " + str(health_component.is_low())
	else: return


func _on_damage_button_up() -> void:
	if has_node("HealthComponent"):
		var health_component:HealthComponent = get_node("HealthComponent")
		health_component.decrease_health(30, 0.25)
	pass # Replace with function body.


func _on_heal_button_up() -> void:
	if has_node("HealthComponent"):
		var health_component:HealthComponent = get_node("HealthComponent")
		health_component.increase_health(20)
	pass # Replace with function body.


func _on_kill_button_up() -> void:
	if has_node("HealthComponent"):
		var health_component:HealthComponent = get_node("HealthComponent")
		health_component.decrease_health(health_component.health)
	pass # Replace with function body.



func _on_health_component_just_reached_low_health() -> void:
	print("Health is now low!")
	pass # Replace with function body.

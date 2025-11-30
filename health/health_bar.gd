extends Control

@export var health_component: HealthComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.max_value = health_component.get_stats()["max_health"]

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass
	
func fill_color_to_low() -> void:
	#var previous_color = progress_bar.get_theme_stylebox("fill")
	var changed_color = StyleBoxFlat.new()
	changed_color.bg_color = Color(0.671, 0.137, 0.055)
	remove_theme_stylebox_override("fill")
	add_theme_stylebox_override("fill",changed_color)
	
func fill_color_to_normal() -> void:
	#var previous_color = progress_bar.get_theme_stylebox("fill")
	var changed_color = StyleBoxFlat.new()
	changed_color.bg_color = Color(0.455, 0.82, 0.231)
	remove_theme_stylebox_override("fill")
	add_theme_stylebox_override("fill",changed_color)
	

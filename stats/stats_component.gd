class_name StatsComponent
extends Node

@export var base_stats: Stats = null

# Modifier types
enum ModifierType {
	ADD,
	MULTIPLY
}

var final_stats: Dictionary ## Final output of stats

var active_modifiers: Array[Dictionary] = []

func _ready() -> void:
	if  not base_stats:
		push_error("Stats invalid!\n At: %s" % [self.get_path()])
		queue_free()
		return
	final_stats = load_stats_from_resource(base_stats)
	
## Returns dictionary containing each stats from resource
func load_stats_from_resource(res: Stats) -> Dictionary:
	var data := {}
	for p in res.get_property_list():
		 # Makes sure it only load exported variables and declared in script
		if (p.usage & PROPERTY_USAGE_SCRIPT_VARIABLE) \
		and (p.usage & PROPERTY_USAGE_STORAGE):
			data[p.name] = res.get(p.name)
	return data

func recalculate_stats(stat:String, type:ModifierType, value:float) -> void:
	if !base_stats: return # Makes sure base stats is valid
	
	if !final_stats.has(stat): return # Makes sure parameter is valid
	
	var modifier: Dictionary = {
		"stat" : stat,
		"type" : type,
		"value" : value
	}
	active_modifiers.append(modifier)
	
	match type:
		ModifierType.ADD:
			final_stats[stat] = max(final_stats[stat] + value, 0.0)
		ModifierType.MULTIPLY:
			final_stats[stat] = max(final_stats[stat] * value, 0.0)

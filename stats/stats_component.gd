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

func recalculate_stats() -> void:
	var stats = load_stats_from_resource(base_stats)
	for d in active_modifiers:
		var stat = d["stat"]
		var type = d["type"]
		var value = d["value"]
		match type:
			ModifierType.ADD:
				stats[stat] = max(stats[stat] + value, 0.0)
			ModifierType.MULTIPLY:
				stats[stat] = max(stats[stat] * value, 0.0)
	final_stats = stats

func add_modifier(stat:String, type:ModifierType, value:float) -> void:
	if !final_stats.has(stat): # Makes sure parameter is valid
		print("Invalid stat entry: ", stat)
		return 
	var modifier: Dictionary = {
		"stat" : stat,
		"type" : type,
		"value" : value
	}
	active_modifiers.append(modifier)
	recalculate_stats()
	
func remove_modifier(stat:String) -> void:
	if !final_stats.has(stat): # Makes sure parameter is valid
		print("Invalid stat entry: ", stat)
		return 
	
	for d in active_modifiers:
		if d["stat"] == stat:
			active_modifiers.erase(d)
			break
			
	recalculate_stats()

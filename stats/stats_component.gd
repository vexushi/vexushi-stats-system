class_name StatsComponent
extends Node

@export var base_stats: Stats = null

## Modifier types
enum ModifierType {
	ADD,
	MULTIPLY
}

## Modifier sources
enum ModifierSource {
	EQUIPMENT,
	BUFF,
	DEBUFF,
	SKILL
}

var final_stats: Dictionary ## Final output of stats

var active_modifiers: Array[Dictionary] = []

func _ready() -> void:
	if  not base_stats:
		push_error("Stats invalid!\n At: %s" % [self.get_path()])
		queue_free()
		return
	final_stats = load_stats_from_resource(base_stats)
	
## Returns dictionary containing each stats from resource.
func load_stats_from_resource(res: Stats) -> Dictionary:
	var data := {}
	for p in res.get_property_list():
		 # Makes sure it only load exported variables and declared in script
		if (p.usage & PROPERTY_USAGE_SCRIPT_VARIABLE) \
		and (p.usage & PROPERTY_USAGE_STORAGE):
			data[p.name] = res.get(p.name)
	return data

## Recalculates stats after modifiers.
func recalculate_stats() -> void:
	var stats = load_stats_from_resource(base_stats)
	for d in active_modifiers:
		var stat = d["stat"]
		var type = d["type"]
		var value = d["value"]
		match type:
			ModifierType.ADD:
				stats[stat] = stats[stat] + value
			ModifierType.MULTIPLY:
				stats[stat] = stats[stat] * value
	final_stats = stats

## Apply modifier to stats.
func add_modifier(id:StringName, stat:String, type:ModifierType, value:float, source:ModifierSource) -> void:
	if !final_stats.has(stat): # Makes sure parameter is valid
		print("Invalid stat entry: ", stat)
		return 
	var modifier: Dictionary = {
		"id": id,
		"stat" : stat,
		"type" : type,
		"value" : value,
		"source": source
	}
	active_modifiers.append(modifier)
	recalculate_stats()
	
## Remove all modifiers from stats by ID.
func remove_modifiers_by_id(id:StringName) -> void:
	for i in range(active_modifiers.size() - 1, -1, -1):
		if active_modifiers[i]["id"] == id:
			active_modifiers.remove_at(i)
	recalculate_stats()
	
## Remove one modifier from stats.
func remove_modifier(id:StringName, stat:String) -> void:
	for i in range(active_modifiers.size() - 1, -1, -1):
		if active_modifiers[i]["id"] == id and active_modifiers[i]["stat"] == stat:
			active_modifiers.remove_at(i)
	recalculate_stats()
	
## Remove all modifiers from stats by source of modifiers.
func remove_modifiers_by_source(source:ModifierSource) -> void:
	for i in range(active_modifiers.size() - 1, -1, -1):
		if active_modifiers[i]["source"] == source:
			active_modifiers.remove_at(i)
	recalculate_stats()

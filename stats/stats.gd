class_name Stats
extends Resource

enum Type {
	NEUTER,
	IGNIS,
	AQUA,
	FOLIUM,
	ELECTRUM,
	TERRA
}

@export var max_health: float = 200.0
@export var defense: float = 1.0
@export var resistance: float = 1.0
@export var attack: float = 1.0
@export var agility: float = 1.0
@export var type: Type = Type.NEUTER
# Add more stats here if needed

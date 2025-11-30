class_name Moves
extends Resource

enum Types {
	NORMAL,
	FIRE,
	POISON,
}

@export var name: String
@export var type: Types ## Attack type
@export var raw_damage: float = 0.0
@export var multiplier: float = 0.0 ## Multiplier for Attack stats with value from 0.0 - 1.0

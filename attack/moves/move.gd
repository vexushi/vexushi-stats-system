class_name Move
extends Resource

enum Action {
	ATTACK,
	BUFF,
	DEBUFF
}

@export var name: String
@export var action: Action = Action.ATTACK ## If true, the move is an attacking move.
@export var type: Stats.Type ## Attack type
@export var raw_power: float = 0.0 ## Effectiveness of the move
@export var multiplier: float = 0.0 ## Multiplier for Attack stats with value from 0.0 - 1.0

extends Node2D
class_name BattleSlot

var team: String = "player"
var frontLine: bool = false
var unit: BattleUnit = null

func _ready():
	z_index = 10

func isEmpty() -> bool:
	return unit == null

func placeUnit(newUnit: BattleUnit):
	unit = newUnit
	add_child(newUnit)
	newUnit.global_position = global_position
	newUnit.slot = self

func removeUnit():
	if unit:
		unit.queue_free()
	unit = null

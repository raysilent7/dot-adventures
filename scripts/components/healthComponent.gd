class_name HealthComponent extends Node

@export var maxHp: int = 100
var hp: int

signal healthChanged
signal died

func _ready() -> void:
	hp = maxHp

func healHp(amount: int) -> void:
	hp = clamp(hp + amount, 0, maxHp)
	healthChanged.emit(hp, maxHp)

func takeDamage(amount: int) -> void:
	hp = clamp(hp - amount, 0, maxHp)
	healthChanged.emit(hp, maxHp)
	if hp == 0:
		died.emit()

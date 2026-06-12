class_name HealthComponent extends Node

@export var maxHp: int
@export var maxMp: int

var hp: int
var mp: int

func _ready() -> void:
	hp = maxHp
	mp = maxMp

func healHp(amount: int) -> void:
	var newHp = hp + amount
	if newHp > maxHp:
		hp = maxHp
	else:
		hp = newHp

func takeDamage(amount: int) -> void:
	var newHp = hp - amount
	if newHp <= 0:
		killUnit()
	else:
		hp = newHp

func killUnit() -> void:
	call_deferred("queue_free")

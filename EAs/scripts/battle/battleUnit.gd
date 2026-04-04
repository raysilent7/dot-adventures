extends Node2D
class_name BattleUnit

@onready var sprite = $unitTexture
@onready var healthBar = $healthBar
@onready var speedBar = $speedBar

var maxHp: int = 100
var power: int = 10
var defense: int = 5
var speed: int = 10
var currentHp: int
var speedMeter: float = 0.0
var team: String = "player"
var row: String = "front"
var slotPosition: int = 1
var slot = null

func _ready():
	z_index = 20
	currentHp = maxHp
	updateHealthBar()
	updateSpeedBar()

func fillSpeed():
	speedMeter += speed

	if speedMeter >= 100:
		speedMeter = 100
		return true

	updateSpeedBar()
	return false

func resetSpeed():
	speedMeter = 0
	updateSpeedBar()

func takeDamage(amount: int):
	var dmg = max((amount - defense), 1)
	currentHp -= dmg

	if currentHp <= 0:
		currentHp = 0
		die()

	updateHealthBar()

func die():
	visible = false
	if slot:
		slot.unit = null

func isAlive() -> bool:
	return currentHp > 0

func updateHealthBar():
	healthBar.max_value = maxHp
	healthBar.value = currentHp

func updateSpeedBar():
	speedBar.max_value = 100
	speedBar.value = speedMeter

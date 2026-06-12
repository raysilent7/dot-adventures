extends Node2D
class_name BattleUnit

@onready var sprite = $unitTexture
@onready var healthBar = $healthBar
@onready var speedBar = $speedBar

enum Behavior {
	LINE_BREAKER,   #prioriza alvos da frontline
	LINE_PIERCER,   #prioriza alvos da backline
	RANDOM,         #ataca qualquer alvo valido
	SUPPORT         #prioriza proteger/tankar/buffar
}

var behavior = Behavior.LINE_BREAKER
var unitName: String
var maxHp: int = 100
var power: int = 10
var defense: int = 5
var speed: int = 10
var currentHp: int
var speedMeter: float = 0.0
var team: String = "player"
var row: String = "front"
var slotPosition: int = 1
var canAttackBackLine: bool = false
var slot = null

func _ready():
	z_index = 20
	healthBar.z_index = 30
	speedBar.z_index = 30
	currentHp = maxHp
	updateHealthBar()
	updateSpeedBar()

func fillSpeed():
	speedMeter += getTotalSpeed()
	updateSpeedBar()
	if speedMeter >= 100:
		return true
	return false

func resetSpeed():
	speedMeter = 0
	updateSpeedBar()

func takeDamage(amount: int):
	currentHp -= amount

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

func getTotalSpeed() -> int:
	return speed + 0 #aqui vai entrar bonusSpeed no futuro quando tivermos um sistema de atributos mais detalhado

func highlightOn():
	sprite.modulate = Color(0.0, 1.4, 0.4, 1.0)

func highlightOff():
	sprite.modulate = Color(1, 1, 1)

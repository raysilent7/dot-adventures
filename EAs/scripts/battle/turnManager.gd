extends Node
class_name TurnManager

var battleManager: BattleManager
var allUnits: Array = []
var turnQueue: Array = []
var tickInterval: float = 0.5
var tickTimer: float = 0.0
var isProcessingTurn: bool = false

func _ready():
	battleManager = get_parent().get_node("battleManager")
	allUnits = battleManager.getAllUnits()

func _process(delta):
	if isProcessingTurn or not GameState.isInBattle:
		return

	tickTimer += delta
	if tickTimer >= tickInterval:
		tickTimer = 0
		processSpeedTick()

func processSpeedTick():
	for unit in allUnits:
		if unit.isAlive():
			var reached = unit.fillSpeed()
			if reached:
				addToTurnQueue(unit)

	if turnQueue.size() > 0:
		startNextTurn()

func addToTurnQueue(unit):
	if turnQueue.has(unit):
		return

	turnQueue.append(unit)
	turnQueue.sort_custom(sortBySpeedMeter)

func sortBySpeedMeter(a, b):
	return a.speedMeter > b.speedMeter

func startNextTurn():
	if turnQueue.size() == 0:
		return

	isProcessingTurn = true
	var unit = turnQueue.pop_front()

	if not unit.isAlive():
		isProcessingTurn = false
		return

	unit.resetSpeed()

	if unit.team == "player":
		battleManager.showPlayerActionUI(unit, self)
	else:
		battleManager.executeEnemyAI(unit, self)

func onUnitTurnFinished(unit):
	isProcessingTurn = false

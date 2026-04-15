extends Node2D
class_name BattleManager

@export var tileTexture: Texture2D
@onready var battleUI = $"../battleUI"
@onready var battle = $".."
var BattleUnitScene: PackedScene = preload("res://EAs/objects/battleUnit.tscn")
var BattleSlotScene: PackedScene = preload("res://EAs/objects/battleSlot.tscn")

const TILE_SIZE = 32
const GRID_COLS = 2
const GRID_ROWS = 2
const SIDE_SPACING = 64
const PLAYER_TEAM = "player"

var playerSlots: Array[BattleSlot]
var enemySlots: Array[BattleSlot]
var playerTiles = {}
var enemyTiles = {}
var currentUnit

func _ready():
	randomize()
	generateTiles()
	generateSlots()
	spawnTestUnits()

func getValidTargets(attackerTeam: String) -> Array:
	var slots = enemySlots if attackerTeam == "player" else playerSlots
	var targets = []

	for slot in slots:
		if slot.unit and slot.unit.isAlive():
			targets.append(slot.unit)

	return targets

func generateTiles():
	var center = get_viewport_rect().size / 2
	var playerOrigin = center + Vector2(-TILE_SIZE * 3, -TILE_SIZE)
	var enemyOrigin  = center + Vector2(TILE_SIZE * 1, -TILE_SIZE)
	var idx = 1

	for row in range(GRID_ROWS):
		for col in range(GRID_COLS):
			var tile = Sprite2D.new()
			tile.name = str(row) + "," + str(col)
			tile.texture = tileTexture
			tile.position = enemyOrigin + Vector2(row * TILE_SIZE, col * TILE_SIZE)
			$"../tileContainer".add_child(tile)
			enemyTiles[idx] = tile
			idx += 1

	idx = 1
	for row in range(GRID_ROWS):
		for col in range(GRID_COLS):
			var tile = Sprite2D.new()
			tile.name = str(row) + "," + str(col)
			tile.texture = tileTexture
			tile.position = playerOrigin + Vector2(row * TILE_SIZE, col * TILE_SIZE)
			$"../tileContainer".add_child(tile)
			playerTiles[idx] = tile
			idx += 1

func generateSlots():
	var order = [1,2,3,4]

	for i in order:
		var slot: BattleSlot = BattleSlotScene.instantiate()
		slot.team = "enemy"
		slot.frontLine = i < 3
		slot.position = enemyTiles[i].position
		add_child(slot)
		enemySlots.append(slot)

	for i in order:
		var slot: BattleSlot = BattleSlotScene.instantiate()
		slot.team = "player"
		slot.frontLine = i > 2
		slot.position = playerTiles[i].position
		add_child(slot)
		playerSlots.append(slot)

func spawnTestUnits():
	for i in range(playerSlots.size()):
		var unit = BattleUnitScene.instantiate()
		unit.unitName = "player" + str(i)
		unit.team = "player"
		unit.maxHp = 100
		unit.power = randi_range(30, 50)
		unit.defense = 10
		unit.speed = randi_range(20, 30)
		unit.row = "front" if i <= 1 else "back"
		unit.behavior = BattleUnit.Behavior.LINE_BREAKER if i <= 1 else BattleUnit.Behavior.LINE_PIERCER
		unit.canAttackBackLine = unit.behavior == BattleUnit.Behavior.LINE_PIERCER
		playerSlots[i].placeUnit(unit)

	for i in range(enemySlots.size()):
		var unit = BattleUnitScene.instantiate()
		unit.unitName = "enemy" + str(i)
		unit.team = "enemy"
		unit.maxHp = 50
		unit.power = randi_range(20, 45)
		unit.defense = 10
		unit.speed = randi_range(15, 25)
		unit.row = "front" if i <= 1 else "back"
		unit.behavior = BattleUnit.Behavior.LINE_BREAKER if i <= 1 else BattleUnit.Behavior.LINE_PIERCER
		unit.canAttackBackLine = unit.behavior == BattleUnit.Behavior.LINE_PIERCER
		enemySlots[i].placeUnit(unit)

func getAllUnits() -> Array:
	var list = []
	for slot in playerSlots:
		if slot.unit:
			list.append(slot.unit)
	for slot in enemySlots:
		if slot.unit:
			list.append(slot.unit)
	return list

func showPlayerActionUI(unit: BattleUnit, turnManager: TurnManager):
	print("Player turn: " + unit.unitName + " ataca backline: " + str(unit.canAttackBackLine))
	currentUnit = unit
	battleUI.showCommandPanel(unit, turnManager)

func executeEnemyAI(unit: BattleUnit, turnManager: TurnManager):
	var allies = getValidTargets(PLAYER_TEAM)
	var targets = getValidTargets(unit.team)
	var chosenTarget = null

	match unit.behavior:
		BattleUnit.Behavior.LINE_BREAKER:
			chosenTarget = chooseLineBreakerTarget(targets)
			print("alvo escolhido: " + chosenTarget.name)
		BattleUnit.Behavior.LINE_PIERCER:
			chosenTarget = chooseLinePiercerTarget(targets)
			print("alvo escolhido: " + chosenTarget.name)
		BattleUnit.Behavior.RANDOM:
			chosenTarget = chooseRandomTarget(unit, targets)
			print("alvo escolhido: " + chosenTarget.name)
		BattleUnit.Behavior.SUPPORT:
			chosenTarget = chooseSupportAction(unit, allies, targets)
			print("alvo escolhido: " + chosenTarget.name)
	
	if chosenTarget.team != PLAYER_TEAM:
		pass #implementar logica de buff/cura quando houver um sistema de habilidades
	else:
		executeAttack(unit, chosenTarget, turnManager)

func onAttackButtonPressed() -> void:
	var targets = getValidTargets(currentUnit.team)
	var front = getFrontlineTargets(targets)
	if currentUnit.canAttackBackLine or front.size() == 0:
		battleUI.showTargetSelection(targets)
	else:
		battleUI.showTargetSelection(front)

func executeAttack(attacker: BattleUnit, target: BattleUnit, turnManager: TurnManager):
	var damage = max(attacker.power - target.defense, 1)
	target.takeDamage(damage)

	if not target.isAlive():
		print(target.unitName + " morreu")

	if checkBattleEnd():
		get_tree().current_scene.player.get_node("playerCamera").enabled = true
		battle.queue_free()

	turnManager.onUnitTurnFinished(attacker)

func checkBattleEnd() -> bool:
	var anyPlayerAlive = false
	var anyEnemyAlive = false

	for slot in playerSlots:
		if slot.unit and slot.unit.isAlive():
			anyPlayerAlive = true

	for slot in enemySlots:
		if slot.unit and slot.unit.isAlive():
			anyEnemyAlive = true

	if not anyPlayerAlive:
		if MissionManager.fromMission:
			MissionManager.abandonMainMission()
		GameState.isInBattle = false
		return true

	if not anyEnemyAlive:
		if MissionManager.fromMission:
			MissionManager.completeMission(MissionManager.mainMission)
		GameState.isInBattle = false
		return true

	return false

func chooseLineBreakerTarget(targets):
	var front = getFrontlineTargets(targets)
	if front.size() > 0:
		print("ataquei frontline")
		return getRandomTarget(false, front)
	print("ataquei qualquer um")
	return getRandomTarget(false, targets)

func chooseLinePiercerTarget(targets):
	var back = getBacklineTargets(targets)
	if back.size() > 0:
		print("ataquei backline")
		return getRandomTarget(true, back)
	print("ataquei qualquer um")
	return getRandomTarget(true, targets)

func chooseRandomTarget(unit, targets):
	return getRandomTarget(unit.canAttackBackLine, targets)

func chooseSupportAction(unit, allies, targets):
	var injured = allies.filter(func(a): return a.hp < a.max_hp)
	if injured.size() > 0 and unit.canCastHeal():
		pass #implementar logica de buff/cura quando houver um sistema de habilidades

	var unbuffed = allies.filter(func(a): return not a.hasBuff())
	if unbuffed.size() > 0 and unit.canCastBuff():
		pass #implementar logica de buff/cura quando houver um sistema de habilidades

	return getRandomTarget(unit.canAttackBackLine, targets)

func getFrontlineTargets(targets):
	return targets.filter(func(t): return t.row == "front")

func getBacklineTargets(targets):
	return targets.filter(func(t): return t.row == "back")

func getRandomTarget(canAttackBackLine, targets):
	var front = getFrontlineTargets(targets)
	if canAttackBackLine or front.size() == 0:
		return targets[randi() % targets.size()]
	else:
		return front[randi() % front.size()]

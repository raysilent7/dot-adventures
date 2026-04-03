extends Node2D

@export var tileTexture: Texture2D

const TILE_SIZE = 32
const GRID_COLS = 2
const GRID_ROWS = 2
const SIDE_SPACING = 64

var playerSlots: Array[Node2D]
var enemySlots: Array[Node2D]
var playerTiles = {}
var enemyTiles = {}

func _ready():
	generateTiles()
	generateSlots()

func getValidTargets(attackerTeam: String) -> Array:
	var slots = playerSlots if attackerTeam == "player" else enemySlots
	var frontline = []
	var backline = []

	for slot in slots:
		if slot.unit and slot.unit.isAlive():
			if slot.isFrontline():
				frontline.append(slot.unit)
			else:
				backline.append(slot.unit)

	return frontline if frontline.size() > 0 else backline

func generateTiles():
	var center = get_viewport_rect().size / 2
	var playerOrigin = center + Vector2(-TILE_SIZE * 3, -TILE_SIZE)
	var enemyOrigin  = center + Vector2(TILE_SIZE * 1, -TILE_SIZE)
	var idx = 1
	
	for row in range(GRID_ROWS):
		for col in range(GRID_COLS):
			var tile = Sprite2D.new()
			tile.texture = tileTexture
			tile.position = playerOrigin + Vector2(col * TILE_SIZE, row * TILE_SIZE)
			$"../tileContainer".add_child(tile)
			playerTiles[idx] = tile
			idx += 1

	idx = 1
	for row in range(GRID_ROWS):
		for col in range(GRID_COLS):
			var tile = Sprite2D.new()
			tile.texture = tileTexture
			tile.position = enemyOrigin + Vector2(col * TILE_SIZE, row * TILE_SIZE)
			$"../tileContainer".add_child(tile)
			enemyTiles[idx] = tile
			idx += 1

func generateSlots():
	for i in playerTiles.keys():
		var slot = BattleSlot.new()
		slot.team = "player"
		slot.index = i
		slot.position = playerTiles[i].position
		add_child(slot)
		playerSlots.append(slot)

	for i in enemyTiles.keys():
		var slot = BattleSlot.new()
		slot.team = "enemy"
		slot.index = i
		slot.position = enemyTiles[i].position
		add_child(slot)
		enemySlots.append(slot)

func place_player_units(units):
	for i in range(units.size()):
		var slot = playerSlots[i]
		slot.placeUnit(units[i])

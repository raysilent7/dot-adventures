extends Node2D

@export var tileTexture: Texture2D
@export var decorTexture: Texture2D
@onready var player: Node2D = $player
@onready var tiles: Node2D = $tiles

var visionRadius: int = 2
var tileSize: int = 32
var numTiles: int = 200
var map = {}
var tileSprites = {}
var boundary = []
var directions = [Vector2(1,0), Vector2(-1,0), Vector2(0,1), Vector2(0,-1)]
var drawnTiles = []

func _ready():
	generateMap()
	drawMap()
	fillEmptySpaces()
	spawnPlayer()

func generateMap():
	var start = Vector2(0,0)
	map[start] = true
	boundary.append(start)

	while map.size() < numTiles and boundary.size() > 0:
		var tileBase = boundary[randi() % boundary.size()]
		var dir = directions[randi() % directions.size()]
		var newTile = tileBase + dir

		if not map.has(newTile):
			map[newTile] = true
			boundary.append(newTile)

		if countNeighbors(tileBase) > 2:
			boundary.erase(tileBase)

func countNeighbors(pos: Vector2) -> int:
	var count = 0
	for dir in directions:
		if map.has(pos + dir):
			count += 1
	return count

func drawMap():
	for pos in map.keys():
		var tile = Sprite2D.new()
		tile.texture = tileTexture
		tile.position = pos * tileSize + GameState.offset + GameState.diff
		tiles.add_child(tile)
		drawnTiles.append(pos)
		tileSprites[pos] = tile

func spawnPlayer():
	var randomPos = drawnTiles[randi() % drawnTiles.size()]
	player.position = randomPos * tileSize + GameState.offset + GameState.diff
	player.setCurrentTile(randomPos)
	updateVisibility(randomPos)

func updateVisibility(playerTile: Vector2):
	for pos in tileSprites:
		var dist = pos.distance_to(playerTile)
		var sprite = tileSprites[pos]

		sprite.visible = dist <= visionRadius

func fillEmptySpaces():
	var min_x = 99999
	var max_x = -99999
	var min_y = 99999
	var max_y = -99999

	for pos in map.keys():
		min_x = min(min_x, pos.x)
		max_x = max(max_x, pos.x)
		min_y = min(min_y, pos.y)
		max_y = max(max_y, pos.y)

	min_x -= 4
	max_x += 4
	min_y -= 4
	max_y += 4

	for x in range(min_x, max_x + 4):
		for y in range(min_y, max_y + 4):
			var pos = Vector2(x, y)

			if not map.has(pos):
				var tile = Sprite2D.new()
				tile.texture = decorTexture
				tile.position = pos * tileSize + GameState.offset + GameState.diff
				tiles.add_child(tile)
				tileSprites[pos] = tile

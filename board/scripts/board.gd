extends Node2D

@export var tileTexture: Texture2D
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
	for pos in drawnTiles:
		var dist = pos.distance_to(playerTile)
		var sprite = tileSprites[pos]

		if dist <= visionRadius:
			sprite.visible = true
		else:
			sprite.visible = false

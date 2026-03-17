extends Node2D

@export var tileSize: int = 32
@export var numTiles: int = 200
@export var tileTexture: Texture2D

var map = {}
var boundary = []
var directions = [Vector2(1,0), Vector2(-1,0), Vector2(0,1), Vector2(0,-1)]

func _ready():
	generateMap()
	drawMap()

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
	var minX = 999999
	var maxX = -999999
	var minY = 999999
	var maxY = -999999

	for pos in map.keys():
		minX = min(minX, pos.x)
		maxX = max(maxX, pos.x)
		minY = min(minY, pos.y)
		maxY = max(maxY, pos.y)

	var totalWidth = (maxX - minX + 1) * tileSize
	var totalHeight = (maxY - minY + 1) * tileSize

	var offset = Vector2(-minX * tileSize, -minY * tileSize)
	var screenCenter = get_viewport_rect().size / 2
	var mapCenter = Vector2(totalWidth, totalHeight) / 2
	var diff = screenCenter - mapCenter

	for pos in map.keys():
		var tile = Sprite2D.new()
		tile.texture = tileTexture
		tile.position = pos * tileSize + offset + diff
		add_child(tile)

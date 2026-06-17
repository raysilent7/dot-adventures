class_name MapComponent extends Node

const DIRECTIONS: Array = [Vector2.UP, Vector2.DOWN, Vector2.RIGHT, Vector2.LEFT]

var map: Dictionary = {}
var tileSprites: Dictionary = {}
var seenTiles: Dictionary = {}
var boundary: Array = []
var drawnTiles: Array = []
var tileTextures: Array = [
	preload("res://assets/images/square1.png"),
	preload("res://assets/images/square2.png")
]

func generateMap(numTiles: int) -> Dictionary:
	var start = Vector2(0,0)
	map[start] = true
	boundary.append(start)

	while map.size() < numTiles and boundary.size() > 0:
		var tileBase = boundary[randi() % boundary.size()]
		var expanded = false

		for i in range(4):
			var dir = DIRECTIONS[randi() % DIRECTIONS.size()]
			var newTile = tileBase + dir
			
			if map.has(newTile) or not isValidTile(newTile):
				continue
				
			map[newTile] = true
			
			if countNeighbors(newTile) > 3:
				map.erase(newTile)
				continue

			boundary.append(newTile)
			expanded = true
			break

		if not expanded:
			boundary.erase(tileBase)
	
	return map

func isValidTile(pos: Vector2) -> bool:
	var orthogonalNeighbors = 0
	for dir in DIRECTIONS:
		if map.has(pos + dir):
			orthogonalNeighbors += 1

	return orthogonalNeighbors > 0

func countNeighbors(pos: Vector2) -> int:
	var count = 0
	for dir in DIRECTIONS:
		if map.has(pos + dir):
			count += 1
	return count

func drawMap(tiles: Node2D) -> void:
	for pos in map.keys():
		var tile = Sprite2D.new()
		tile.texture = tileTextures.pick_random()
		tile.position = pos * GameState.tileSize
		tiles.add_child(tile)
		drawnTiles.append(pos)
		tileSprites[pos] = tile

extends Node2D

@export var tileTexture: Texture2D
@export var decorTexture: Texture2D
@export var missionTexture: Texture2D
@export var cityTexture: Texture2D
@onready var player: Node2D = $world/player/playerBody
@onready var tiles: Node2D = $world/tiles

var visionRadius: int = 2
var tileSize: int = 32
var numTiles: int = 200
var obj
var objectiveTiles = {}
var map = {}
var tileSprites = {}
var seenTiles = {}
var boundary = []
var directions = [Vector2(1,0), Vector2(-1,0), Vector2(0,1), Vector2(0,-1)]
var drawnTiles = []
var visitedTiles = []

func _ready():
	generateMap()
	print("board | map size: " + str(map.size()))
	drawMap()
	fillEmptySpaces()
	spawnPlayer()
	placeMissionObjectiveOnMap()
	placeMainCityOnMap()
	player.get_node("playerCamera").position_smoothing_enabled = false
	await get_tree().process_frame
	player.get_node("playerCamera").position_smoothing_enabled = true

func _process(_delta: float) -> void:
	if visitedTiles.size() > 0:
		GameState.firstVisit = false

	for tileName in objectiveTiles:
		if player.getCurrentTile() == objectiveTiles.get(tileName) and not visitedTiles.has(player.getCurrentTile()):
			print("board | process | entrei no tileNameValidator: " + str(player.getCurrentTile() == objectiveTiles.get(tileName) and not visitedTiles.has(player.getCurrentTile())) + "tileName: " + tileName)
			get_tree().current_scene.get_node("mapUI/popupPanel").showObjectivePopup(obj, player.getCurrentTile(), tileName)

func generateMap():
	var start = Vector2(0,0)
	map[start] = true
	boundary.append(start)

	while map.size() < numTiles and boundary.size() > 0:
		var tileBase = boundary[randi() % boundary.size()]
		var expanded = false

		for i in range(4):
			var dir = directions[randi() % directions.size()]
			var newTile = tileBase + dir
			
			if map.has(newTile) or not isValidTile(newTile):
				continue
				
			map[newTile] = true
			
			if countNeighbors(newTile) > 1:
				map.erase(newTile)
				continue

			boundary.append(newTile)
			expanded = true
			break

		if not expanded:
			boundary.erase(tileBase)

func countNeighbors(pos: Vector2) -> int:
	var count = 0
	for dir in directions:
		if map.has(pos + dir):
			count += 1
	return count

func isValidTile(pos: Vector2) -> bool:
	var orthogonalNeighbors = 0
	for dir in [Vector2(1,0), Vector2(-1,0), Vector2(0,1), Vector2(0,-1)]:
		if map.has(pos + dir):
			orthogonalNeighbors += 1

	return orthogonalNeighbors > 0

func getValidBoundaryTile():
	for tile in boundary:
		for dir in directions:
			if not map.has(tile + dir):
				return tile
	return null

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
	GameState.isInCity = false

func updateVisibility(playerTile: Vector2):
	for pos in tileSprites.keys():
		var dist = pos.distance_to(playerTile)
		var sprite = tileSprites[pos]
		sprite.visible = dist <= visionRadius

		if dist <= visionRadius:
			seenTiles[pos] = true

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

func placeMissionObjectiveOnMap():
	var mission = MissionManager.mainMission
	print("board | missao atual: " + MissionManager.mainMission.title)
	var pos = map.keys().get(randi() % map.keys().size())
	var tile = tileSprites.get(pos)
	
	obj = mission.data
	print("board | markOnMap: " + str(obj.markOnMap))
	objectiveTiles.set("MAIN_MISSION", pos)
	
	if obj.markOnMap:
		print("board | marquei a missao no mapa")
		tile.texture = missionTexture
		seenTiles[pos] = true

func placeMainCityOnMap():
	print("board | cidade posicionada ")
	var pos = player.getCurrentTile()
	var tile = tileSprites.get(pos)
	objectiveTiles.set("CITY", pos)
	tile.texture = cityTexture

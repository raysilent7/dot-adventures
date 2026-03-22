extends Node2D

@export var tileTexture: Texture2D
@export var decorTexture: Texture2D
@onready var tiles = $world/tiles

var tileSize = 32
var map = {}
var missions = [
	"Explorar a floresta ao norte",
	"Investigar ruínas antigas",
	"Escoltar um mercador",
	"Caçar criaturas próximas"
]

func _ready():
	$world/missionBoard.position = Vector2(0, 0) * tileSize + GameState.offset + GameState.diff
	$world/missionBoard.connect("boardInteracted", Callable(self, "openMissionBoard"))
	generateCity()
	positionPlayer()

func generateCity():
	print("Offset: " + str(GameState.offset))
	print("Diff: " + str(GameState.diff))
	for x in range(5):
		for y in range(5):
			var tile = Sprite2D.new()
			tile.texture = tileTexture
			tile.position = Vector2(x, y) * tileSize + GameState.offset + GameState.diff
			
			map[Vector2(x, y)] = true
			
			tiles.add_child(tile)

func positionPlayer():
	var startTile = Vector2(2, 2)
	$world/player/playerBody.position = startTile * tileSize + GameState.offset + GameState.diff
	$world/player/playerBody.currentTile = startTile
	GameState.isInCity = true

func openMissionBoard():
	$boardUI/missionBoardUI.open(missions)
	get_tree().paused = true

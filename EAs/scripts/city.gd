extends Node2D

@export var tileTexture: Texture2D
@export var decorTexture: Texture2D
@onready var tiles = $world/tiles
@onready var missionBoard = $world/missionBoard
@onready var boardUI = $boardUI/missionBoardUI
@onready var player = $world/player/playerBody

var tileSize = 32
var map = {}

func _ready():
	missionBoard.position = Vector2(0, 0) * tileSize + GameState.offset + GameState.diff
	missionBoard.connect("boardInteracted", Callable(self, "openMissionBoard"))
	generateCity()
	positionPlayer()
	if MissionManager.mainMission != null:
		if MissionManager.mainMission.isCompleted:
			giveRewards()
		else:
			print("city | missao falhou")
	MissionManager.abandonMainMission()
	MissionManager.abandonAllSideMissions()

func generateCity():
	for x in range(5):
		for y in range(5):
			var tile = Sprite2D.new()
			tile.texture = tileTexture
			tile.position = Vector2(x, y) * tileSize + GameState.offset + GameState.diff
			
			map[Vector2(x, y)] = true
			
			tiles.add_child(tile)

func positionPlayer():
	var startTile = Vector2(2, 2)
	player.position = startTile * tileSize + GameState.offset + GameState.diff
	player.currentTile = startTile
	GameState.isInCity = true

func openMissionBoard():
	boardUI.open()
	get_tree().paused = true

func onReturnToCity():
	if MissionManager.mainMission != null and not MissionManager.mainMission.isCompleted:
		print("city | missao principal falhou")
		MissionManager.abandonMainMission()

	if MissionManager.sideMissions.size() > 0:
		for m in MissionManager.sideMissions:
			if not m.isCompleted:
				print("city | missao secundaria falhou:", m.title)
		MissionManager.abandonAllSideMissions()

func giveRewards():
	#completar depois quando tiver sistema de itens, dinheiro e inventario
	pass

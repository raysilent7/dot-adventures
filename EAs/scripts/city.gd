extends Node2D

@export var tileTexture: Texture2D
@export var decorTexture: Texture2D
@onready var tiles: Node2D = $tiles
@onready var missionBoard: Area2D = $tiles/missionBoard
@onready var boardUI = $boardUI/missionBoardUI
@onready var player: CharacterBody2D = $Player
@onready var mapComponent: MapComponent = $MapComponent

var map: Dictionary = {}

func _ready() -> void:
	missionBoard.position = Vector2(0, 0) * GameState.tileSize
	missionBoard.connect("boardInteracted", Callable(self, "openMissionBoard"))
	map = mapComponent.generateMap(40)
	mapComponent.drawMap(tiles)
	spawnPlayer()
	if MissionManager.mainMission != null:
		if MissionManager.mainMission.isCompleted:
			giveRewards()
		else:
			print("city | missao falhou")
	MissionManager.abandonMainMission()
	MissionManager.abandonAllSideMissions()

func spawnPlayer():
	var randomPos = mapComponent.drawnTiles[randi() % mapComponent.drawnTiles.size()]
	player.setCurrentTile(randomPos)
	player.setMap(map)
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

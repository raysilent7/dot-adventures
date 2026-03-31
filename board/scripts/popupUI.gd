extends Control

@onready var popup = $missionPopup
@onready var popup2 = $cityPopup
@onready var mapUI = $".."
@onready var board = $"../.."

var currentTile

func showObjectivePopup(obj, playerTile, tileName):
	print("show popup: " + str(tileName == "CITY" and not GameState.firstVisit))
	print(GameState.firstVisit)
	if tileName == "MAIN_MISSION":
		print("mapUI | showObjectivePopup | missionPopup")
		if obj.hasEnemies:
			fillMissionPopupInfo(obj, "Lutar", "Fugir", playerTile)
		else:
			fillMissionPopupInfo(obj, "Aceitar", "Abandonar", playerTile)
	elif tileName == "CITY" and not GameState.firstVisit:
		print("mapUI | showObjectivePopup | cityPopup")
		fillCityPopupInfo("Sair do mapa", "Voltar", playerTile)

func fillMissionPopupInfo(obj, button1Text, button2Text, playerTile):
	var label = popup.get_node("dialogText")
	var button1 = popup.get_node("button1")
	var button2 = popup.get_node("button2")
	label.text = obj.dialogText
	showPopup(button1, button2, button1Text, button2Text, playerTile)

func fillCityPopupInfo(button1Text, button2Text, playerTile):
	var label = popup2.get_node("dialogText")
	var button1 = popup2.get_node("button3")
	var button2 = popup2.get_node("button4")
	label.text = "Deseja retornar para a cidade agora? Atenção! Retornar à cidade sem completar a missão do quadro fará com que sua missão falhe instantaneamente."
	showPopup(button1, button2, button1Text, button2Text, playerTile)

func showPopup(button1, button2, button1Text, button2Text, playerTile):
	mapUI.visible = true
	button1.text = button1Text
	button2.text = button2Text
	popup2.popup_centered()
	get_tree().paused = true
	currentTile = playerTile

func visitTileAndHidePopup():
	board.visitedTiles.append(currentTile)
	hidePopup()

func hidePopup():
	get_tree().paused = false
	popup.hide()
	popup2.hide()
	mapUI.visible = false

func onButton1Pressed() -> void:
	print("missionPopup | botao 1 apertado")
	MissionManager.completeMission(MissionManager.mainMission)
	visitTileAndHidePopup()

func onButton2Pressed() -> void:
	print("missionPopup | botao 2 apertado")
	MissionManager.abandonMainMission()
	visitTileAndHidePopup()

func onButton3Pressed() -> void:
	print("cityPopup | botao 1 apertado")
	hidePopup()
	get_tree().change_scene_to_file("res://EAs/objects/city.tscn")

func onButton4Pressed() -> void:
	print("cityPopup | botao 2 apertado")
	hidePopup()

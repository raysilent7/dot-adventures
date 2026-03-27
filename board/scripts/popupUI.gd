extends Control

@onready var popup = $missionPopup
@onready var mapUI = $".."
@onready var board = $"../.."

var currentTile

func showObjectivePopup(obj, playerTile):
	mapUI.visible = true
	var label = popup.get_node("dialogText")
	var button1 = popup.get_node("button1")
	var button2 = popup.get_node("button2")
	label.text = obj.dialogText
	button1.text = "Lutar"
	button2.text = "Fugir"
	popup.popup_centered()
	get_tree().paused = true
	currentTile = playerTile

func onButton1Pressed() -> void:
	print("missionPopup | botao 1 apertado")
	board.visitedTiles.append(currentTile)
	get_tree().paused = false
	MissionManager.completeMission(MissionManager.mainMission)
	popup.hide()
	mapUI.visible = false

func onButton2Pressed() -> void:
	print("missionPopup | botao 2 apertado")
	board.visitedTiles.append(currentTile)
	get_tree().paused = false
	MissionManager.abandonMainMission()
	popup.hide()
	mapUI.visible = false

extends Control

var dailyMissions: Array[Mission] = []
var selectedMission: Mission = null

func _ready():
	var now = Time.get_unix_time_from_system()
	if now - GameState.lastRefreshTimestamp >= 86400:
		generateDailyMissions()
		GameState.cachedMissions = dailyMissions
		GameState.lastRefreshTimestamp = now
	else:
		dailyMissions = GameState.cachedMissions
	populateList()

func open():
	$"..".visible = true

func close():
	visible = false

func onClosePressed() -> void:
	get_tree().paused = false
	$"..".visible = false
	$"../boardBG".visible = false

func generateDailyMissions():
	var factory = MissionFactory.new()
	dailyMissions.clear()
	dailyMissions = factory.getDailyBoardMissions()

func populateList():
	var list = $panel/missionList
	for child in list.get_children():
		child.queue_free()

	for todayMission in dailyMissions:
		var btn = Button.new()
		btn.text = todayMission.title
		btn.pressed.connect(func(): onMissionSelected(todayMission))
		list.add_child(btn)

func onMissionSelected(todayMission: Mission):
	selectedMission = todayMission
	$confirmPopup/missionText.text = "Aceitar missão:\n" + todayMission.title + "?"
	$confirmPopup.popup_centered()

func onYesPressed() -> void:
	if MissionManager.acceptMainMission(selectedMission):
		print("mission board UI | missao atual: " + MissionManager.mainMission.title)
		get_tree().paused = false
		get_tree().change_scene_to_file("res://board/objects/board.tscn")
	else:
		print("mission board UI | ja existe uma missao ativa")

func onNoPressed() -> void:
	$confirmPopup.hide()

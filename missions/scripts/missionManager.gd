extends Node

var mainMission: Mission = null
var sideMissions: Array[Mission] = []
var currentBattleMission: Mission
var fromMission: bool

func acceptMainMission(acceptedMission: Mission):
	if mainMission != null:
		print("mission manager | ja existe uma missao principal ativa")
		return false

	mainMission = acceptedMission
	return true

func addSideMission(sideMission: Mission):
	sideMissions.append(sideMission)

func completeMission(completedMisssion: Mission):
	completedMisssion.isCompleted = true

func abandonAllSideMissions():
	sideMissions.clear()

func abandonMainMission():
	mainMission = null

func getAllActiveMissions():
	var list = []
	if mainMission != null:
		list.append(mainMission)
	list.append_array(sideMissions)
	return list

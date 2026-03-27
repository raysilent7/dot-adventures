extends Node

var mainMission: Mission = null
var sideMissions: Array[Mission] = []

func acceptMainMission(acceptedMission: Mission):
	if mainMission != null:
		print("Já existe uma missão principal ativa")
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

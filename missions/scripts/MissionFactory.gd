extends Node
class_name MissionFactory

var types = ["kill", "rescue", "visit"]

func createMission(obj: Dictionary) -> Mission:
	var mission = Mission.new()
	
	mission.title = obj.title
	mission.description = obj.description
	mission.rewardExp = obj.rewardExp
	mission.rewardItem = obj.rewardItem
	mission.rewardItemQty = obj.rewardItemQty
	mission.type = obj.type
	mission.data = obj

	return mission

func getDailyBoardMissions() -> Array[Mission]:
	var missionList: Array[Mission] = []
	var ObjDB = ObjectiveDatabase.new()
	
	for x in range(5):
		var type = types[randi_range(0, 2)]
		if type == "kill":
			var mission = createMission(ObjDB.getRandomKillObjective())
			mission.isMain = true
			missionList.append(mission)
		if type == "rescue":
			var mission = createMission(ObjDB.getRandomRescueObjective())
			mission.isMain = true
			missionList.append(mission)
		if type == "visit":
			var mission = createMission(ObjDB.getRandomVisitObjective())
			mission.isMain = true
			missionList.append(mission)
	
	return missionList

func getRandomMission() -> Mission:
	var ObjDB = ObjectiveDatabase.new()
	var type = types[randi_range(0, 2)]
	if type == "kill":
		return createMission(ObjDB.getRandomKillObjective())
	elif type == "rescue":
		return createMission(ObjDB.getRandomRescueObjective())
	else:
		return createMission(ObjDB.getRandomVisitObjective())

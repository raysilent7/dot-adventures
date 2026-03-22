extends Control

func open(missions):
	$"..".visible = true
	$"../boardBG".visible = true
	
	for child in $panel/missionList.get_children():
		child.queue_free()

	for mission in missions:
		var label = Label.new()
		label.text = mission
		$panel/missionList.add_child(label)

func close():
	visible = false

func onClosePressed() -> void:
	get_tree().paused = false
	$"..".visible = false
	$"../boardBG".visible = false

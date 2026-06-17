extends Area2D

var playerInRange = false

func _ready():
	body_entered.connect(onBodyEntered)
	body_exited.connect(onBodyExited)

func onBodyEntered(body) -> void:
	if body.is_in_group("player"):
		body.setPlayerOnBoard(true)
		print("mission board | player entrou no quadro")

func onBodyExited(body) -> void:
	if body.is_in_group("player"):
		body.setPlayerOnBoard(true)
		print("mission board | player saiu do quadro")

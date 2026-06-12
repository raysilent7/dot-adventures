extends Area2D

var playerInRange = false
signal cityInteracted

func _ready():
	connect("body_entered", Callable(self, "onBodyEntered"))
	connect("body_exited", Callable(self, "onBodyExited"))

func _process(_delta: float) -> void:
	if playerInRange and Input.is_action_just_pressed("interact"):
		print("board | player interagiu com a cidade")
		emit_signal("cityInteracted")

func onBodyEntered(body):
	if body.is_in_group("player"):
		playerInRange = true
		print("board | player entrou na cidade")

func onBodyExited(body):
	if body.is_in_group("player"):
		playerInRange = false
		print("board | player saiu da cidade")

extends Area2D

var playerInRange = false
signal boardInteracted

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _process(delta):
	if playerInRange and Input.is_action_just_pressed("interact"):
		print("Interagiu com o quadro")
		emit_signal("boardInteracted")

func _on_body_entered(body):
	if body.is_in_group("player"):
		playerInRange = true
		print("Player entrou no quadro")

func _on_body_exited(body):
	if body.is_in_group("player"):
		playerInRange = false
		print("Player saiu do quadro")

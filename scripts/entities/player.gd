extends Node2D

@onready var sprite = $playerSpr
@onready var inputComponent: InputComponent = $InputComponent
@onready var movementComponent: MovementComponent = $MovementComponent

var isMoving: bool = false

func _process(_delta: float) -> void:
	if not isMoving or not GameState.isInBattle:
		inputComponent.readInputs()
		movementComponent.move(inputComponent.dir)
		turnSprite(inputComponent.dir)

func turnSprite(dir: Vector2):
	if dir == Vector2(0, -1):
		sprite.rotation_degrees = -90
	elif dir == Vector2(0, 1):
		sprite.rotation_degrees = 90
	elif dir == Vector2(-1, 0):
		sprite.rotation_degrees = 180
	elif dir == Vector2(1, 0):
		sprite.rotation_degrees = 0

func setCurrentTile(tile: Vector2):
	movementComponent.currentTile = tile

func getCurrentTile() -> Vector2:
	return movementComponent.currentTile

extends Node2D

@onready var sprite = $playerSpr
@onready var inputComponent: InputComponent = $InputComponent
@onready var movementComponent: MovementComponent = $MovementComponent

var isMoving: bool = false

func _process(_delta: float) -> void:
	if isMoving or GameState.isInBattle:
		return

	inputComponent.readInputs()
	
	if inputComponent.dir != Vector2.ZERO:
		movementComponent.move(inputComponent.dir)
		turnSprite(inputComponent.dir)

func turnSprite(dir: Vector2) -> void:
	if dir == Vector2(0, -1):
		sprite.rotation_degrees = -90
	elif dir == Vector2(0, 1):
		sprite.rotation_degrees = 90
	elif dir == Vector2(-1, 0):
		sprite.rotation_degrees = 180
	elif dir == Vector2(1, 0):
		sprite.rotation_degrees = 0

func setCurrentTile(tile: Vector2) -> void:
	position = tile * GameState.tileSize
	movementComponent.currentTile = tile

func getCurrentTile() -> Vector2:
	return movementComponent.currentTile

func setMap(map: Dictionary) -> void:
	movementComponent.map = map

func setPlayerOnBoard(isOnBoard: bool) -> void:
	inputComponent.isOnBoard = isOnBoard

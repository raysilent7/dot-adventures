extends Node2D

@onready var sprite = $playerSpr

var tileSize: int = 32
var map = {}
var currentTile = Vector2.ZERO
var moveDuration: float = 0.4
var isMoving = false

func _ready():
	var scene = get_tree().current_scene
	map = scene.map

func _process(_delta):
	controlPlayerActions()

func controlPlayerActions():
	if isMoving or GameState.isInBattle:
		return

	var dir = Vector2.ZERO

	if Input.is_action_just_pressed("up"):
		dir = Vector2(0, -1)
	elif Input.is_action_just_pressed("down"):
		dir = Vector2(0, 1)
	elif Input.is_action_just_pressed("left"):
		dir = Vector2(-1, 0)
	elif Input.is_action_just_pressed("right"):
		dir = Vector2(1, 0)

	if dir != Vector2.ZERO:
		move(dir)

func move(dir: Vector2):
	var target = currentTile + dir
	var oldTile = currentTile
	if map.has(target):
		var board = get_tree().current_scene
		isMoving = true
		currentTile = target

		if not GameState.isInCity:
			board.updateVisibility(currentTile)
			if not board.visitedTiles.has(oldTile) and not board.objectiveTiles.get("CITY") == oldTile:
				board.visitedTiles.append(oldTile)

		turnSprite(dir)
		var targetCalc = currentTile * tileSize + GameState.offset + GameState.diff
		var tween = create_tween()
		tween.tween_property(self, "position", targetCalc, moveDuration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
		tween.finished.connect(func(): isMoving = false)

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
	currentTile = tile

func getCurrentTile() -> Vector2:
	return currentTile

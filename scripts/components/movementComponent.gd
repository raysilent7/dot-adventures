class_name MovementComponent extends Node

@export var inputComponent: InputComponent
@export var player: CharacterBody2D

var map: Dictionary
var moveDuration: float = 0.5
var currentTile: Vector2
var isMoving: bool = false

func _ready() -> void:
	var scene = get_tree().current_scene
	map = scene.map

func move(dir: Vector2):
	var target = currentTile + dir
	#var oldTile = currentTile
	print("aconteci")
	print(str(map.has(target)))
	print(map)
	if map.has(target) and not isMoving:
		print("aconteci2")
		player.isMoving = true
		#var board = get_tree().current_scene

		#if not GameState.isInCity:
			#board.updateVisibility(currentTile)
			#if not board.visitedTiles.has(oldTile) and not board.objectiveTiles.get("CITY") == oldTile:
				#board.visitedTiles.append(oldTile)

		var targetCalc = target * GameState.tileSize
		var tween = create_tween()
		tween.tween_property(player, "position", targetCalc, moveDuration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
		currentTile = target
		tween.finished.connect(func(): player.isMoving = false)

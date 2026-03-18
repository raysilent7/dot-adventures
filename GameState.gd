extends Node

func _ready() -> void:
	var board = get_tree().current_scene
	calcOffsetAndDiff(board.map)

#calculos de mapa
var tileSize: int = 32
var offset
var diff

func calcOffsetAndDiff(map):
	var minX = 999999
	var maxX = -999999
	var minY = 999999
	var maxY = -999999

	for pos in map.keys():
		minX = min(minX, pos.x)
		maxX = max(maxX, pos.x)
		minY = min(minY, pos.y)
		maxY = max(maxY, pos.y)

	var totalWidth = (maxX - minX + 1) * tileSize
	var totalHeight = (maxY - minY + 1) * tileSize

	var offsetCalc = Vector2(-minX * tileSize, -minY * tileSize)
	var screenCenter = get_tree().current_scene.get_viewport_rect().size / 2
	var mapCenter = Vector2(totalWidth, totalHeight) / 2
	var diffCalc = screenCenter - mapCenter
	offset = offsetCalc
	diff = diffCalc

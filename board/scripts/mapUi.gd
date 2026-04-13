extends Control

@onready var mapContainer = $mapContainer
@onready var mapUI = get_parent()

var tileSize = 16

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("map"):
		mapUI.visible = not mapUI.visible
		mapUI.get_node("subs").visible = not mapUI.get_node("subs").visible
		mapUI.get_node("mapPanel").visible = not mapUI.get_node("mapPanel").visible

		if mapUI.visible:
			get_tree().paused = true
			var board = get_tree().current_scene
			updateMap(board.seenTiles, board.tileSprites)
		else:
			get_tree().paused = false

func updateMap(seenTiles, tileSprites):
	for child in mapContainer.get_children():
		child.queue_free()

	if seenTiles.size() == 0:
		return

	var minX = 99999
	var maxX = -99999
	var minY = 99999
	var maxY = -99999

	for pos in seenTiles.keys():
		minX = min(minX, pos.x)
		maxX = max(maxX, pos.x)
		minY = min(minY, pos.y)
		maxY = max(maxY, pos.y)

	var width = (maxX - minX + 1) * tileSize
	var height = (maxY - minY + 1) * tileSize

	mapContainer.position = Vector2(
		(size.x - width) / 2,
		(size.y - height) / 2
	)

	for pos in seenTiles.keys():
		var isWalkable
		var isMissionTile
		var isCityTile
		var tile = ColorRect.new()
		var sprite = tileSprites[pos]
		
		if sprite is Sprite2D:
			isWalkable = sprite.texture == get_tree().current_scene.tileTexture
			isMissionTile = sprite.texture == get_tree().current_scene.missionTexture
		else:
			isCityTile = true

		if isWalkable:
			tile.color = Color.WHITE
		elif isMissionTile:
			tile.color = Color.YELLOW
		elif isCityTile:
			tile.color = Color.BROWN
		else:
			tile.color = Color.DARK_BLUE

		tile.size = Vector2(tileSize, tileSize)

		var normalized = Vector2(
			pos.x - minX,
			pos.y - minY
		)
		tile.position = normalized * tileSize
		
		var board = get_tree().current_scene
		var playerTile = board.player.currentTile
		var normalizedPlayer = Vector2(
			playerTile.x - minX,
			playerTile.y - minY
		)
		var playerIcon = ColorRect.new()
		playerIcon.color = Color.GREEN
		playerIcon.size = Vector2(tileSize, tileSize)
		playerIcon.position = normalizedPlayer * tileSize

		mapContainer.add_child(playerIcon)
		mapContainer.add_child(tile)

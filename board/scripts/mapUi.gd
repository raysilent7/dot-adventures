extends Control

@export var decorTexture: Texture2D
@onready var mapContainer = $mapContainer
@onready var mapUI = get_parent()

var min_x = 99999
var min_y = 99999
var tileSize = 16

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("map"):
		mapUI.visible = not mapUI.visible

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

	var min_x = 99999
	var max_x = -99999
	var min_y = 99999
	var max_y = -99999

	for pos in seenTiles.keys():
		min_x = min(min_x, pos.x)
		max_x = max(max_x, pos.x)
		min_y = min(min_y, pos.y)
		max_y = max(max_y, pos.y)

	var width = (max_x - min_x + 1) * tileSize
	var height = (max_y - min_y + 1) * tileSize

	mapContainer.position = Vector2(
		(size.x - width) / 2,
		(size.y - height) / 2
	)

	for pos in seenTiles.keys():
		var tile = ColorRect.new()

		var sprite = tileSprites[pos]
		var is_walkable = sprite.texture == get_tree().current_scene.tileTexture

		if is_walkable:
			tile.color = Color.WHITE
		else:
			tile.color = Color.DARK_BLUE

		tile.size = Vector2(tileSize, tileSize)

		var normalized = Vector2(
			pos.x - min_x,
			pos.y - min_y
		)
		tile.position = normalized * tileSize
		
		var board = get_tree().current_scene
		var player_tile = board.player.currentTile
		var normalized_player = Vector2(
			player_tile.x - min_x,
			player_tile.y - min_y
		)
		var player_icon = ColorRect.new()
		player_icon.color = Color.GREEN
		player_icon.size = Vector2(tileSize, tileSize)
		player_icon.position = normalized_player * tileSize

		mapContainer.add_child(player_icon)
		mapContainer.add_child(tile)

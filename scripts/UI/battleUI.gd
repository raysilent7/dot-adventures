extends CanvasLayer
class_name BattleUI

@onready var commandPanel = $commandPanel
@onready var buttonsPanel = $"../buttons"
var textureBtn: Texture = preload("res://EAs/objects/battle button.png")
var textureBtnHover: Texture = preload("res://EAs/objects/battle button hover.png")

const TILE_SIZE = 32
const GRID_COLS = 2
const GRID_ROWS = 2

var currentUnit: BattleUnit
var turnManager: TurnManager
var battleManager: BattleManager
var currentTargets: Array = []

func showCommandPanel(unit: BattleUnit, tm: TurnManager):
	currentUnit = unit
	turnManager = tm
	battleManager = tm.battleManager
	commandPanel.visible = true
	buttonsPanel.visible = false

func hideAll():
	commandPanel.visible = false
	buttonsPanel.visible = false
	clearHighlights()

func clearHighlights():
	for t in currentTargets:
		t.highlightOff()

func showTargetSelection(targets: Array):
	currentTargets = targets
	buttonsPanel.visible = true
	
	for child in buttonsPanel.get_children():
		child.queue_free()

	for t in targets:
		var btn = TextureButton.new()
		var slot = battleManager.enemySlots[t.slotPosition]
		btn.texture_normal = textureBtn
		btn.texture_hover = textureBtnHover
		btn.global_position = slot.global_position + Vector2(-16, -16)
		btn.pressed.connect(func(): onTargetSelected(t))
		btn.mouse_entered.connect(func(): onHoverTarget(t))
		btn.mouse_exited.connect(func(): onHoverExit(t))
		buttonsPanel.add_child(btn)

func onHoverTarget(target):
	clearHighlights()
	target.highlightOn()

func onHoverExit(target):
	target.highlightOff()

func onTargetSelected(target):
	clearHighlights()
	hideAll()
	battleManager.executeAttack(currentUnit, target, turnManager)

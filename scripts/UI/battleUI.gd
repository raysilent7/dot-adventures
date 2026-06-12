extends CanvasLayer
class_name BattleUI

var currentUnit: BattleUnit
var turnManager: TurnManager
var battleManager: BattleManager
var currentTargets: Array = []

@onready var commandPanel = $commandPanel
@onready var targetPanel = $targetPanel
@onready var targetContainer = $targetPanel/targetContainer

func showCommandPanel(unit: BattleUnit, tm: TurnManager):
	currentUnit = unit
	turnManager = tm
	battleManager = tm.battleManager
	commandPanel.visible = true
	targetPanel.visible = false

func hideAll():
	commandPanel.visible = false
	targetPanel.visible = false
	clearHighlights()

func clearHighlights():
	for t in currentTargets:
		t.highlightOff()

func showTargetSelection(targets: Array):
	currentTargets = targets
	targetPanel.visible = true

	for child in targetContainer.get_children():
		child.queue_free()

	for t in targets:
		var btn = Button.new()
		btn.text = t.name
		btn.pressed.connect(func(): onTargetSelected(t))
		btn.mouse_entered.connect(func(): onHoverTarget(t))
		btn.mouse_exited.connect(func(): onHoverExit(t))
		targetContainer.add_child(btn)

func onHoverTarget(target):
	clearHighlights()
	target.highlightOn()

func onHoverExit(target):
	target.highlightOff()

func onTargetSelected(target):
	clearHighlights()
	hideAll()
	battleManager.executeAttack(currentUnit, target, turnManager)

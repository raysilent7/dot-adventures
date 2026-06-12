extends Resource
class_name Skill

@export var skillName: String
@export var classOwner: String
@export var type: String
@export var target: String
@export var qtyAttacks: int = 1
@export var element: String = ""
@export var buffApplied: String = ""
@export var debuffApplied: String = ""
@export var scaling: float = 1.0
@export var mana: int = 0
@export var cooldown: int = 0
@export var duration: int = 0
@export var description: String
@export var canTargetBackline: bool = false
@export var actualCD: int = 0

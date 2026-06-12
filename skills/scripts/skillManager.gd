extends Node
class_name SkillManager

func executeSkill(user, skill: Skill, targets: Array, battleManager):
	if user.mp < skill.mana or skill.actualCD > 0:
		print("Não da pra usar a skill agora!")
		return

	user.mp -= skill.mana
	user.startCooldown(skill)

	match skill.type:
		"attack":
			executeAttack(user, skill, targets)
		"heal":
			executeHeal(user, skill, targets)
		"buff":
			executeBuff(user, skill, targets)
		"debuff":
			executeDebuff(user, skill, targets)
		"shield":
			executeShield(user, skill, targets)
		"cleanse":
			executeCleanse(user, skill, targets)
		_:
			print("Tipo de habilidade não reconhecido: ", skill.type)

func executeAttack(user, skill, targets):
	for target in targets:
		for i in range(skill.qty_attacks):
			var damage = max((user.magicPower * skill.scaling) - target.magicResistance, 1)
			target.takeDamage(damage)

func executeHeal(user, skill, targets):
	for target in targets:
		var healAmount = target.maxHp * skill.scaling
		target.heal(healAmount)

func executeBuff(user, skill, targets):
	for target in targets:
		target.applyBuff(skill.buffApplied, skill.scaling, skill.duration)

func executeDebuff(user, skill, targets):
	for target in targets:
		target.applyDebuff(skill.debuffApplied, skill.scaling, skill.duration)

func executeShield(user, skill, targets):
	for target in targets:
		target.addShield(skill.scaling)

func executeCleanse(user, skill, targets):
	for target in targets:
		target.remove_all_debuffs()
		if skill.buffApplied != "":
			target.applyBuff(skill.buffApplied, 1, skill.duration)

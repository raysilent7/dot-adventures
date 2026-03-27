extends Node
class_name ObjectiveDatabase

var rescueObjectives: Array = [
	{
		"type": "rescue_npc",
		"title": "Resgatar Edgar Marcapasso",
		"description": "Edgar Marcapasso saiu para vender itens na feira e não retornou, e achamos que ele possa estar com problemas. 
		Uma testemunha disse ter visto ele saindo da cidade acompanhado de gente estranha, então ele os seguiu até um esconderijo no meio da floresta, 
		vá até lá e salve Edgar de um destino cruel.",
		"rewardExp": 100,
		"rewardItem": "gold",
		"rewardItemQty": 50,
		"itemRarity": "common",
		"hasEnemies": true,
		"enemyQty": 1,
		"enemyType": {
			"1": "bandit_assassin"
		},
		"hasSequency": false,
		"sequencyType": "",
		"tileType": "bandit_hideout",
		"tileQty": 1,
		"markOnMap": true,
		"dialogText": "Você encontrou o esconderijo dos bandidos no local exato onde a testemunha disse que estaria, e lá está Edgar Marcapasso, 
		numa jaula num canto do esconderijo enquanto os bandidos festejam por terem roubado toda sua mercadoria. Você irá enfrentá-los?"
	},
	{
		"type": "rescue_npc",
		"title": "Resgatar Alina Aguasclaras",
		"description": "Alina Aguasclaras é a filha do general da guarda da cidade e após um ataque a sua carruagem na estrada enquanto voltava de outra cidade, ela desapareceu. 
		As investigaçoes sugerem que ela foi levada por bandidos que desejam se vingar do general, corram para o esconderijo dos malfeitores e salvem-na antes que seja tarde.",
		"rewardExp": 200,
		"rewardItem": "gold",
		"rewardItemQty": 100,
		"itemRarity": "common",
		"hasEnemies": true,
		"enemyQty": 4,
		"enemyType": {
			"1": "bandit_assassin",
			"2": "bandit_warrior",
			"3": "bandit_archer",
			"4": "bandit_archer"
		},
		"hasSequency": false,
		"sequencyType": "",
		"tileType": "bandit_hideout",
		"tileQty": 1,
		"markOnMap": true,
		"dialogText": "Você encontrou o esconderijo dos bandidos, e lá está Alina Aguasclaras, 
		numa jaula num canto do esconderijo enquanto os bandidos planejam seu proximo movimento. Você irá enfrentá-los?"
	}
]
var killObjectives: Array = [
	{
		"type": "kill_mobs",
		"title": "Cace 1 javali",
		"description": "A familia de um caçador local está sem saber o que fazer agora que o caçador está doente, eles estão dispostos a pagar com o pouco que tem para
		não ficar sem comer, ajude-os caçando alguns javalis.",
		"rewardExp": 50,
		"rewardItem": "gold",
		"rewardItemQty": 30,
		"itemRarity": "common",
		"hasEnemies": true,
		"enemyQty": 1,
		"enemyType": {
			"1": "wild_boar"
		},
		"hasSequency": false,
		"sequencyType": "",
		"tileType": "forest",
		"tileQty": 1,
		"markOnMap": true,
		"dialogText": "Você encontrou um javali bebendo agua de uma nascente próxima, deseja ataca-lo?"
	},
	{
		"type": "kill_mobs",
		"title": "Cace o urso",
		"description": "Há um urso e seu filhote que estão atacando os animais de fazendas proximas da floresta, cace este urso antes que algo ainda pior aconteça.",
		"rewardExp": 100,
		"rewardItem": "gold",
		"rewardItemQty": 50,
		"itemRarity": "common",
		"hasEnemies": true,
		"enemyQty": 2,
		"enemyType": {
			"1": "mother_bear",
			"2": "baby_bear"
		},
		"hasSequency": false,
		"sequencyType": "",
		"tileType": "forest",
		"tileQty": 1,
		"markOnMap": true,
		"dialogText": "Você encontrou a mãe urso e seu filhote nas proximidades de uma fazenda ao lado de restos do que seria uma vaca. Você irá ataca-los?"
	}
]
var visitObjectives: Array = [
	{
		"type": "visit_tiles",
		"title": "Visite uma paisagem",
		"description": "Um oraculo disse que ao visitar uma paisagem estonteante proxima à cidade, uma verdade incontestavel seria revelada, e uma grande fortuna o aguardava.",
		"rewardExp": 50,
		"rewardItem": "sowrd",
		"rewardItemQty": 1,
		"itemRarity": "common",
		"hasEnemies": false,
		"enemyQty": 0,
		"enemyType": {},
		"hasSequency": false,
		"sequencyType": "",
		"tileType": "landscape_ea",
		"tileQty": 1,
		"markOnMap": true,
		"dialogText": "Você encontrou uma paisagem realmente estonteante, ao ponto de você se perder em seus proprios pensamentos por varios minutos.
		Ao despertar, voce encontra ao seu lado uma espada, que não estava ali antes. Você decide ficar com a espada."
	},
	{
		"type": "visit_tiles",
		"title": "Visite 30 quadrados",
		"description": "Voce estava conversando numa taverna sobre como tem sido dificil sua jornada como aventureiro 
		e um de seus colegas te indicou fazer uma caminhada pelos arredores para poder clarear um pouco as ideias.",
		"rewardExp": 50,
		"rewardItem": "gold",
		"itemRarity": "common",
		"rewardItemQty": 30,
		"hasEnemies": false,
		"enemyQty": 0,
		"enemyType": {},
		"hasSequency": false,
		"sequencyType": "",
		"tileType": "any",
		"tileQty": 30,
		"markOnMap": true,
		"dialogText": "Você encontrou a mãe urso e seu filhote nas proximidades de uma fazenda ao lado de restos do que seria uma vaca. Você irá ataca-los?"
	}
]

func getRandomRescueObjective() -> Dictionary:
	if rescueObjectives.is_empty():
		return getRandomKillObjective()

	var index = randi() % rescueObjectives.size()
	var objective = rescueObjectives.pop_at(index)
	return objective

func getRandomKillObjective() -> Dictionary:
	if killObjectives.is_empty():
		return getRandomVisitObjective()

	var index = randi() % killObjectives.size()
	var objective = killObjectives.pop_at(index)
	return objective

func getRandomVisitObjective() -> Dictionary:
	if visitObjectives.is_empty():
		return getRandomRescueObjective()

	var index = randi() % visitObjectives.size()
	var objective = visitObjectives.pop_at(index)
	return objective

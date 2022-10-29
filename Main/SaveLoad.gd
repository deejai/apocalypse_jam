extends Node

class_name SaveLoad

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

static func save_game(player):
	print("Saving game...")
	var floorSaveObj = {
		"level": player.floor.level,
		"start": 0,
		"current": -1,
		"end": -1,
		"nodes": []
	}

	var floorNodeArr = []
	
	var queue = [player.floor.start]
	
	while len(queue) > 0:
		var node = queue.pop_front()
		if node not in floorNodeArr:
			for next_node in node.next:
				queue.append(next_node)
				
			var index = len(floorNodeArr)
			floorNodeArr.append(node)
			
			if node == player.floor.current:
				floorSaveObj["current"] = index
				
			if node == player.floor.end:
				floorSaveObj["end"] = index
	
	for i in range(len(floorNodeArr)):
		var node = floorNodeArr[i]
		floorSaveObj["nodes"].append({
			"next": [],
			"prev": [],
			"battle_type": 0 if node.boss_node else node.battle.type,
			"reward_type": node.reward_type,
			"level": node.level,
			"completed": node.completed,
			"boss_node": node.boss_node,
		})

		for next_node in node.next:
			floorSaveObj["nodes"][i].next.append(floorNodeArr.find(next_node))

		for next_node in node.prev:
			floorSaveObj["nodes"][i].prev.append(floorNodeArr.find(next_node))

	var inventorySaveObj = {
		"AbilityUpgrades": [],
		"ActivatedAbilities": [],
		"PassiveAbilities": [],
		"UnitUpgrades": [],
	}
	
#	for i in range(len(player.inventory)):
#		var item = player.inventory[i]
#		if item is AbilityUpgrade:
#			inventorySaveObj["AbilityUpgrades"].append(
#				item.amount
#			)
#		elif item is ActivatedAbility:
#			inventorySaveObj["ActivatedAbilities"].append({
#				"key": item.key,
#				"level": item.level,
#			})
#		elif item is PassiveAbility:
#			inventorySaveObj["PassiveAbilities"].append({
#				"key": item.key,
#				"level": item.level,
#			})
#		elif item is UnitUpgrade:
#			inventorySaveObj["PassiveAbilities"].append({
#				"effect": item.effect,
#				"amount": item.amount,
#			})
#		else:
#			assert(false)

	var squadSaveObj = []

	for unit_data in player.squad:
		var activated_abilities = []
		var passive_abilities = []
		
		for ability in unit_data.unit.activated_abilities:
			activated_abilities.append({
				"key": ability.key,
				"level": ability.level,
			})
		
		for ability in unit_data.unit.passive_abilities:
			passive_abilities.append({
				"key": ability.key,
				"level": ability.level,
			})
		
		squadSaveObj.append({
			"unit": {
				"speed": unit_data.unit.speed,
				"hp": unit_data.unit.hp,
				"base": unit_data.unit.base,
				"range": unit_data.unit.range,
				"attack_damage": unit_data.unit.attack_damage,
				"attack_speed": unit_data.unit.attack_speed,

				"level": unit_data.unit.level,

				"activated_abilities": [],
				"passive_abilities": [],
			},
			"start_position": {
				"x": unit_data["start_position"].x,
				"y": unit_data["start_position"].y,
			},
		})
		
	var saveObj = {
		"floor": floorSaveObj,
		"inventory": inventorySaveObj,
		"squad": squadSaveObj
	}

	var file = FileAccess.open("user://slot1.save", FileAccess.WRITE)
	file.store_line(JSON.stringify(saveObj))

	print("Saved.")

static func load_game(player):
	print("Loading game...")
	var file = FileAccess.open("user://slot1.save", FileAccess.READ)
	if(file == null):
		return
	var save_data = JSON.parse_string(file.get_as_text())

	var floorData = save_data["floor"]
	var level = floorData["level"]

	var floorNodes = []

	for node_data in floorData["nodes"]:
		var new_node = FloorNode.new(level)
		new_node.reward_type = Shared.REWARD_TYPE.values()[node_data["reward_type"]]
		new_node.battle = Battle.new(level, Battle.TYPE.values()[node_data["battle_type"]])
		new_node.completed = node_data["completed"]
		new_node.boss_node = node_data["boss_node"]
		floorNodes.append(new_node)

	player.floor.start = floorNodes[0]

	for node_index in len(floorData["nodes"]):
		var node_data = floorData["nodes"][node_index]
		for next_index in node_data["next"]:
			FloorNode.link(floorNodes[node_index], floorNodes[next_index])
		for prev_index in node_data["prev"]:
			FloorNode.link(floorNodes[prev_index], floorNodes[node_index])

		if node_index == floorData["current"]:
			player.floor.current = floorNodes[node_index]

		if node_index == floorData["end"]:
			player.floor.end = floorNodes[node_index]

	player.squad = [{"unit": Unit.new(Shared.BASE.HEALER), "start_position": Vector2(400, 600)}]

	print("Loaded.")

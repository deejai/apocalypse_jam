extends Node

class_name Battle

var enemies: Array = []

enum TYPE { ZERG_RUSH, HEAL_ONE, SPAM_UNIT, BALANCED, RANGE_PLUS_TANKS }

func _init(level: int):
	var type = TYPE.values()[ randi() % len(TYPE) ]
	type = TYPE.HEAL_ONE
	match type:
		TYPE.ZERG_RUSH:
			for r in range(2):
				for c in range(5):
					var x_offset = 0 if r == 0 else 75
					var position = Vector2(x_offset + 300 + c*150, 50 + 25 * r)
					var unit = Unit.new(Unit.BASE.SOLDIER_SWORD)
					unit.hp *= .5
					unit.attack_damage *= 0.25
					unit.attack_speed *= 2
					unit.speed *= 2
					enemies.append({"unit": unit, "start_position": position})
		TYPE.HEAL_ONE:
			for r in range(1):
				for c in range(5):
					var x_offset = 0 if r == 0 else 75
					var position = Vector2(x_offset + 150 c*150, 50 + 25 * r)
					var unit = Unit.new(Unit.BASE.HEALER)
					unit.hp *= .5
					unit.attack_damage *= 0.25
					unit.attack_speed *= 2
					unit.speed *= 2
					enemies.append({"unit": unit, "start_position": position})
					
					var position2 = Vector2(x_offset + 150 c*150, 50 + 25 * r + r)
					var unit2 = Unit.new(Unit.BASE.SOLDIER_SPEAR)
					unit2.hp *= .5
					unit2.attack_damage *= 0.25
					unit2.attack_speed *= 2
					unit2.speed *= 2
					enemies.append({"unit": unit2, "start_position": position2})

		
#	for i in range(len(positions)):
#		enemies.append({"unit": Unit.new(Unit.BASE.SOLDIER_SWORD), "start_position": positions[i]})

extends Node

class_name Battle

var enemies: Array = []

enum TYPE { ZERG_RUSH, HEAL_ONE, SPAM_UNIT, BALANCED, RANGE_PLUS_TANKS }

func _init(level: int):
	var type = TYPE.values()[ randi() % len(TYPE) ]
	type = TYPE.ZERG_RUSH
	match type:
		TYPE.ZERG_RUSH:
			for r in range(2):
				for c in range(5):
					var x_offset = 0 if r == 0 else 75
					var position = Vector2(x_offset + 300 + c*150, 50 + 25 * r)
					var unit = Unit.new(Unit.BASE.HEALER)
					unit.hp *= .5
					unit.attack_damage *= 0.25
					unit.attack_speed *= 2
					unit.speed *= 2
					enemies.append({"unit": unit, "start_position": position})

		
#	for i in range(len(positions)):
#		enemies.append({"unit": Unit.new(Unit.BASE.SOLDIER_SWORD), "start_position": positions[i]})

extends Node

class_name Battle

var enemies: Array = []

enum TYPE { ZERG_RUSH, HEAL_ONE, SPAM_UNIT, BALANCED, RANGE_PLUS_TANKS }

func _init(level: int):
	var type = TYPE.values()[ randi() % len(TYPE) ]

	type %= 2 # increase as you add more unit configurations

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
			for c in range(5):
				var position = Vector2(150 + c*150, 50 + 25 + 70)
				var unit = Unit.new(Unit.BASE.HEALER)
				enemies.append({"unit": unit, "start_position": position})

			var beefy_soldier = Unit.new(Unit.BASE.SOLDIER_SPEAR)
			beefy_soldier.attack_damage *= 2
			beefy_soldier.hp *= 2
			enemies.append({"unit": beefy_soldier, "start_position": Vector2(450, 50 + 25 + 150)})
			print(enemies)

#	for i in range(len(positions)):
#		enemies.append({"unit": Unit.new(Unit.BASE.SOLDIER_SWORD), "start_position": positions[i]})

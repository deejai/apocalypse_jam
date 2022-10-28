extends Node

class_name Battle

var enemies: Array = []

enum TYPE { ZERG_RUSH, HEAL_ONE, SPAM_UNIT, BALANCED, RANGE_PLUS_TANKS }

func _init(level: int):
	var type = TYPE.values()[ randi() % len(TYPE) ]

	type %= 2 # increase as you add more unit configurations

	match type:
		TYPE.ZERG_RUSH:
			for r in range(randi_range(2,3)):
				for c in range(randi_range(3, 4)):
					var x_offset = 0 if r == 0 else 75
					var position = Vector2(x_offset + 300 + c*150, 50 + 25 * r)
					var unit = Unit.new(Unit.BASE.SOLDIER_SWORD, level)
					unit.hp *= .4
					unit.attack_damage *= 0.2
					unit.attack_speed *= 2.5
					unit.speed *= 2
					enemies.append({"unit": unit, "start_position": position})
		TYPE.HEAL_ONE:
			for c in range(randi_range(2,5)):
				var position = Vector2(150 + c*150, 100)
				var healer_unit = Unit.new(Unit.BASE.HEALER, level)
				enemies.append({"unit": healer_unit, "start_position": position})
			var strong_unit = Unit.new(Unit.BASE.SOLDIER_SPEAR, level)
			strong_unit.hp *= 2
			enemies.append({"unit": strong_unit, "start_position": Vector2(650, 200)})
		TYPE.BALANCED:
			for c in range(randi_range(3,6)):
				var position = Vector2(150 + c*150, 50 + 25 + 70)
				var heal_unit = Unit.new(Unit.BASE.HEALER, level)
				var ranged_unit = Unit.new(Unit.BASE.ARCHER, level)
				var strong_unit = Unit.new(Unit.BASE.SOLDIER_SPEAR, level)
				enemies.append({"unit": heal_unit, "start_position": position})
				enemies.append({"unit": ranged_unit, "start_position": Vector2(150 + c*150, 50 + 25 + 120)})
				enemies.append({"unit": strong_unit, "start_position": Vector2(150 + c*150, 50 + 25 + 180)})

extends Node

class_name Battle

enum TYPE { ZERG_RUSH, HEAL_ONE, SPAM_UNIT, BALANCED, RANGE_PLUS_TANKS, RAND }

var type: TYPE
var enemies: Array = []

func _init(level: int, p_type: TYPE = TYPE.RAND):
	var type
	
	if p_type == TYPE.RAND:
		type = TYPE.values()[ randi() % (len(TYPE)-1) ]

	else:
		type = p_type
	
	self.type = type

	match type:
		TYPE.ZERG_RUSH:
			for r in range(randi_range(2,3)):
				for c in range(randi_range(3, 4+level * (3-r))):
					var x_offset = 0 if r == 0 else 75
					var position = Vector2(x_offset + 300 + c*150, 50 + 25 * r)
					var unit = Unit.new(Shared.BASE.SOLDIER_SWORD, level)
					unit.hp *= .4
					unit.attack_damage *= 0.2
					unit.attack_speed *= 2.5
					unit.speed *= 2
					enemies.append({"unit": unit, "start_position": position})

		TYPE.HEAL_ONE:
			for c in range(randi_range(3,5+level)):
				var position = Vector2(150 + c*150, 100)
				var healer_unit = Unit.new(Shared.BASE.HEALER, level)
				enemies.append({"unit": healer_unit, "start_position": position})
			var strong_unit = Unit.new(Shared.BASE.SOLDIER_SPEAR, level)
			strong_unit.hp *= 2
			enemies.append({"unit": strong_unit, "start_position": Vector2(650, 200)})

		TYPE.BALANCED:
			for c in range(randi_range(2,3+level)):
				var position = Vector2(150 + c*150, 50 + 25 + 70)
				var heal_unit = Unit.new(Shared.BASE.HEALER, level)
				var ranged_unit = Unit.new(Shared.BASE.SOLDIER_ARCHER, level)
				var strong_unit = Unit.new(Shared.BASE.SOLDIER_SPEAR, level)
				enemies.append({"unit": heal_unit, "start_position": position})
				enemies.append({"unit": ranged_unit, "start_position": Vector2(150 + c*150, 50 + 25 + 120)})
				enemies.append({"unit": strong_unit, "start_position": Vector2(150 + c*150, 50 + 25 + 180)})

		TYPE.SPAM_UNIT:
			# roll to determine enemy type
			# spawn ~4-(6 + level) of them
			var base = [Shared.BASE.SOLDIER_SWORD, Shared.BASE.HEALER, Shared.BASE.SOLDIER_ARCHER, Shared.BASE.SOLDIER_SPEAR][randi() % 4]
			for r in range(2):
				for c in range(randi_range(3, 4+level * (3-r))):
					var x_offset = 0 if r == 0 else 75
					var position = Vector2(x_offset + 300 + c*150, 50 + 25 * r)
					enemies.append({"unit": Unit.new(base, level), "start_position": position})

		TYPE.RANGE_PLUS_TANKS:
			for c in range(randi_range(3,4+level)):
				var position = Vector2(150 + c*150, 100)
				var healer_unit = Unit.new(Shared.BASE.SOLDIER_ARCHER, level)
				enemies.append({"unit": healer_unit, "start_position": position})
			var strong_unit = Unit.new(Shared.BASE.SOLDIER_SPEAR, level)
			enemies.append({"unit": strong_unit, "start_position": Vector2(650, 200)})
			enemies.append({"unit": strong_unit, "start_position": Vector2(450, 200)})

		_:
			assert(false)

static func get_boss_fight(level: int, remaining_titans):
	var battle = Battle.new(level)
	var titan = remaining_titans.pop_at(randi() % len(remaining_titans))
	var enemies = []
	enemies.append({"unit": Unit.new(titan, level), "start_position": Vector2(450, 70)})
	var enemy_bases = [Shared.BASE.SOLDIER_SWORD_UNDEAD, Shared.BASE.SOLDIER_ARCHER_UNDEAD, Shared.BASE.SOLDIER_SPEAR_UNDEAD, Shared.BASE.HEALER_UNDEAD]
	var x_pos = 200
	for base in enemy_bases:
		enemies.append({"unit": Unit.new(base, level), "start_position": Vector2(x_pos, 140)})
		x_pos += 80

	battle.enemies = enemies

	return battle

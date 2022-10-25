extends Node

var proj_spear = load("res://Main/Views/ArenaView/Projectiles/Spear.tscn")

func mind_dart(instance: AbilityEffect, flag: AbilityEffect.FLAG):
	match flag:
		AbilityEffect.FLAG.START:
			instance.props["target_unit"].apply_damage(10 + instance.level * 5)

		AbilityEffect.FLAG.END:
			pass

		AbilityEffect.FLAG.TICK:
			pass

func soothing_vines(instance: AbilityEffect, flag: AbilityEffect.FLAG):
	match flag:
		AbilityEffect.FLAG.START:
			instance.duration = 3
			return

		AbilityEffect.FLAG.END:
			return

		AbilityEffect.FLAG.TICK:
			instance.props["target_unit"].apply_healing(5 + instance.level * 1)
			return

func poison_nova(instance: AbilityEffect, flag: AbilityEffect.FLAG):
	match flag:
		AbilityEffect.FLAG.START:
			instance.duration = 10

		AbilityEffect.FLAG.END:
			pass

		AbilityEffect.FLAG.TICK:
			instance.props["target_unit"].apply_damage(7 + instance.level * 3)

func summon_imp(instance: AbilityEffect, flag: AbilityEffect.FLAG):
	match flag:
		AbilityEffect.FLAG.START:
			print("Tried to summon imp, but failed")
			pass

		AbilityEffect.FLAG.END:
			pass

		AbilityEffect.FLAG.TICK:
			pass

func throw_spear(instance: AbilityEffect, flag: AbilityEffect.FLAG):
	match flag:
		AbilityEffect.FLAG.START:
			var direction = instance.props["source_unit"].direction_to(instance.props["target_unit"])
			var alliance = instance.props["source_unit"].alliance
			var spear = proj_spear.instantiate().init(alliance, direction, 300, 25)
			spear.transform *= 2
			spear.max_hits = -1
			spear.payload
			get_parent().add_child(spear)

		AbilityEffect.FLAG.END:
			pass

		AbilityEffect.FLAG.TICK:
			pass

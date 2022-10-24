extends Node

class_name AbilityEffectDetails

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
			var spear = proj_spear.instantiate()
			spear.vecocity = direction * 10
			spear.damage = 15 + instance.level * 5
			spear.direction.angle()
			add_child(spear)

		AbilityEffect.FLAG.END:
			pass

		AbilityEffect.FLAG.TICK:
			pass

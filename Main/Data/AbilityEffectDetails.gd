extends Node

func mind_dart(instance: AbilityEffect, flag: AbilityEffect.FLAG):
	match flag:
		AbilityEffect.FLAG.START:
			instance.props["unit_target"].apply_damage(10 + instance.level * 5)

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
			instance.props["unit_target"].apply_healing(5 + instance.level * 1)
			return

func poison_nova(instance: AbilityEffect, flag: AbilityEffect.FLAG):
	match flag:
		AbilityEffect.FLAG.START:
			instance.duration = 10

		AbilityEffect.FLAG.END:
			pass

		AbilityEffect.FLAG.TICK:
			instance.props["unit_target"].apply_damage(7 + instance.level * 3)

func summon_imp(instance: AbilityEffect, flag: AbilityEffect.FLAG):
	match flag:
		AbilityEffect.FLAG.START:
			print("Tried to summon imp, but failed")
			pass

		AbilityEffect.FLAG.END:
			pass

		AbilityEffect.FLAG.TICK:
			pass

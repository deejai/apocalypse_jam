extends Node

#func template_effect(instance: ArenaUnitEffect, flag: ArenaUnitEffect.FLAG):
#	match flag:
#		ArenaUnitEffect.FLAG.START:
#			# do something on effect start
#			pass
#
#		ArenaUnitEffect.FLAG.END:
#			# do something at end of duration
#			pass
#
#		ArenaUnitEffect.FLAG.TICK:
#			# do something every tick
#			pass

func mind_dart(instance: ArenaUnitEffect, flag: ArenaUnitEffect.FLAG):
	match flag:
		ArenaUnitEffect.FLAG.START:
			instance.arena_unit.take_damage(10 + instance.level * 5)

		ArenaUnitEffect.FLAG.END:
			pass

		ArenaUnitEffect.FLAG.TICK:
			pass

func soothing_vines(instance: ArenaUnitEffect, flag: ArenaUnitEffect.FLAG):
	match flag:
		ArenaUnitEffect.FLAG.START:
			instance.duration = 3000
			return

		ArenaUnitEffect.FLAG.END:
			return

		ArenaUnitEffect.FLAG.TICK:
			instance.arena_unit.receive_healing(5 + instance.level * 1)
			return

func poison_nova(instance: ArenaUnitEffect, flag: ArenaUnitEffect.FLAG):
	match flag:
		ArenaUnitEffect.FLAG.START:
			instance.duration = 10

		ArenaUnitEffect.FLAG.END:
			pass

		ArenaUnitEffect.FLAG.TICK:
			instance.arena_unit.take_damage(7 + instance.level * 3)

func summon_imp(instance: ArenaUnitEffect, flag: ArenaUnitEffect.FLAG):
	match flag:
		ArenaUnitEffect.FLAG.START:
			print("Tried to summon imp, but failed")
			pass

		ArenaUnitEffect.FLAG.END:
			pass

		ArenaUnitEffect.FLAG.TICK:
			pass

var arena_unit_effects = {
	"Mind Dart": mind_dart,
	"Soothing Vines": soothing_vines,
	"Poison Nova": poison_nova,
	"Summon Imp": summon_imp,
}

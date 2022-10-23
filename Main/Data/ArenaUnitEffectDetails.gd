extends Node

enum TARGETING_TYPE {SELF, POINT, UNIT, UNIT_ENEMY, UNIT_ALLY}

func mind_dart(instance: ArenaUnitEffect, flag: ArenaUnitEffect.FLAG):
	if(flag == ArenaUnitEffect.FLAG.START):
		instance.arena_unit.take_damage(10 + instance.level * 5)
		return
	elif(flag == ArenaUnitEffect.FLAG.END):
		return
		
	# no tick

func soothing_vines(instance: ArenaUnitEffect, flag: ArenaUnitEffect.FLAG):
	if(flag == ArenaUnitEffect.FLAG.START):
		instance.duration = 3000
		return
	elif(flag == ArenaUnitEffect.FLAG.END):
		return

	instance.arena_unit.receive_healing(5 + instance.level * 1)

func poison_nova(instance: ArenaUnitEffect, flag: ArenaUnitEffect.FLAG):
	if(flag == ArenaUnitEffect.FLAG.START):
		instance.duration = 10
		return
	elif(flag == ArenaUnitEffect.FLAG.END):
		return

	instance.arena_unit.take_damage(7 + instance.level * 3)

var arena_unit_effects = {
	"Mind Dart": mind_dart,
	"Soothing Vines": soothing_vines,
	"Poison Nova": poison_nova,
}

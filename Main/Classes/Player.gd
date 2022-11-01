extends Node

class_name Player

var inventory: Array = []
var floor: Floor = null

var squad: Array = []

var remaining_titans: Array = []

func _init(newgame: bool = true):
	if newgame:
		remaining_titans = [Shared.BASE.TITAN_CRIUS, Shared.BASE.TITAN_HYPERION, Shared.BASE.TITAN_OCEANUS, Shared.BASE.TITAN_THEMIS, Shared.BASE.TITAN_PHOEBE, Shared.BASE.TITAN_CRONUS]
		floor = Floor.new(0, remaining_titans)
		squad = [
		#	{"unit": Unit.new(Shared.BASE.OLYMPIAN_APOLLO), "start_position": Vector2(400, 720-100)},
		#	{"unit": Unit.new(Shared.BASE.OLYMPIAN_ARES), "start_position": Vector2(400, 720-100)},
		#	{"unit": Unit.new(Shared.BASE.OLYMPIAN_ATHENA), "start_position": Vector2(300, 720-100)},
		#	{"unit": Unit.new(Shared.BASE.OLYMPIAN_HADES), "start_position": Vector2(400, 720-100)},
		#	{"unit": Unit.new(Shared.BASE.OLYMPIAN_HERMES), "start_position": Vector2(400, 720-100)},
#			{"unit": Unit.new(Shared.BASE.OLYMPIAN_ZEUS), "start_position": Vector2(400, 720-100)},
			{"unit": Unit.new(Shared.BASE.SOLDIER_SWORD), "start_position": Vector2(250, 720-70)},
			{"unit": Unit.new(Shared.BASE.SOLDIER_SPEAR), "start_position": Vector2(350, 720-70)},
			{"unit": Unit.new(Shared.BASE.SOLDIER_ARCHER), "start_position": Vector2(450, 720-70)},
			{"unit": Unit.new(Shared.BASE.HEALER), "start_position": Vector2(550, 720-40)},
		]
		
	else:
		floor = Floor.new(-1, [])

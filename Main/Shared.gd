extends Node

class_name Shared

enum REWARD_TYPE {NEW_UNIT, UNIT_UPGRADE, WILDCARD}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

static func get_models():
	return {
		Unit.BASE.OLYMPIAN_APOLLO: load("res://Main/Views/ArenaView/ArenaUnits/Olympian_Apollo.tscn"),
		Unit.BASE.OLYMPIAN_ATHENA: load("res://Main/Views/ArenaView/ArenaUnits/Olympian_Athena.tscn"),
		Unit.BASE.OLYMPIAN_ARES: load("res://Main/Views/ArenaView/ArenaUnits/Olympian_Ares.tscn"),
		Unit.BASE.OLYMPIAN_HADES: load("res://Main/Views/ArenaView/ArenaUnits/Olympian_Hades.tscn"),
		Unit.BASE.OLYMPIAN_HERMES: load("res://Main/Views/ArenaView/ArenaUnits/Olympian_Hermes.tscn"),
		Unit.BASE.OLYMPIAN_ZEUS: load("res://Main/Views/ArenaView/ArenaUnits/Olympian_Zeus.tscn"),
		Unit.BASE.SOLDIER_SWORD: load("res://Main/Views/ArenaView/ArenaUnits/Soldier_Sword.tscn"),
		Unit.BASE.SOLDIER_SPEAR: load("res://Main/Views/ArenaView/ArenaUnits/Soldier_Spear.tscn"),
		Unit.BASE.SOLDIER_ARCHER: load("res://Main/Views/ArenaView/ArenaUnits/Soldier_Archer.tscn"),
		Unit.BASE.HEALER: load("res://Main/Views/ArenaView/ArenaUnits/Healer.tscn"),
	}

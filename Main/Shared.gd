extends Node

class_name Shared

enum REWARD_TYPE {NEW_UNIT, UNIT_UPGRADE, WILDCARD}
enum TARGETING_TYPE {SELF, POINT, SINGLE_UNIT, UNITS_IN_AOE}
enum TARGETS {SAME, OTHER, ALL}
enum SPEC { NORMAL, HERO, SUMMON }
enum BASE { OLYMPIAN_APOLLO, OLYMPIAN_ATHENA, OLYMPIAN_ARES, OLYMPIAN_HADES, OLYMPIAN_HERMES, OLYMPIAN_ZEUS, SOLDIER_SPEAR, SOLDIER_SWORD, SOLDIER_ARCHER, HEALER }

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

static func get_models():
	return {
		BASE.OLYMPIAN_APOLLO: load("res://Main/Views/ArenaView/ArenaUnits/Olympian_Apollo.tscn"),
		BASE.OLYMPIAN_ATHENA: load("res://Main/Views/ArenaView/ArenaUnits/Olympian_Athena.tscn"),
		BASE.OLYMPIAN_ARES: load("res://Main/Views/ArenaView/ArenaUnits/Olympian_Ares.tscn"),
		BASE.OLYMPIAN_HADES: load("res://Main/Views/ArenaView/ArenaUnits/Olympian_Hades.tscn"),
		BASE.OLYMPIAN_HERMES: load("res://Main/Views/ArenaView/ArenaUnits/Olympian_Hermes.tscn"),
		BASE.OLYMPIAN_ZEUS: load("res://Main/Views/ArenaView/ArenaUnits/Olympian_Zeus.tscn"),
		BASE.SOLDIER_SWORD: load("res://Main/Views/ArenaView/ArenaUnits/Soldier_Sword.tscn"),
		BASE.SOLDIER_SPEAR: load("res://Main/Views/ArenaView/ArenaUnits/Soldier_Spear.tscn"),
		BASE.SOLDIER_ARCHER: load("res://Main/Views/ArenaView/ArenaUnits/Soldier_Archer.tscn"),
		BASE.HEALER: load("res://Main/Views/ArenaView/ArenaUnits/Healer.tscn"),
	}

static func get_unit_data():
	return {
		BASE.OLYMPIAN_APOLLO:  {
			"spec": SPEC.HERO,
			"voice": Audio.VOICE.APOLLO,
			"range": 200,
			"hp": 200,
			"speed": 150,
			"attack_damage": 15,
			"attack_speed": 100,
			"activated_abilities":  ["Hellfire"],
			"passive_abilities": []
		},
		BASE.OLYMPIAN_ARES:  {
			"spec": SPEC.HERO,
			"voice": Audio.VOICE.ARES,
			"range": 50,
			"hp": 300,
			"speed": 100,
			"attack_damage": 30,
			"attack_speed": 50,
			"activated_abilities":  [],
			"passive_abilities": []
		},
		BASE.OLYMPIAN_ATHENA:  {
			"spec": SPEC.HERO,
			"voice": Audio.VOICE.ATHENA,
			"range": 50,
			"hp": 220,
			"speed": 100,
			"attack_damage": 15,
			"attack_speed": 100,
			"activated_abilities":  ["Heal"],
			"passive_abilities": []
		},
		BASE.OLYMPIAN_HADES:  {
			"spec": SPEC.HERO,
			"voice": Audio.VOICE.HADES,
			"range": 150,
			"hp": 200,
			"speed": 100,
			"attack_damage": 10,
			"attack_speed": 100,
			"activated_abilities":  [],
			"passive_abilities": []
		},
		BASE.OLYMPIAN_HERMES:  {
			"spec": SPEC.HERO,
			"voice": Audio.VOICE.HERMES,
			"range": 50,
			"hp": 200,
			"speed": 200,
			"attack_damage": 8,
			"attack_speed": 200,
			"activated_abilities":  ["Mind Dart"],
			"passive_abilities": []
		},
		BASE.OLYMPIAN_ZEUS:  {
			"spec": SPEC.HERO,
			"voice": Audio.VOICE.ZEUS,
			"range": 150,
			"hp": 200,
			"speed": 130,
			"attack_damage": 15,
			"attack_speed": 100,
			"activated_abilities":  ["Zeus Storm"],
			"passive_abilities": ["Interrupting Shock"]
		},
		BASE.HEALER: {
			"spec": SPEC.NORMAL,
			"voice": Audio.VOICE.HEALER,
			"range": 100,
			"hp": 85,
			"speed": 100,
			"attack_damage": 6,
			"attack_speed": 100,
			"activated_abilities": ["Heal"],
			"passive_abilities": []
		},
		BASE.SOLDIER_SPEAR: {
			"spec": SPEC.NORMAL,
			"voice": Audio.VOICE.SOLDIER,
			"range": 50,
			"hp": 120,
			"speed": 80,
			"attack_damage": 10,
			"attack_speed": 100,
		},
		BASE.SOLDIER_SWORD: {
			"spec": SPEC.NORMAL,
			"voice": Audio.VOICE.SOLDIER,
			"range": 50,
			"hp": 100,
			"speed": 150,
			"attack_damage": 8,
			"attack_speed": 100,
		},
		BASE.SOLDIER_ARCHER: {
			"spec": SPEC.NORMAL,
			"voice": Audio.VOICE.SOLDIER,
			"range": 150,
			"hp": 85,
			"speed": 120,
			"attack_damage": 8,
			"attack_speed": 100,
		}
	}

extends Node

class_name Unit

enum SPEC { NORMAL, HERO, SUMMON }
enum BASE { OLYMPIAN_APOLLO, OLYMPIAN_ATHENA, OLYMPIAN_ARES, OLYMPIAN_HADES, OLYMPIAN_HERMES, OLYMPIAN_ZEUS, SOLDIER_SPEAR, SOLDIER_SWORD, SOLDIER_ARCHER, HEALER }
var voice: Audio.VOICE

var status: String = "healthy"
var speed: float = 100
var hp: float = 100
var spec: int
var base: int
var range: int = 65
var attack_damage: float = 5
var attack_speed: float = 100

var level: int

var projectile

var activated_abilities = []
var passive_abilities = []

# @TODO: add more stats, add animations

var data = {
	BASE.OLYMPIAN_APOLLO:  {
		"spec": SPEC.HERO,
		"voice": Audio.VOICE.APOLLO,
		"range": 200,
		"hp": 150,
		"speed": 150,
		"attack_damage": 15,
		"attack_speed": 100,
		"abilities":  ["Hellfire"]
	},
	BASE.OLYMPIAN_ARES:  {
		"spec": SPEC.HERO,
		"voice": Audio.VOICE.ARES,
		"range": 50,
		"hp": 300,
		"speed": 100,
		"attack_damage": 30,
		"attack_speed": 50,
		"abilities":  []
	},
	BASE.OLYMPIAN_ATHENA:  {
		"spec": SPEC.HERO,
		"voice": Audio.VOICE.ATHENA,
		"range": 50,
		"hp": 200,
		"speed": 100,
		"attack_damage": 15,
		"attack_speed": 100,
		"abilities":  ["Heal"]
	},
	BASE.OLYMPIAN_HADES:  {
		"spec": SPEC.HERO,
		"voice": Audio.VOICE.HADES,
		"range": 150,
		"hp": 150,
		"speed": 100,
		"attack_damage": 10,
		"attack_speed": 100,
		"abilities":  []
	},
	BASE.OLYMPIAN_HERMES:  {
		"spec": SPEC.HERO,
		"voice": Audio.VOICE.HERMES,
		"range": 50,
		"hp": 100,
		"speed": 200,
		"attack_damage": 8,
		"attack_speed": 200,
		"abilities":  ["Mind Dart"]
	},
	BASE.OLYMPIAN_ZEUS:  {
		"spec": SPEC.HERO,
		"voice": Audio.VOICE.ZEUS,
		"range": 150,
		"hp": 200,
		"speed": 130,
		"attack_damage": 15,
		"attack_speed": 100,
		"abilities":  []
	},
	BASE.HEALER: {
		"spec": SPEC.NORMAL,
		"voice": Audio.VOICE.HEALER,
		"range": 100,
		"hp": 60,
		"speed": 100,
		"attack_damage": 6,
		"attack_speed": 100,
		"abilities": ["Heal"]
	},
	BASE.SOLDIER_SPEAR: {
		"spec": SPEC.NORMAL,
		"voice": Audio.VOICE.SOLDIER,
		"range": 50,
		"hp": 150,
		"speed": 080,
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
		"hp": 60,
		"speed": 120,
		"attack_damage": 8,
		"attack_speed": 100,
	}
}

func _init(base: Unit.BASE, level: int = 0):
	self.base = base
	
	
	self.level = level

	self.spec = data[base]["spec"]
	self.voice = data[base]["voice"]
	self.attack_damage = data[base]["attack_damage"] * (1.0 + 0.25 * level)
	self.range = data[base]["range"]
	self.hp = data[base]["hp"] * (1.0 + 0.15 * level)
	self.speed = data[base]["speed"]

	if data[base].has("abilities"):
		for ability_key in data[base]["abilities"]:
			var ability = ActivatedAbility.new(ability_key, level)
			self.activated_abilities.append(ability)
			
	
	match base:
		BASE.SOLDIER_SPEAR: projectile = load("res://Main/Views/ArenaView/Projectiles/Spear.tscn")
		_: projectile = load("res://Main/Views/ArenaView/Projectiles/Spear.tscn")

func get_meta_data():
	var abilities = []
	for arr in [activated_abilities, passive_abilities]:
		for ability in arr:
			abilities.append(ability)
	
	return {
		"stats": str("Speed: ", speed, "\nHP: ", hp, "\nRange: ", range, "\nAttack Damage: ", attack_damage, "\nAttack Speed: ", attack_speed, " (", 100.0/attack_speed, " attack(s) per second)"),
		"abilities": abilities
	}

extends Node

class_name Unit

enum SPEC { NORMAL, HERO, SUMMON }
enum BASE { OLYMPIAN_APOLLO, SOLDIER_SPEAR, SOLDIER_SWORD, SOLDIER_ARCHER, HEALER }

var status: String = "healthy"
var speed: float = 100
var hp: float = 100
var spec: int
var base: int
var range: int = 65
var attack_damage: float = 5
var attack_speed: float = 100

var abilities = []

# @TODO: add more stats, add animations

var data = {
	BASE.OLYMPIAN_APOLLO:  {
		"spec": SPEC.HERO,
		"range": 150,
		"hp": 180,
		"speed": 150,
		"attack_damage": 15,
		"attack_speed": 100,
	},
	BASE.HEALER: {
		"spec": SPEC.NORMAL,
		"range": 200,
		"hp": 60,
		"speed": 100,
		"attack_damage": 4,
		"attack_speed": 100,
	},
	BASE.SOLDIER_SPEAR: {
		"spec": SPEC.NORMAL,
		"range": 125,
		"hp": 100,
		"speed": 080,
		"attack_damage": 11,
		"attack_speed": 100,
	},
	BASE.SOLDIER_SWORD: {
		"spec": SPEC.NORMAL,
		"range": 75,
		"hp": 100,
		"speed": 150,
		"attack_damage": 10,
		"attack_speed": 100,
	},
	BASE.SOLDIER_ARCHER: {
		"spec": SPEC.NORMAL,
		"range": 250,
		"hp": 60,
		"speed": 120,
		"attack_damage": 8,
		"attack_speed": 100,
	}
}

func _init(base: Unit.BASE):
	self.base = base

	self.spec = data[base]["spec"]
	self.attack_damage = data[base]["attack_damage"]
	self.range = data[base]["range"]
	self.hp = data[base]["hp"]
	self.speed = data[base]["speed"]

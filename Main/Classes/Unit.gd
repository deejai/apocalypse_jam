extends Node

class_name Unit

enum SPEC { NORMAL, HERO, SUMMON }
enum BASE { OLYMPIAN_APOLLO, SOLDIER_SPEAR, SOLDIER_SWORD, SOLDIER_ARCHER, HEALER }

var status: String = "healthy"
var speed: float = 100
var hp: float = 100
var spec: SPEC
var base: BASE
var range: int = 65
var attack_damage: float = 5
var attack_speed: float = 100

# @TODO: add more stats, add animations

func _init(base: BASE):
	self.base = base
	
	match base:
		BASE.OLYMPIAN_APOLLO:
			self.spec = SPEC.HERO
			self.attack_damage = 9
			self.range = 150
			self.hp = 180
			self.speed = 150

		BASE.HEALER:
			self.spec = SPEC.NORMAL
			self.attack_damage = 3
			self.range = 175
			self.hp = 60
			self.speed = 100

		BASE.SOLDIER_SPEAR:
			self.spec = SPEC.NORMAL
			self.attack_damage = 5
			self.range = 85
			self.hp = 100
			self.speed = 120

		BASE.SOLDIER_SWORD:
			self.spec = SPEC.NORMAL
			self.attack_damage = 7
			self.range = 500
			self.hp = 100
			self.speed = 130

		BASE.SOLDIER_ARCHER:
			self.spec = SPEC.NORMAL
			self.attack_damage = 6
			self.range = 250
			self.hp = 60
			self.speed = 100

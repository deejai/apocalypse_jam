extends Node

class_name Unit

enum SPEC { NORMAL, HERO, SUMMON }
enum BASE { OLYMPIAN_APOLLO, SOLDIER_SPEAR, SOLDIER_SWORD, SOLDIER_ARCHER, HEALER }

var status: String = "healthy"
var speed: float
var hp: int
var spec: SPEC
var base: BASE
var range: int

# @TODO: add more stats, add animations

func _init(base: BASE):
	self.base = base
	
	match base:
		BASE.OLYMPIAN_APOLLO:
			self.spec = SPEC.HERO
			self.range = 150
			self.hp = 180
			self.speed = 1.5

		BASE.HEALER:
			self.spec = SPEC.NORMAL
			self.range = 200
			self.hp = 60
			self.speed = 1

		BASE.SOLDIER_SPEAR:
			self.spec = SPEC.NORMAL
			self.range = 125
			self.hp = 100
			self.speed = 1.2

		BASE.SOLDIER_SWORD:
			self.spec = SPEC.NORMAL
			self.range = 75
			self.hp = 100
			self.speed = 1.3

		BASE.SOLDIER_ARCHER:
			self.spec = SPEC.NORMAL
			self.range = 250
			self.hp = 60
			self.speed = 1

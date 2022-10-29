extends Node

class_name Unit

var voice: Audio.VOICE

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

func _init(base, level: int = 0):
	self.base = base
	
	
	self.level = level
	
	var data = Shared.get_unit_data()

	self.spec = data[base]["spec"]
	self.voice = data[base]["voice"]
	self.attack_damage = data[base]["attack_damage"] * (1.0 + 0.25 * level)
	self.range = data[base]["range"]
	self.hp = data[base]["hp"] * (1.0 + 0.15 * level)
	self.speed = data[base]["speed"]

	if data[base].has("activated_abilities"):
		for ability_key in data[base]["activated_abilities"]:

			var ability = ActivatedAbility.new(ability_key, level)
			self.activated_abilities.append(ability)

	if data[base].has("passive_abilities"):
		for ability_key in data[base]["passive_abilities"]:

			var ability = PassiveAbility.new(ability_key, level)
			self.passive_abilities.append(ability)
			
	
	match base:
		Shared.BASE.SOLDIER_SPEAR: projectile = load("res://Main/Views/ArenaView/Projectiles/Spear.tscn")
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

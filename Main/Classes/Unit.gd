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

<<<<<<< HEAD
func _init(base, level: int = 0):
=======
var data = {
	BASE.OLYMPIAN_HERMES:	{
		"spec": SPEC.HERO,
		"range": 25,
		"hp": 150,
		"speed": 200,
		"attack_damage": 5,
		"attack_speed": 200,
	},
	BASE.OLYMPIAN_APOLLO:  {
		"spec": SPEC.HERO,
		"range": 200,
		"hp": 150,
		"speed": 150,
		"attack_damage": 10,
		"attack_speed": 100,
	},
	BASE.OLYMPIAN_ZEUS:		{
		"spec": SPEC.HERO,
		"range": 150,
		"hp": 200,
		"speed": 130,
		"attack_damage": 10,
		"attack_speed": 100,
	},
	BASE.OLYMPIAN_ARES:		{
		"spec": SPEC.HERO,
		"range": 50,
		"hp": 300,
		"speed": 75,
		"attack_damage": 15,
		"attack_speed": 100,
	},
	BASE.OLYMPIAN_ATHENA:		{
		"spec": SPEC.HERO,
		"range": 50,
		"hp": 200,
		"speed": 100,
		"attack_damage": 10,
		"attack_speed": 100,
	},
	BASE.OLYMPIAN_HADES:		{
		"spec": SPEC.HERO,
		"range": 150,
		"hp": 150,
		"speed": 100,
		"attack_damage": 8,
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
>>>>>>> 56c714f343991859e6fca498e5f6afe507382300
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
		Shared.BASE.SOLDIER_SPEAR, Shared.BASE.OLYMPIAN_ATHENA: projectile = load("res://Main/Views/ArenaView/Projectiles/Spear.tscn")
		Shared.BASE.OLYMPIAN_ARES, Shared.BASE.SOLDIER_SWORD: projectile = load("res://Main/Views/ArenaView/Projectiles/Sword.tscn")
		Shared.BASE.OLYMPIAN_APOLLO, Shared.BASE.SOLDIER_ARCHER: projectile = load("res://Main/Views/ArenaView/Projectiles/Arrow.tscn")
		Shared.BASE.HEALER: projectile = load("res://Main/Views/ArenaView/Projectiles/Vine.tscn")
		Shared.BASE.OLYMPIAN_HERMES: projectile = load("res://Main/Views/ArenaView/Projectiles/Bubble.tscn")
		Shared.BASE.OLYMPIAN_ZEUS: projectile = load("res://Main/Views/ArenaView/Projectiles/Zap.tscn")
		Shared.BASE.OLYMPIAN_HADES: projectile = load("res://Main/Views/ArenaView/Projectiles/Fire.tscn")
		Shared.BASE.TITAN_CRIUS: projectile = load("res://Main/Views/ArenaView/Projectiles/Fire.tscn")
		Shared.BASE.TITAN_CRONUS: projectile = load("res://Main/Views/ArenaView/Projectiles/Spear.tscn")
		Shared.BASE.TITAN_HYPERION: projectile = load("res://Main/Views/ArenaView/Projectiles/Fire.tscn")
		Shared.BASE.TITAN_OCEANUS: projectile = load("res://Main/Views/ArenaView/Projectiles/Bubble.tscn")
		Shared.BASE.TITAN_PHOEBE: projectile = load("res://Main/Views/ArenaView/Projectiles/Zap.tscn")
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

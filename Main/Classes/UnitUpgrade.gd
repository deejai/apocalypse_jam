extends Node

class_name UnitUpgrade

enum EFFECT {MORE_HP, MORE_SPEED, MORE_DAMAGE, MORE_ATTACK_SPEED, RAND}

var effect: EFFECT
var amount: int

func _init(level:int, effect: EFFECT = EFFECT.RAND):
	if effect != EFFECT.RAND:
		self.effect = effect
	else:
		var roll = randf()
		self.effect = EFFECT.MORE_HP if roll < .3333 else EFFECT.MORE_SPEED if roll < .6667 else EFFECT.MORE_DAMAGE

	self.amount = 1 + randi_range(0, 2 + level*2)

	# rare chance to get next level upgrade
	var roll = randf()
	if roll > 0.9:
		self.amount += 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func apply(unit: Unit):
	if effect == EFFECT.MORE_HP:
		unit.hp += amount * 10
	elif effect == EFFECT.MORE_SPEED:
		unit.speed += amount * 10
	elif effect == EFFECT.MORE_DAMAGE:
		unit.attack_damage += amount
	elif effect == EFFECT.MORE_ATTACK_SPEED:
		unit.attack_speed += amount

extends Node

class_name UnitUpgrade

enum EFFECT {MORE_HP, MORE_DAMAGE, MORE_SPEED, MORE_RANGE, RAND}

var effect: EFFECT
var amount: int

func _init(level:int, effect: EFFECT = EFFECT.RAND):
	if effect != EFFECT.RAND:
		self.effect = effect
	else:
		var roll = randf()
		self.effect = EFFECT.values()[randi() % (len(EFFECT)-1)]

	var multiplier
	match self.effect:
		EFFECT.MORE_HP:
			multiplier = 24
		EFFECT.MORE_SPEED:
			multiplier = 18
		EFFECT.MORE_DAMAGE:
			multiplier = 3
		EFFECT.MORE_RANGE:
			multiplier = 18
		_:
			assert(false)


	# rare chance to get next level upgrade
	var roll = randf()
	if roll > 0.9:
		self.amount += randi_range(1,2)

	self.amount = randi_range(1 + multiplier/2, (2 + level)*multiplier)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func apply(unit):
	match effect:
		EFFECT.MORE_HP:
			unit.hp += amount
		EFFECT.MORE_SPEED:
			unit.speed += amount
		EFFECT.MORE_DAMAGE:
			unit.attack_damage += amount
		EFFECT.MORE_RANGE:
			unit.range += amount
		_:
			assert(false)

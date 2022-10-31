extends Node

class_name PassiveAbility

var level
var key
var icon
var effect_fn: Callable
var cooldown: int
var targets: Shared.TARGETS
var description: String
var sound

func _init(key: String, level: int = 0):
	self.key = key
	self.level = level
	
	set_level(level)
	

func get_meta_data():
	return description

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

static func get_ability_data():
	return {
		"Interrupting Shock": {
			"icon": load("res://Assets/PNG/bg.png"),
			"sound": Audio.effects.get_node("lightning1"),
			"effect_fn": func(instance, target):
				target.apply_status(ArenaUnit.STATUS.STUN, 0.3 + 0.15 * instance.level)
				target.apply_damage(4 + 1 * instance.level),
			"cooldown": 4,
			"targets": Shared.TARGETS.OTHER,
			"description_fn": func(level): return str("Stun nearby enemies for ", 0.3 + 0.15 * level, " seconds and deal ", 4 + 1 * level, " damage every 4 seconds")
		},
		"Healing Wind": {
			"icon": load("res://Assets/PNG/bg.png"),
			"sound": Audio.effects.get_node("heal2"),
			"effect_fn": func(instance, target):
				target.apply_status(ArenaUnit.STATUS.HEAL, 0.3)
				target.apply_healing(4 + 1 * instance.level),
			"cooldown": 6,
			"targets": Shared.TARGETS.SAME,
			"description_fn": func(level): return str("Heal nearby allies for ", 4 + 1 * level, " hp every 6 seconds")
		},
		"Apollos Heat": {
			"icon": load("res://Assets/PNG/bg.png"),
			"sound": Audio.effects.get_node("fireattack1"),
			"effect_fn": func(instance, target):
				target.apply_status(ArenaUnit.STATUS.FIRE, 0.3)
				target.apply_damage(4 + 1 * instance.level),
			"cooldown": 1,
			"targets": Shared.TARGETS.OTHER,
			"description_fn": func(level): return str("Damage nearby enemies for ", 1 * level, " hp every second")
		},
		"Hades Despair": {
			"icon": load("res://Assets/PNG/bg.png"),
			"sound": Audio.effects.get_node("fireattack1"),
			"effect_fn": func(instance, target):
				target.apply_status(ArenaUnit.STATUS.POISON, 0.3)
				target.apply_damage(1 + 1 * instance.level),
			"cooldown": 1,
			"targets": Shared.TARGETS.OTHER,
			"description_fn": func(level): return str("Damage nearby enemies for ", 1+1 * level, " hp every second")
			},
		"Hermes Feet": {
			"icon": load("res://Assets/PNG/bg.png"),
			"sound": Audio.effects.get_node("apollo_woosh"),
			"effect_fn": func(instance, target):
				target.apply_damage(1 + 1 * instance.level),
			"cooldown": 1,
			"targets": Shared.TARGETS.OTHER,
			"description_fn": func(level): return str("Damage nearby enemies for ", 1+1 * level, " hp every second")
			}
	}

func _set_details():
	var data = get_ability_data()[key]
	print(key)
	icon = data["icon"]
	sound = data["sound"]
	sound.volume_db = -12
	effect_fn = func(instance, target):
		sound.play()
		data["effect_fn"].call(instance, target)
	cooldown = data["cooldown"]
	targets = data["targets"]
	description = data["description_fn"].call(level)

func set_level(level: int):
	assert(level >= 0)
	self.level = level
	_set_details()

func level_up():
	set_level(level+1)

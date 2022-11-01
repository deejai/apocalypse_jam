extends Node

class_name ActivatedAbility

<<<<<<< HEAD
=======
enum TARGETING_TYPE {SELF, POINT, UNIT, UNIT_ENEMY, UNIT_PLAYER}

>>>>>>> 56c714f343991859e6fca498e5f6afe507382300
var key: String
var icon: CompressedTexture2D
var cooldown: float
var level: int
var targeting_type: Shared.TARGETING_TYPE
var area_of_effect: int
var duration: float
var effect_fn: Callable
var range: int
var targets: Shared.TARGETS
var description: String
var sound

func _init (
	key: String,
	level: int
):
	self.key = key
	set_level(level)

static func mind_dart(instance: AbilityEffect, flag: AbilityEffect.FLAG):
	if not is_instance_valid(instance.props["target_unit"]):
		instance.queue_free()
		return

	match flag:
		AbilityEffect.FLAG.START:
			instance.props["target_unit"].apply_damage(10 + instance.level * 5)

		AbilityEffect.FLAG.END:
			pass

		AbilityEffect.FLAG.TICK:
			pass

static func heal(instance: AbilityEffect, flag: AbilityEffect.FLAG):
	if not is_instance_valid(instance.props["target_unit"]):
		instance.queue_free()
		return

	match flag:
		AbilityEffect.FLAG.START:
			instance.props["target_unit"].apply_status(ArenaUnit.STATUS.HEAL, .3)
			instance.props["target_unit"].apply_healing(10 + instance.level * 5)
			return

		AbilityEffect.FLAG.END:
			return

		AbilityEffect.FLAG.TICK:
			return

static func hellfire(instance: AbilityEffect, flag: AbilityEffect.FLAG):
	if not is_instance_valid(instance.props["target_unit"]):
		instance.queue_free()
		return

	match flag:
		AbilityEffect.FLAG.START:
			instance.props["target_unit"].apply_status(ArenaUnit.STATUS.ONFIRE, .3)
			return

		AbilityEffect.FLAG.END:
			return

		AbilityEffect.FLAG.TICK:
			instance.props["target_unit"].apply_status(ArenaUnit.STATUS.ONFIRE, .3)
			instance.props["target_unit"].apply_damage(5 + instance.level * 3)
			return

static func poison_nova(instance: AbilityEffect, flag: AbilityEffect.FLAG):
	if not is_instance_valid(instance.props["target_unit"]):
		instance.queue_free()
		return

	match flag:
		AbilityEffect.FLAG.START:
			instance.duration = 10

		AbilityEffect.FLAG.END:
			pass

		AbilityEffect.FLAG.TICK:
			instance.props["target_unit"].apply_damage(7 + instance.level * 3)

static func summon_zombie(instance: AbilityEffect, flag: AbilityEffect.FLAG):
	match flag:
		AbilityEffect.FLAG.START:
			print("Tried to summon imp, but failed")
			pass

		AbilityEffect.FLAG.END:
			pass

		AbilityEffect.FLAG.TICK:
			pass

static func flaming_spear(instance: AbilityEffect, flag: AbilityEffect.FLAG):
	match flag:
		AbilityEffect.FLAG.START:
			var direction = instance.props["source_unit"].direction_to(instance.props["target_point"])
			var alliance = instance.props["source_unit"].alliance
			var spear = load("res://Main/Views/ArenaView/Projectiles/Spear.tscn").instantiate().init(alliance, direction, 300, 25)
			spear.transform *= 2
			spear.max_hits = -1
			spear.payload = func(target):
				target.apply_damage(10 + 5 * instance.level)
				target.apply_status(ArenaUnit.STATUS.ONFIRE, 0.5)
			Game.arena.add_child(spear)

		AbilityEffect.FLAG.END:
			pass

		AbilityEffect.FLAG.TICK:
			pass

static func zeus_lightning(instance: AbilityEffect, flag: AbilityEffect.FLAG):
	if not is_instance_valid(instance.props["target_unit"]):
		instance.queue_free()
		return

	match flag:
		AbilityEffect.FLAG.START:
			instance.props["target_unit"].apply_status(ArenaUnit.STATUS.LIGHTNING, 0.5)
			pass

		AbilityEffect.FLAG.END:
			pass

		AbilityEffect.FLAG.TICK:
			instance.props["target_unit"].apply_status(ArenaUnit.STATUS.LIGHTNING, 0.5)
			instance.props["target_unit"].apply_damage(5 + instance.level*3)
			pass

static func hand_of_hades(instance: AbilityEffect, flag: AbilityEffect.FLAG):
	if not is_instance_valid(instance.props["target_unit"]):
		instance.queue_free()
		return

	match flag:
		AbilityEffect.FLAG.START:
			instance.props["target_unit"].apply_status(ArenaUnit.STATUS.ROOT, 5 + instance.level)
			pass

		AbilityEffect.FLAG.END:
			pass

		AbilityEffect.FLAG.TICK:
			instance.props["target_unit"].apply_damage(5 + instance.level*3)
			pass
			
static func cycle_of_war(instance: AbilityEffect, flag: AbilityEffect.FLAG):
	if not is_instance_valid(instance.props["target_unit"]):
		instance.queue_free()
		return

	match flag:
		AbilityEffect.FLAG.START:
			instance.props["target_unit"].apply_damage(20 + instance.level*5)
			pass

		AbilityEffect.FLAG.END:
			pass

		AbilityEffect.FLAG.TICK:
			pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _set_details():
	var data = get_ability_data()[key]
	icon = data["icon"]
	sound = data["sound"]
	sound.volume_db = -8
	effect_fn = func(instance, flag):
		sound.play()
		data["effect_fn"].call(instance, flag)
	targeting_type = data["targeting_type"]
	cooldown = data["cooldown_fn"].call(level)
	range = data["range_fn"].call(level)
	area_of_effect = data["area_of_effect_fn"].call(level)
	duration = data["duration_fn"].call(level)
	targets = data["targets"]
	description = data["description_fn"].call(level)

func set_level(level: int):
	assert(level >= 0)
	self.level = level
	_set_details()

func level_up():
	set_level(level+1)

func get_meta_data():
	return str(description, "\n\nCooldown: ", cooldown, "s\nRange: ", range, "\nArea of Effect: ", area_of_effect, "\nDuration: ", duration, "s")

static func get_ability_data():
	return {
		"Mind Dart": {
			"icon": load("res://Assets/PNG/bg.png"),
			"sound": Audio.effects.get_node("arrow1"),
			"effect_fn": func(instance, flag): ActivatedAbility.mind_dart(instance, flag),
			"targeting_type": Shared.TARGETING_TYPE.SINGLE_UNIT,
			"targets": Shared.TARGETS.OTHER,
			"cooldown_fn": func(level): return max(3, 6 - level),
			"range_fn": func(level): return 200,
			"area_of_effect_fn": func(level): return 0,
			"duration_fn": func(level): return 0,
			"description_fn": func(level): return str("Shoot a projectile that deals ", 10 + 5*level, " instant damage to a unit")
		},
		"Conjure Spear": {
			"icon": load("res://Assets/PNG/bg.png"),
			"sound": Audio.effects.get_node("arrow1"),
			"effect_fn": func(instance, flag): ActivatedAbility.flaming_spear(instance, flag),
			"targeting_type": Shared.TARGETING_TYPE.POINT,
			"targets": Shared.TARGETS.OTHER,
			"cooldown_fn": func(level): return max(3, 6 - level),
			"range_fn": func(level): return 200,
			"area_of_effect_fn": func(level): return 0,
			"duration_fn": func(level): return 0,
			"description_fn": func(level): return str("Shoot a projectile that deals ", 10 + 5*level, " instant damage to a unit")
		},
		"Hellfire": {
			"icon": load("res://Assets/PNG/bg.png"),
			"sound": Audio.effects.get_node("fireattack1"),
			"effect_fn": func(instance, flag): ActivatedAbility.hellfire(instance, flag),
			"targeting_type": Shared.TARGETING_TYPE.UNITS_IN_AOE,
			"targets": Shared.TARGETS.OTHER,
			"cooldown_fn": func(level): return max(8, 12 - level),
			"range_fn": func(level): return 135,
			"area_of_effect_fn": func(level): return 50 + level * 20,
			"duration_fn": func(level): return 3,
			"description_fn": func(level): return str("Deal ", 5 + 3*level, " damage in a targeted area every 0.5 seconds")
		},
		"Heal": {
			"icon": load("res://Assets/RPG_Fantasy_256/HeatFull.png"),
			"sound": Audio.effects.get_node("heal2"),
			"effect_fn": func(instance, flag): ActivatedAbility.heal(instance, flag),
			"targeting_type": Shared.TARGETING_TYPE.SINGLE_UNIT,
			"targets": Shared.TARGETS.SAME,
			"cooldown_fn": func(level): return max(3, 6 - level),
			"range_fn": func(level): return 200,
			"area_of_effect_fn": func(level): return 0,
			"duration_fn": func(level): return 0,
			"description_fn": func(level): return str(10 + 5*level, " instant heal to a friendly unit")
		},
		"Lightning Storm": {
			"icon": load("res://Assets/PNG/bg.png"),
			"sound": Audio.effects.get_node("lightning1"),
			"effect_fn": func(instance, flag): ActivatedAbility.zeus_lightning(instance, flag),
			"targeting_type": Shared.TARGETING_TYPE.UNITS_IN_AOE,
			"targets": Shared.TARGETS.OTHER,
			"cooldown_fn": func(level): return max(8, 12 - level),
			"range_fn": func(level): return 135,
			"area_of_effect_fn": func(level): return 50 + level * 20,
			"duration_fn": func(level): return 3,
			"description_fn": func(level): return str("Deal ", 5 + 3*level, " damage in a targeted area every 0.5 seconds")
		},
		"Cycle of War": {
			"icon": load("res://Assets/PNG/bg.png"),
			"sound": Audio.effects.get_node("ares_drums"),
			"effect_fn": func(instance, flag): ActivatedAbility.cycle_of_war(instance, flag),
			"targeting_type": Shared.TARGETING_TYPE.UNITS_IN_AOE,
			"targets": Shared.TARGETS.OTHER,
			"cooldown_fn": func(level): return max(8, 12 - level),
			"range_fn": func(level): return 0,
			"area_of_effect_fn": func(level): return 50 + level * 20,
			"duration_fn": func(level): return 0,
			"description_fn": func(level): return str("Deal ", 20 + 5*level, " damage centered on caster")
		},
		"Hand of Hades": {
			"icon": load("res://Assets/PNG/bg.png"),
			"sound": Audio.effects.get_node("ares_drums"),
			"effect_fn": func(instance, flag): ActivatedAbility.hand_of_hades(instance, flag),
			"targeting_type": Shared.TARGETING_TYPE.UNITS_IN_AOE,
			"targets": Shared.TARGETS.OTHER,
			"cooldown_fn": func(level): return max(8, 12 - level),
			"range_fn": func(level): return 135,
			"area_of_effect_fn": func(level): return 50 + level * 20,
			"duration_fn": func(level): return 5,
			"description_fn": func(level): return str("Root enemies in place for ", 5 +1*level, " seconds")
		},
	}

extends Node

class_name ActivatedAbility

enum TARGETING_TYPE {SELF, POINT, SINGLE_UNIT, UNITS_IN_AOE}
enum TARGETS {SAME, OTHER, ALL}

var key: String
var icon: CompressedTexture2D
var cooldown: float
var level: int
var targeting_type: TARGETING_TYPE
var area_of_effect: int
var duration: float
var effect_fn: Callable
var range: int
var targets: TARGETS

func _init (
	key: String,
	level: int
):
	self.key = key
	set_level(level)

var ability_data = {
	"Mind Dart": {
		"icon": load("res://Assets/PNG/bg.png"),
		"effect_fn": mind_dart,
		"targeting_type": ActivatedAbility.TARGETING_TYPE.SINGLE_UNIT,
		"targets": ActivatedAbility.TARGETS.OTHER,
		"cooldown_fn": func(level): return max(3, 6 - level),
		"range_fn": func(level): return 200,
		"area_of_effect_fn": func(level): return 0,
		"duration_fn": func(level): return 0,
	},
	"Hellfire": {
		"icon": load("res://Assets/PNG/bg.png"),
		"effect_fn": hellfire,
		"targeting_type": ActivatedAbility.TARGETING_TYPE.UNITS_IN_AOE,
		"targets": ActivatedAbility.TARGETS.OTHER,
		"cooldown_fn": func(level): return max(8, 12 - level),
		"range_fn": func(level): return 135,
		"area_of_effect_fn": func(level): return 50 + level * 20,
		"duration_fn": func(level): return 3,
	}
}

var proj_spear = load("res://Main/Views/ArenaView/Projectiles/Spear.tscn")

func mind_dart(instance: AbilityEffect, flag: AbilityEffect.FLAG):
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

func soothing_vines(instance: AbilityEffect, flag: AbilityEffect.FLAG):
	if not is_instance_valid(instance.props["target_unit"]):
		instance.queue_free()
		return

	match flag:
		AbilityEffect.FLAG.START:
			instance.duration = 3
			return

		AbilityEffect.FLAG.END:
			return

		AbilityEffect.FLAG.TICK:
			instance.props["target_unit"].apply_healing(5 + instance.level * 1)
			return

func poison_nova(instance: AbilityEffect, flag: AbilityEffect.FLAG):
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

func summon_imp(instance: AbilityEffect, flag: AbilityEffect.FLAG):
	match flag:
		AbilityEffect.FLAG.START:
			print("Tried to summon imp, but failed")
			pass

		AbilityEffect.FLAG.END:
			pass

		AbilityEffect.FLAG.TICK:
			pass

func throw_spear(instance: AbilityEffect, flag: AbilityEffect.FLAG):
	if not is_instance_valid(instance.props["target_unit"]) or not is_instance_valid(instance.props["source_unit"]):
		instance.queue_free()
		return

	match flag:
		AbilityEffect.FLAG.START:
			var direction = instance.props["source_unit"].direction_to(instance.props["target_unit"])
			var alliance = instance.props["source_unit"].alliance
			var spear = proj_spear.instantiate().init(alliance, direction, 300, 25)
			spear.transform *= 2
			spear.max_hits = -1
			get_parent().add_child(spear)

		AbilityEffect.FLAG.END:
			pass

		AbilityEffect.FLAG.TICK:
			pass

func hellfire(instance: AbilityEffect, flag: AbilityEffect.FLAG):
	if not is_instance_valid(instance.props["target_unit"]):
		instance.queue_free()
		return

	match flag:
		AbilityEffect.FLAG.START:
			instance.props["target_unit"].apply_status(ArenaUnit.STATUS.ONFIRE, 3)
			pass

		AbilityEffect.FLAG.END:
			pass

		AbilityEffect.FLAG.TICK:
			instance.props["target_unit"].apply_damage(5 + level*3)
			pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _set_details():
	var data = ability_data[key]
	icon = data["icon"]
	effect_fn = data["effect_fn"]
	targeting_type = data["targeting_type"]
	cooldown = data["cooldown_fn"].call(level)
	range = data["range_fn"].call(level)
	area_of_effect = data["area_of_effect_fn"].call(level)
	duration = data["duration_fn"].call(level)
	targets = data["targets"]

func set_level(level: int):
	assert(level >= 0)
	self.level = level
	_set_details()

static func affected_alliances(alliance: ArenaUnit.ALLIANCE, which: TARGETS) -> Array[ArenaUnit.ALLIANCE]:
	match which:
		TARGETS.SAME:
			return [alliance]
		TARGETS.OTHER:
			return [ArenaUnit.ALLIANCE.PLAYER] if alliance == ArenaUnit.ALLIANCE.ENEMY else [ArenaUnit.ALLIANCE.ENEMY]
		TARGETS.ALL:
			return [ArenaUnit.ALLIANCE.ENEMY, ArenaUnit.ALLIANCE.PLAYER]
		_:
			assert(false)
			return []

extends Node

var data = {
	"Mind Dart": {
		"icon": load("res://Assets/PNG/bg.png"),
		"effect": AbilityEffectDetails.mind_dart,
		"targeting_type": ActivatedAbility.TARGETING_TYPE.UNIT_ENEMY,
		"cooldown_fn": func(level): return max(8, 12 - level),
		"range_fn": func(level): return 200,
		"area_of_effect_fn": func(level): return 0,
	}
}

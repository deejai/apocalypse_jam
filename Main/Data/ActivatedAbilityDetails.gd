extends Node

class_name ActivatedAbilityDetails

var data = {
	"Mind Dart": {
		"icon": load("res://Assets/PNG/bg.png"),
		"effect": ArenaUnitEffectDetails.mind_dart,
		"targeting_type": ActivatedAbility.TARGETING_TYPE.UNIT_ENEMY,
		"levels": {
			0: {
				"cooldown": 12,
				"range": 200,
				"area_of_effect": 0,
			},
			1: {
				"cooldown": 10,
				"range": 200,
				"area_of_effect": 0,
			},
			2: {
				"cooldown": 8,
				"range": 200,
				"area_of_effect": 0,
			}
		}
	}
}

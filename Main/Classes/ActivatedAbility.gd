extends Node

class_name ActivatedAbility

enum TARGETING_TYPE {SELF, POINT, UNIT, UNIT_ENEMY, UNIT_PLAYER}

var key: String
var icon: Sprite2D
var cooldown: int
var level: int
var targeting_type: TARGETING_TYPE
var area_of_effect: int
var effect: AbilityEffect
var range: int

func _init(
	key: String,
	level: int
):
	self.key = key
	set_level(level)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _set_details():
	var data = ActivatedAbilityDetails[key]
	icon = data["icon"]
	effect = data["effect"]
	targeting_type = data["targeting_type"]
	cooldown = data["cooldown_fn"].call(level)
	range = data["range_fn"].call(level)
	area_of_effect = data["area_of_effect_fn"].call(level)

func set_level(level: int):
	assert(level >= 0)
	self.level = level
	_set_details()

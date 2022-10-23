extends Node

class_name ActivatedAbility

enum TARGETING_TYPE {SELF, POINT, UNIT, UNIT_ENEMY, UNIT_ALLY}

var cooldown: int
var level: int
var targeting_type: TARGETING_TYPE
var area_of_effect: int
var effect: ArenaUnitEffect

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

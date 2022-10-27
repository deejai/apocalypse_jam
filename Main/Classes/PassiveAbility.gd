extends Node

class_name PassiveAbility

var level
var key

func _init(key: String, level: int = 0):
	self.key = key
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

static func get_ability_data():
	return {
		"Nothing": {}
	}

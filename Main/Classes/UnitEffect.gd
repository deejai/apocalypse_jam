extends Node

class_name UnitEffect

var identifier: String
var level: int
var duration: int
var effect_start
var effect_tick
var effect_end

func _init(identifier:String, level: int, effect_start, effect_tick=null, _end=null, duration=0):
	assert(duration == 0 or duration > 0 and (effect_tick or effect_end))
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

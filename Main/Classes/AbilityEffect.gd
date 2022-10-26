extends Node

class_name AbilityEffect

var identifier: String
var level: int
var duration: float = 0.0
var effect_fn: Callable
var time_elapsed: float = 0
var ticks_applied: int = 0
var tick_interval: float = .5 # every .5 seconds by default
var props: Dictionary = {}
var killme = false

enum FLAG { START, TICK, END }

func _init(
	props: Dictionary,
	identifier:String,
	level: int,
	effect_fn: Callable,
	duration: float = 0.0
	):
	for prop_key in props:
		self.props[prop_key] = props[prop_key]

	self.identifier = identifier
	self.level = level
	self.effect_fn = effect_fn
	self.duration = duration

# Called when the node enters the scene tree for the first time.
func _ready():
	effect_fn.call(self, FLAG.START)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	assert(killme == false) # making sure i understand how queue_free works

	time_elapsed += delta

	if(delta == 0):
		print("zero")

	# catch up on ticks if we missed any
	var ticks_to_apply = num_ticks_to_apply()
	print(ticks_to_apply)
	for i in range(ticks_to_apply):
		print("tick")
		effect_fn.call(self, FLAG.TICK)

	if(time_elapsed >= duration):
		effect_fn.call(self, FLAG.END)

		killme = true
		queue_free()

func num_ticks_to_apply():
	return max(0, floor(time_elapsed / tick_interval) - ticks_applied)


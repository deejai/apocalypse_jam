extends Node

class_name ArenaUnitEffect

var identifier: String
var level: int
var duration: int = 0
var effect_fn: Callable
var time_elapsed: int = 0
var ticks_applied: int = 0
var tick_interval: int = 500 # every .5 seconds by default
var props: Dictionary = {}
var killme = false

enum FLAG { START, TICK, END }

func _init(
	arena_unit: ArenaUnit,
	identifier:String,
	level: int,
	effect_fn: Callable,
	):
	self.arena_unit = arena_unit
	self.identifier = identifier
	self.identifier = identifier
	self.effect_fn = effect_fn

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
	for i in range(num_ticks_to_apply()):
		effect_fn.call(self, FLAG.TICK)

	if(time_elapsed >= duration):
		effect_fn.call(self, FLAG.END)

		killme = true
		queue_free()

func num_ticks_to_apply():
	return max(0, time_elapsed / tick_interval - ticks_applied)


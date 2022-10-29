extends Node

class_name AbilityUpgrade

var amount: int

func _init(level: int):
	self.amount = randi_range(1, level+1)
	var roll = randf()
	if roll > .8:
		amount += 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

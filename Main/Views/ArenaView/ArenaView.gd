extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	# place our units
	var u = Unit.new()
	print(u)
	add_child(u)
	# generate enemy units based on progress and current map node
	# place enemy units
	# battle starts

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# is the battle over?
	# handle inputs. buttons, selecting chars, menu, etc
	pass

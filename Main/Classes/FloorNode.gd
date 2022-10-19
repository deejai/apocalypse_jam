extends Node

class_name FloorNode

var next: Array
var prev: Array
var battle: Battle

func _init():
	next = []
	prev = []
	print("Created FloorNode")
	
	# if it has visuals, use a scene with a script attached to its root node
	unit = load("res://Main/Classes/Unit/Unit.tscn").instantiate()
	Unit.new()
	
	# if its purely data, use a class
	floor = Floor.new()
	
	pass

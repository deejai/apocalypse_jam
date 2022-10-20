extends Node

class_name Unit

var status: String = "healthy"

func _init():
	pass
	
func arena_load(x, y):
	var scene = load("res://Views/ArenaView/ArenaViewUnit.tscn")
	# set the scene data
	# modify children

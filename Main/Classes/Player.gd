extends Node

class_name Player

var gold: int = 0
var floor: Floor = null

var squad_active: Array = [
	{"unit": Unit.new(Unit.TYPE.NORMAL), "start_position": Vector2(400, 720-70)},
	{"unit": Unit.new(Unit.TYPE.NORMAL), "start_position": Vector2(700, 720-70)},
	{"unit": Unit.new(Unit.TYPE.NORMAL), "start_position": Vector2(250, 720-70)},
	{"unit": Unit.new(Unit.TYPE.NORMAL), "start_position": Vector2(350, 720-70)},
]

var squad_inactive: Array = []

func _init():
	floor = Floor.new(0)

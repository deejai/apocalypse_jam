extends Node

class_name Player

var inventory: Array = []
var floor: Floor = null

var squad: Array = [
	{"unit": Unit.new(Unit.BASE.OLYMPIAN_APOLLO), "start_position": Vector2(100, 720-100)},
	{"unit": Unit.new(Unit.BASE.OLYMPIAN_ARES), "start_position": Vector2(200, 720-100)},
	{"unit": Unit.new(Unit.BASE.OLYMPIAN_ATHENA), "start_position": Vector2(300, 720-100)},
	{"unit": Unit.new(Unit.BASE.OLYMPIAN_HADES), "start_position": Vector2(400, 720-100)},
	{"unit": Unit.new(Unit.BASE.OLYMPIAN_HERMES), "start_position": Vector2(500, 720-100)},
	{"unit": Unit.new(Unit.BASE.OLYMPIAN_ZEUS), "start_position": Vector2(600, 720-100)},
	{"unit": Unit.new(Unit.BASE.SOLDIER_SWORD), "start_position": Vector2(250, 720-70)},
	{"unit": Unit.new(Unit.BASE.SOLDIER_SPEAR), "start_position": Vector2(350, 720-70)},
	{"unit": Unit.new(Unit.BASE.SOLDIER_ARCHER), "start_position": Vector2(450, 720-70)},
	{"unit": Unit.new(Unit.BASE.HEALER), "start_position": Vector2(550, 720-40)},
]

func _init():
	floor = Floor.new(0)

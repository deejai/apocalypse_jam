extends Node

class_name Player

var gold: int = 0
var floor: Floor = null
var squad_active: Array = []
var squad_inactive: Array = []

func _init():
	floor = Floor.new(0)

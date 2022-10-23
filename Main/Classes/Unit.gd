extends Node

class_name Unit

enum TYPE { NORMAL, HERO, SUMMON }

var status: String = "healthy"
var speed: float
var hp: int
var size: String
var type: TYPE

# @TODO: add more stats, add animations

func _init(type: TYPE):
	self.speed = 1.3
	self.hp = 100
	self.size = "Medium"
	self.type = type

extends Node

class_name Unit

var status: String = "healthy"
var speed: int
var hp: int
var size: String

# @TODO: add more stats, add animations

func _init():
	self.speed = 5
	self.hp = 100
	self.size = "Medium"

extends Node

class_name Unit

var status: String = "healthy"
var speed: int
var hp: int
var size: String
var is_enemy: bool

# @TODO: add more stats, add animations

func _init(is_enemy: bool):
	self.speed = 5
	self.hp = 100
	self.size = "Medium"
	self.is_enemy = is_enemy

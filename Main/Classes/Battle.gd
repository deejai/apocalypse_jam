extends Node

class_name Battle

var enemies: Array = []

func _init(level: int):
	var positions = [Vector2(500, 100), Vector2(700, 150), Vector2(600, 200)]
	for i in range(len(positions)):
		enemies.append({"unit": Unit.new(Unit.TYPE.NORMAL), "start_position": positions[i]})

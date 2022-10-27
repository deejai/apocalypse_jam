extends Node

class_name FloorNode

var next: Array = []
var prev: Array = []
var battle = null
var level: int
var sceneNode: Node2D
var completed: bool = false
var boss_node: bool = false

var reward_type # Shared.NODE_TYPE

func _init(level: int, prev=null, next=null, boss: bool = false):
	self.level = level

	if(prev != null):
		self.prev = prev
	if(next != null):
		self.next = next

	self.reward_type = randi() % 3

static func link(prev_node, next_node):
	if prev_node not in next_node.prev:
		next_node.prev.append(prev_node)

	if next_node not in prev_node.next:
		prev_node.next.append(next_node)

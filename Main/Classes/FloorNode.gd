extends Node

class_name FloorNode

var next: Array = []
var prev: Array = []
var battle: Battle = null
var level: int
var sceneNode: Node2D

func _init(level: int, prev=null, next=null):
	self.level = level

	if(prev != null):
		self.prev = prev
	if(next != null):
		self.next = next

	self.battle = Battle.new(0)


static func link(prev_node, next_node):
	if prev_node not in next_node.prev:
		next_node.prev.append(prev_node)
		
	if next_node not in prev_node.next:
		prev_node.next.append(next_node)

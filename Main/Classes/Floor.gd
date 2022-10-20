extends Node

class_name Floor

var start: FloorNode
var current: FloorNode
var end: FloorNode

func _init(level: int):
	start = FloorNode.new(0)
	current = start

	var node_1_1 = FloorNode.new(0)
	var node_1_2 = FloorNode.new(0)
	var node_1_3 = FloorNode.new(0)

	var node_2_1 = FloorNode.new(0)
	var node_2_2 = FloorNode.new(0)
	var node_2_3 = FloorNode.new(0)
	var node_2_4 = FloorNode.new(0)

	var node_3_1 = FloorNode.new(0)
	var node_3_2 = FloorNode.new(0)

	end = FloorNode.new(0)

	# First layer
	FloorNode.link(start, node_1_1)
	FloorNode.link(start, node_1_2)
	FloorNode.link(start, node_1_3)

	# Second Layer
	FloorNode.link(node_1_1, node_2_1)
	FloorNode.link(node_1_1, node_2_2)
	FloorNode.link(node_1_2, node_2_2)
	FloorNode.link(node_1_2, node_2_3)
	FloorNode.link(node_1_3, node_2_3)
	FloorNode.link(node_1_3, node_2_4)

	# Third Layer
	FloorNode.link(node_2_1, node_3_1)
	FloorNode.link(node_2_2, node_3_1)
	FloorNode.link(node_2_3, node_3_2)
	FloorNode.link(node_2_4, node_3_2)

	# Boss Layer
	FloorNode.link(node_3_1, end)
	FloorNode.link(node_3_2, end)


func get_depth():
	return _get_depth_rec(start)

func _get_depth_rec(node: FloorNode):
	var max_depth = 0
	for c in node.next:
		var depth = _get_depth_rec(c)
		if(depth > max_depth):
			max_depth = depth

	return max_depth + 1

extends Node

class_name Floor

var start: FloorNode
var current: FloorNode
var end: FloorNode

func _init(level: int):
	start = FloorNode.new(0)
	current = start

	var node_layers = [1,2,5,7,9]
	var prev_nodes = [start]
	for i in range(1, len(node_layers)):
		var new_nodes = []
		for j in range(node_layers[i]):
			var new_node = FloorNode.new(0)
			new_nodes.append(new_node)
			# connect the appropriate previous nodes to the current node
			new_node.prev = []
			var prev_nodes_per_node = 1.0 * node_layers[i-1]/node_layers[i]
			print("per node: ", prev_nodes_per_node)
			var relative_index = j * node_layers[i-1] / node_layers[i]
			print("j, relative index: ", j, ", ", relative_index)
			var span = range(ceili(relative_index-prev_nodes_per_node/2), floori(relative_index+prev_nodes_per_node/2) + 1)
			var prev_k = node_layers[i]
			for k in span:
				if(k == prev_k):
					continue
				if k <= 0:
					k = 0
				if k >= len(prev_nodes):
					k = len(prev_nodes) - 1
				print("Connect ", i-1, "[", k, "] to ", i, "[", j, "]")
				FloorNode.link(prev_nodes[k], new_node)
				prev_k = k
	
		prev_nodes = new_nodes

func get_depth():
	return _get_depth_rec(start)

func _get_depth_rec(node: FloorNode):
	var max_depth = 0
	for c in node.next:
		var depth = _get_depth_rec(c)
		if(depth > max_depth):
			max_depth = depth

	return max_depth + 1

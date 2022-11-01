extends Node2D

class_name Floor

var level: int

var start: FloorNode
var current: FloorNode
var end: FloorNode

func _init(level: int, remaining_titans):
	if level == -1:
		# manual mode. used for loading from save
		return

	self.level = level

	start = FloorNode.new(0)
	start.battle = Battle.new(level)
	current = start

	var node_layers = [1,3,randi_range(4,6),randi_range(5,7),randi_range(5,7),randi_range(3,5),randi_range(2,3)]
	var prev_nodes = [start]
	for i in range(1, len(node_layers)):
		var new_nodes = []
		for j in range(node_layers[i]):
			var new_node = FloorNode.new(0)
			new_node.battle = Battle.new(level)
			new_nodes.append(new_node)

		# connect the appropriate previous nodes to the current node
		var arcs = getArcs(node_layers[i-1], node_layers[i])

		for arc in arcs:
			FloorNode.link(prev_nodes[arc[0]], new_nodes[arc[1]])

		prev_nodes = new_nodes
		
	var boss_node = FloorNode.new(0)
	boss_node.boss_node = true
	if len(remaining_titans) > 0:
		boss_node.battle = Battle.get_boss_fight(level, remaining_titans)
	for pn in prev_nodes:
		FloorNode.link(pn, boss_node)

func getArcs(n, m):
	var arcs = []

	var a = []
	for i in range(n):
		a.append((i+0.5) / n)

	var b = []
	for i in range(m):
		b.append((i+0.5) / m)

	var th = 0.5 / min(n, m)
	for i in range(n):
		for j in range(m):
			if (abs(a[i] - b[j]) <= th + 0.05):
				arcs.append([i, j])

	return arcs

func get_depth():
	return _get_depth_rec(start)

func _get_depth_rec(node: FloorNode):
	var max_depth = 0
	for c in node.next:
		var depth = _get_depth_rec(c)
		if(depth > max_depth):
			max_depth = depth

	return max_depth + 1

static func floor_to_json(floor: Floor):
	pass

static func json_to_floor(floor: Floor):
	pass

extends Node2D

var main_menu = load("res://Main/Views/MainMenu/MainMenuView.tscn")
var nav_frame = load("res://Main/Views/Components/NavFrame/NavFrame.tscn")
var arena_view = load("res://Main/Views/ArenaView/ArenaView.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	Game.arena = null

	Game.save_game()

	add_child(nav_frame.instantiate())

	var start = Game.player.floor.start
	var hpad = 200
	var vpad = 100
	var bounds = {"left": hpad, "right": Game.width-hpad, "top": vpad, "bottom": Game.height-vpad-100}

	var depth = Game.player.floor.get_depth()
	var node_hierarchy = []
	for i in range(depth):
		node_hierarchy.append([])

	var visited = [{"n": Game.player.floor.start, "d": 0}]
	var queue = [{"n": Game.player.floor.start, "d": 0}]
	var curr_depth = 0

	while queue.is_empty() == false:
		var qn = queue.pop_front() # dequeue
#		print(qn.n.level)
		node_hierarchy[qn.d].append(qn.n)

		for neighbour in qn.n.next:
			var vv = []
			for v in visited:
				vv.append(v.n)
			if neighbour not in vv:
				visited.append({"n": neighbour, "d": qn.d+1})
				queue.append({"n": neighbour, "d": qn.d+1})

	var max_breadth = 0
	for d in node_hierarchy:
		if d.size() > max_breadth:
			max_breadth = d.size()

	var mapnode_res = load("res://Main/Views/MapView/MapViewNode.tscn")
	for r in range(len(node_hierarchy)):
		var layer = node_hierarchy[r]
		var y_pos = vpad if len(node_hierarchy) == 1 else vpad + bounds.bottom - (vpad + r * (bounds.bottom-bounds.top)/(len(node_hierarchy)-1))
		var x_span = (bounds.right - bounds.left) * 1.0 * (len(layer) + (max_breadth-len(layer))/2.0)/max_breadth
		var x_pad
		if len(layer) > 1:
			x_pad = (1.0 * ((bounds.right - bounds.left) - x_span)) / 2
		else:
			x_pad = (bounds.right - bounds.left) / 2
		var x_spacing = 0 if len(layer) == 1 else x_span / (len(layer)-1)
		for c in range(len(layer)):
			var floorNode = layer[c]
			var x_pos = bounds.left + x_pad + c * x_spacing
#			print(r, c)
			var mapnode = mapnode_res.instantiate().init(floorNode, x_pos, y_pos)
#			print(mapnode.position)
			add_child(mapnode)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Game.next_battle != null):
		print("Change scene")
		get_tree().change_scene_to_packed(arena_view)

func _draw():
	var node = Game.player.floor.start
	_draw_node_rec(node)

# could add code to skip redundant draws, but the performance difference is trivial
func _draw_node_rec(node: FloorNode):
	if(!node):
		return

	if(is_instance_valid(node.sceneNode)):
		# draw the connecting lines
		for next in node.next:
			if is_instance_valid(next.sceneNode):
				draw_line(Vector2i(node.sceneNode.position), next.sceneNode.position - self.position, Color(Color.CORAL, 0.6), 6)

		# draw the node circle
		var pos = node.sceneNode.position
		var radius = node.sceneNode.get_node("Area/Collision").shape.radius
		if node.completed:
			draw_circle(pos, radius, Color(Color.DARK_GREEN, 0.7))
		elif node == Game.player.floor.current:
			draw_circle(pos, radius, Color(Color.CHARTREUSE, 0.7))
		elif Game.player.floor.current.completed and Game.player.floor.current in node.prev:
			draw_circle(pos, radius, Color(Color.GOLD, 0.7))
		else:
			draw_circle(pos, radius, Color(Color.DARK_GRAY, 0.7))

	for next_node in node.next:
		_draw_node_rec(next_node)

extends Node



var main_menu = load("res://Main/Views/MainMenu/MainMenuView.tscn")
var nav_frame = load("res://Main/Views/NavFrame/NavFrame.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$ReturnToMainMenu.connect("pressed", func(): get_tree().change_scene_to_packed(main_menu))
	
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

	var bandaid_x = 150
	var bandaid_y = 110

	var mapnode_res = load("res://Main/Views/MapView/MapViewNode.tscn")
	for r in range(len(node_hierarchy)):
		var layer = node_hierarchy[r]
		var y_pos = vpad if len(node_hierarchy) == 1 else bounds.bottom - (vpad + r * (bounds.bottom-bounds.top)/(len(node_hierarchy)-1))
		var x_span = (bounds.right - bounds.left) * 1.0 * len(layer)/max_breadth
		var x_pad = (1.0 * ((bounds.right - bounds.left) - x_span)) / 2
		print("xs ", x_span)
		print("xp ", x_pad)
		var x_spacing = x_span / len(layer)
		for c in range(len(layer)):
			var floorNode = layer[c]
			var x_pos = bounds.left + x_pad + c * x_spacing
#			print(r, c)
			var mapnode = mapnode_res.instantiate().init(floorNode, x_pos + bandaid_x, y_pos + bandaid_y)
#			print(mapnode.position)
			add_child(mapnode)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



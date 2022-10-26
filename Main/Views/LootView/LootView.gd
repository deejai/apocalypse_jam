extends Node2D

var map_view = load("res://Main/Views/MapView/MapView.tscn")

var unit_upgrade = load("res://Main/Views/Components/UnitUpgradeItem.tscn")

var rewards = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in [1,2,3,4]:
		var frame = get_node("RewardFrame" + str(i))
		rewards[i] = unit_upgrade.instantiate().init(i-1)
		frame.add_child(rewards[i])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		for i in [1,2,3,4]:
			var frame = get_node("RewardFrame" + str(i))
			if Geometry2D.is_point_in_polygon(event.position - frame.position, frame.get_polygon()):
				Game.player.inventory.append(rewards[i].upgrade)
				queue_free()
				get_tree().change_scene_to_packed(map_view)

	elif event is InputEventMouseMotion:
		for i in [1,2,3,4]:
			var frame = get_node("RewardFrame" + str(i))
			if Geometry2D.is_point_in_polygon(event.position - frame.position, frame.get_polygon()):
				pass # could show tooltip here

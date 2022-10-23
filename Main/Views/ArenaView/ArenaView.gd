extends Node2D

var unit_bounds = {"left": 0, "right": 1280-200, "top": 0, "bottom": 720}
var basic_unit = load("res://Main/Views/ArenaView/ArenaUnit.tscn")
var enemy_arena_units = []
var player_arena_units = []

var selected_units = []

var mouse_left_pressed = false
var mouse_left_pressed_start_pos = Vector2.ZERO
var button_pressed_start_drag_dist = 30

# Called when the node enters the scene tree for the first time.
func _ready():
	# place our units
	load_units(Game.next_battle.enemies, enemy_arena_units, ArenaUnit.ALLIANCE.ENEMY)
	load_units(Game.player.squad_active, player_arena_units, ArenaUnit.ALLIANCE.ALLY)
	# generate enemy units based on progress and current map node
	# place enemy units
	# battle starts

	queue_redraw()

func load_units(arr_from: Array, arr_to: Array, alliance: ArenaUnit.ALLIANCE):
	for data in arr_from:
		var arena_unit = basic_unit.instantiate().init(data.unit, alliance)
		if "start_position" not in data.keys():
			print(data)
			break
		arena_unit.position = data.start_position
		arr_to.append(arena_unit)
		add_child(arena_unit)

func drag_select_rect():
	# i had to do all this because Rect2.has_point only works when the rectangle goes from topleft to botright
	var x_from_to = [get_global_mouse_position().x, mouse_left_pressed_start_pos.x]
	var y_from_to = [get_global_mouse_position().y, mouse_left_pressed_start_pos.y]
	x_from_to.sort()
	y_from_to.sort()
	var top_left = Vector2(x_from_to[0], y_from_to[0])
	var bottom_right = Vector2(x_from_to[1], y_from_to[1])
	return Rect2(top_left, bottom_right-top_left)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	queue_redraw()
	pass

func _draw():
	if mouse_left_pressed and mouse_left_pressed_start_pos.distance_to(get_global_mouse_position()) > button_pressed_start_drag_dist:
		draw_rect(
			drag_select_rect(),
			Color.NAVAJO_WHITE,
			false
		)

func _input(event: InputEvent):
	if event is InputEventMouseButton and not event.pressed:
		if event.button_index == MOUSE_BUTTON_MASK_LEFT and mouse_left_pressed:
			if event.position.distance_to(mouse_left_pressed_start_pos) < button_pressed_start_drag_dist:
				var clicked_unit = null
				for arr in [enemy_arena_units, player_arena_units]:
					if(clicked_unit):
						break

					for arena_unit in arr:
						var radius = arena_unit.get_node("Collision").shape.radius
						if arena_unit.position.distance_to(event.position) < radius:
							clicked_unit = arena_unit
							break

				for arena_unit in selected_units:
					arena_unit.selected = false

				selected_units = [clicked_unit] if clicked_unit else []
				for arena_unit in selected_units:
					arena_unit.selected = true
			else:
				for arena_unit in selected_units:
					arena_unit.selected = false

				selected_units = []
				for arena_unit in player_arena_units:
					if(drag_select_rect().has_point(arena_unit.position)):
						arena_unit.selected = true
						selected_units.append(arena_unit)

			mouse_left_pressed = false

	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_MASK_LEFT:
			mouse_left_pressed = true
			mouse_left_pressed_start_pos = event.position

		if event.button_index == MOUSE_BUTTON_MASK_RIGHT:
			if len(selected_units) > 0 and selected_units[0].alliance == ArenaUnit.ALLIANCE.ALLY:
				for arena_unit in selected_units:
					arena_unit.move_target = event.position

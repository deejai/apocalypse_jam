extends Node2D

var unit_bounds = {"left": 0, "right": 1280-200, "top": 0, "bottom": 720}
var basic_unit = load("res://Main/Views/ArenaView/ArenaViewUnit.tscn")
var enemy_arena_units = []
var player_arena_units = []

var selected_units = []

var mouse_left_pressed = false
var mouse_left_pressed_start_pos = Vector2.ZERO
var button_pressed_start_drag_dist = 30

# Called when the node enters the scene tree for the first time.
func _ready():
	# place our units
	load_units(Game.next_battle.enemies, enemy_arena_units)
	load_units(Game.player.squad_active, player_arena_units)
	# generate enemy units based on progress and current map node
	# place enemy units
	# battle starts

	queue_redraw()

func load_units(arr_from: Array, arr_to: Array):
	for data in arr_from:
		var arena_unit = basic_unit.instantiate().init(data.unit)
		if "start_position" not in data.keys():
			print(data)
			break
		arena_unit.position = data.start_position
		arr_to.append(arena_unit)

func drag_select_rect():
	return Rect2(mouse_left_pressed_start_pos, get_global_mouse_position()-mouse_left_pressed_start_pos)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for arena_unit in player_arena_units:
		if(arena_unit.move_target):
			arena_unit.move_to_target(delta, arena_unit.move_target)

	queue_redraw()
	pass

func _draw():
	for arena_unit in selected_units:
		draw_circle(arena_unit.position, 25, Color.WHITE)

	for arena_unit in enemy_arena_units:
		draw_circle(arena_unit.position, 20, Color.MAROON)

	for arena_unit in player_arena_units:
		draw_circle(arena_unit.position, 20, Color.GREEN_YELLOW)


#	draw_circle(mouse_left_pressed_start_pos, 10, Color.ROSY_BROWN)
#	draw_circle(mouse_pos, 10, Color.CORNFLOWER_BLUE)

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
			if len(selected_units) > 0 and selected_units[0].unit.is_enemy == false:
				for arena_unit in selected_units:
					arena_unit.move_target = event.position

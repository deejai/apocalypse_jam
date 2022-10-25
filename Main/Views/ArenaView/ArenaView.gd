extends Node2D

var unit_bounds = {"left": 0, "right": 1280-200, "top": 0, "bottom": 720}

var models = {
	Unit.BASE.OLYMPIAN_APOLLO: load("res://Main/Views/ArenaView/ArenaUnits/Olympian_Apollo.tscn"),
	Unit.BASE.SOLDIER_SWORD: load("res://Main/Views/ArenaView/ArenaUnits/Soldier_Sword.tscn"),
	Unit.BASE.SOLDIER_SPEAR: load("res://Main/Views/ArenaView/ArenaUnits/Soldier_Spear.tscn"),
	Unit.BASE.SOLDIER_ARCHER: load("res://Main/Views/ArenaView/ArenaUnits/Soldier_Archer.tscn"),
	Unit.BASE.HEALER: load("res://Main/Views/ArenaView/ArenaUnits/Healer.tscn"),
}

var tombstone = load("res://Main/Views/ArenaView/ArenaUnits/Tombstone.tscn")

var map_view = load("res://Main/Views/MapView/MapView.tscn")
var main_menu = load("res://Main/Views/MainMenu/MainMenuView.tscn")
var loot_view = load("res://Main/Views/LootView/LootView.tscn")

var selected_unit_tile = load("res://Assets/selectedunittile_unknown.png")

var enemy_arena_units = []
var player_arena_units = []

var selected_units = []

var mouse_left_pressed = false
var mouse_left_pressed_start_pos = Vector2.ZERO
var button_pressed_start_drag_dist = 30

func setMenuEnabled(enable: bool):
	$Menu.visible = enable
	$Menu/ResumeButton.disabled = not enable
	$Menu/MainMenuButton.disabled = not enable

# Called when the node enters the scene tree for the first time.
func _ready():
	# place our units
	load_units(Game.next_battle.enemies, enemy_arena_units, ArenaUnit.ALLIANCE.ENEMY)
	load_units(Game.player.squad_active, player_arena_units, ArenaUnit.ALLIANCE.ALLY)
	Game.next_battle = null
	# generate enemy units based on progress and current map node
	# place enemy units
	# battle starts
	
	$SidePanel/MenuButton.connect("pressed", func(): setMenuEnabled(true))
	$Menu/ResumeButton.connect("pressed", func(): setMenuEnabled(false))
	$Menu/MainMenuButton.connect("pressed", func():
		get_tree().change_scene_to_packed(main_menu)
	)

	queue_redraw()

func load_units(arr_from: Array, arr_to: Array, alliance: ArenaUnit.ALLIANCE):
	for data in arr_from:
		var arena_unit = models[data.unit.base].instantiate().init(data.unit, alliance)

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
	for arr in [selected_units, player_arena_units, enemy_arena_units]:
		var indices_to_pop = []
		for i in len(arr):
			var arena_unit = arr[i]
			if not is_instance_valid(arena_unit):
				indices_to_pop.append(i)
			elif arena_unit.dying:
				add_child(tombstone.instantiate().init(arena_unit.position))
				arena_unit.queue_free()
				indices_to_pop.append(i)

		indices_to_pop.reverse()
		for i in indices_to_pop:
			arr.pop_at(i)
			
	if(len(enemy_arena_units) == 0):
		Game.player.floor.current.completed = true
		queue_free()
		get_tree().change_scene_to_packed(loot_view)

	$SidePanel/SelectedUnits.clear()
	for i in range(len(selected_units)):
		var arena_unit = selected_units[i]
		var icon = arena_unit.get_node("AnimatedSprite2D").get_sprite_frames().get_frame("Idle", 0)
		$SidePanel/SelectedUnits.add_icon_item(icon, true)
		$SidePanel/SelectedUnits.set_item_selectable(i, true)

	ai_decide_targets()
	player_auto_attack()

	queue_redraw()
	pass

func _draw():
	if mouse_left_pressed and mouse_left_pressed_start_pos.distance_to(get_global_mouse_position()) > button_pressed_start_drag_dist:
		draw_rect(
			drag_select_rect(),
			Color.NAVAJO_WHITE,
			false
		)

	for arena_unit in selected_units:
		if(is_instance_valid(arena_unit.attack_target)):
			draw_arc(arena_unit.attack_target.position, 20, 0, TAU, 50, Color.RED, 2.0, true)

func _input(event: InputEvent):
	if event is InputEventMouseButton and event.position.x < 1080:
	# clicked on battlefield
		if not event.pressed:
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
				
				if len(selected_units) > 0:
					Audio.soldier_voice_yessir.play()

		if event.pressed:
			if event.button_index == MOUSE_BUTTON_MASK_LEFT:
				mouse_left_pressed = true
				mouse_left_pressed_start_pos = event.position

			if event.button_index == MOUSE_BUTTON_MASK_RIGHT:
				if len(selected_units) > 0 and selected_units[0].alliance == ArenaUnit.ALLIANCE.ALLY:
					var attack_target = null

					for arena_unit in enemy_arena_units:
						var radius = arena_unit.get_node("Collision").shape.radius
						if arena_unit.position.distance_to(event.position) < radius:
							attack_target = arena_unit
							break

					for arena_unit in selected_units:
						arena_unit.attack_target = attack_target
						arena_unit.move_target = event.position

					if len(selected_units) > 0:
						Audio.soldier_voice_ok.play()
	else:
		pass

func ai_decide_targets():
	# prioritize weak and nearby enemies
	for arena_unit in enemy_arena_units:
		if(not is_instance_valid(arena_unit)):
			continue
		var closest_ally = null
		var closest_ally_dist = 9999999
		for ally in player_arena_units:
			if(not is_instance_valid(ally)):
				continue
			var dist = ally.position.distance_to(arena_unit.position)
			if dist < closest_ally_dist:
				closest_ally = ally
				closest_ally_dist = dist

		if closest_ally:
			arena_unit.attack_target = closest_ally
			arena_unit.move_target = closest_ally.position

func player_auto_attack():
	for arena_unit in player_arena_units:
		if(not is_instance_valid(arena_unit)):
			continue
			
		if(arena_unit.attack_target):
			continue

		var closest_enemy = null
		var closest_enemy_dist = 9999999
		for enemy in enemy_arena_units:
			if(not is_instance_valid(enemy)):
				continue
			var dist = enemy.position.distance_to(arena_unit.position)
			if dist < arena_unit.unit.range and dist < closest_enemy_dist:
				closest_enemy = enemy
				closest_enemy_dist = dist

		if closest_enemy:
			arena_unit.auto_attack(closest_enemy)

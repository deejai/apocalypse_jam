extends Node2D

var unit_bounds = {"left": 0, "right": 1280-200, "top": 0, "bottom": 720}

var particles_fire = load("res://Main/Particles/Fire.tscn")
var particles_lightning = load("res://Main/Particles/Lightning.tscn")
var particles_stun = load("res://Main/Particles/Stun.tscn")
var particles_poison = load("res://Main/Particles/Poison.tscn")
var particles_smokecloud = load("res://Main/Particles/SmokeCloud.tscn")
var particles_bloodspurt = load("res://Main/Particles/Blood.tscn")
var particles_heal = load("res://Main/Particles/Heal.tscn")
var particles_groundelectric = load("res://Main/Particles/GroundElectric.tscn")
var particles_groundfire = load("res://Main/Particles/GroundFire.tscn")

var particles_unimplemented = load("res://Main/Particles/Unimplemented.tscn")

var tombstone = load("res://Main/Views/ArenaView/ArenaUnits/Tombstone.tscn")

var map_view = load("res://Main/Views/MapView/MapView.tscn")
var main_menu = load("res://Main/Views/MainMenu/MainMenuView.tscn")
var loot_view = load("res://Main/Views/LootView/LootView.tscn")

var selected_unit_tile = load("res://Assets/selectedunittile_unknown.png")

var enemy_arena_units = []
var player_arena_units = []

var active_effects = []

var selected_units = []
var mouse_left_pressed = false
var mouse_left_pressed_start_pos = Vector2.ZERO
var button_pressed_start_drag_dist = 30

var in_targeting_mode = false
var highlighted_unit = null
var targeting_ability = null

func setMenuEnabled(enable: bool):
	$Menu.visible = enable
	$Menu/ResumeButton.disabled = not enable
	$Menu/MainMenuButton.disabled = not enable

# Called when the node enters the scene tree for the first time.
func _ready():
	Game.arena = self
	
	#add_child(Audio.battleMusic)
	#Audio.battleMusic.play()

	# place our units
	print(particles_stun)
	load_units(Game.next_battle.enemies, enemy_arena_units, ArenaUnit.ALLIANCE.ENEMY)
	load_units(Game.player.squad, player_arena_units, ArenaUnit.ALLIANCE.PLAYER)
	Game.next_battle = null
	# generate enemy units based on progress and current map node
	# place enemy units
	# battle starts
	
	$SidePanel/MenuButton.connect("pressed", func(): setMenuEnabled(true))
	$Menu/ResumeButton.connect("pressed", func(): setMenuEnabled(false))
	$Menu/MainMenuButton.connect("pressed", func():
		queue_free()
		get_tree().change_scene_to_packed(main_menu)
	)

	queue_redraw()

func load_units(arr_from: Array, arr_to: Array, alliance: ArenaUnit.ALLIANCE):
	for data in arr_from:
		var arena_unit = Shared.get_models()[data.unit.base].instantiate().init(data.unit, alliance)

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
		# save the game here?
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
			
	if(in_targeting_mode):
		if is_instance_valid(highlighted_unit):
			draw_circle(get_global_mouse_position(), max(15, targeting_ability.area_of_effect), Color(Color.DARK_RED, 0.3))
			draw_arc(highlighted_unit.position, targeting_ability.range, 0, TAU, 50, Color.RED, 1.0, true)
		else:
			in_targeting_mode = false

func _input(event: InputEvent):
	if event is InputEventKey and event.pressed and event.keycode == KEY_Q:
		engage_ability(0)

	if event is InputEventKey and event.pressed and event.keycode == KEY_W:
		engage_ability(1)

	if event is InputEventKey and event.pressed and event.keycode == KEY_E:
		engage_ability(2)

	if event is InputEventMouseButton and event.position.x < 1080:
	# clicked on battlefield
		if in_targeting_mode and event.pressed and event.button_index == MOUSE_BUTTON_MASK_LEFT and highlighted_unit.position.distance_to(event.position) <= targeting_ability.range:
		# try to cast ability
			if is_instance_valid(highlighted_unit):
				if targeting_ability.targeting_type == ActivatedAbility.TARGETING_TYPE.SINGLE_UNIT:
					var units = get_units_in_aoe(
						get_global_mouse_position(),
						20,
						ActivatedAbility.affected_alliances(highlighted_unit.alliance, targeting_ability.targets)
					)
					
					if len(units) == 0:
						print("No unit targeted")
					else:
						cast_on_units([units[0]])

				elif targeting_ability.targeting_type == ActivatedAbility.TARGETING_TYPE.UNITS_IN_AOE:
					var units = get_units_in_aoe(
						get_global_mouse_position(),
						targeting_ability.area_of_effect,
						ActivatedAbility.affected_alliances(highlighted_unit.alliance, targeting_ability.targets)
					)
					cast_on_units(units)
					
				elif targeting_ability.targeting_type == ActivatedAbility.TARGETING_TYPE.POINT:
					var effect = AbilityEffect.new(
						{"target_point": highlighted_unit},
						targeting_ability.key,
						targeting_ability.level,
						targeting_ability.effect_fn,
						targeting_ability.duration
					)
					active_effects.append(effect)
					Game.arena.add_child(effect)
				else:
					assert(false)

				highlighted_unit.ability_cooldowns[targeting_ability] = targeting_ability.cooldown
				in_targeting_mode = false

			else:
				in_targeting_mode = false
		else:
			in_targeting_mode = false
		# select units, issue orders, etc
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
					
					if len(selected_units) > 0 and selected_units[0].alliance == ArenaUnit.ALLIANCE.PLAYER:
						highlighted_unit = selected_units[0]
						Audio.data[highlighted_unit.unit.voice].Greeting[randi()%len(Audio.data[highlighted_unit.unit.voice].Greeting)].play()
						
					else:
						highlighted_unit = null

			if event.pressed:
				if event.button_index == MOUSE_BUTTON_MASK_LEFT:
					mouse_left_pressed = true
					mouse_left_pressed_start_pos = event.position

				if event.button_index == MOUSE_BUTTON_MASK_RIGHT:
					if len(selected_units) > 0 and selected_units[0].alliance == ArenaUnit.ALLIANCE.PLAYER:
						var attack_target = null

						for arena_unit in enemy_arena_units:
							var radius = arena_unit.get_node("Collision").shape.radius
							if arena_unit.position.distance_to(event.position) < radius:
								attack_target = arena_unit
								break

						for arena_unit in selected_units:
							arena_unit.attack_target = attack_target
							arena_unit.move_target = event.position
							Audio.data[arena_unit.unit.voice].Response[randi()%len(Audio.data[arena_unit.unit.voice].Response)].play()
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

func get_units_in_aoe(point: Vector2, aoe: int, alliances: Array[ArenaUnit.ALLIANCE]):
	var arrs = []
	for alliance in alliances:
		if alliance == ArenaUnit.ALLIANCE.PLAYER:
			arrs.append(player_arena_units)
		elif alliance == ArenaUnit.ALLIANCE.ENEMY:
			arrs.append(enemy_arena_units)

	var units_in_aoe = []
	for arr in arrs:
		for arena_unit in arr:
			if(not is_instance_valid(arena_unit)):
				continue
			if arena_unit.position.distance_to(point) <= aoe:
				units_in_aoe.append(arena_unit)

	return units_in_aoe

func engage_ability(ability_index: int):
	if not is_instance_valid(highlighted_unit) or highlighted_unit.alliance != ArenaUnit.ALLIANCE.PLAYER:
		return

	if highlighted_unit.statuses[ArenaUnit.STATUS.STUN]["duration"] > 0 or highlighted_unit.statuses[ArenaUnit.STATUS.SILENCE]["duration"] > 0:
		# TODO: Say "Silenced" or "Stunned" or something
		return
		
	if ability_index >= len(highlighted_unit.unit.activated_abilities):
		return

	targeting_ability = highlighted_unit.unit.activated_abilities[ability_index]

	if highlighted_unit.ability_cooldowns[targeting_ability] > 0:
		# TODO: play sound effect
		return

	if not targeting_ability is ActivatedAbility:
		# do nothing
		return

	var units_to_affect = []

	match targeting_ability.targeting_type:
		ActivatedAbility.TARGETING_TYPE.SELF:
			# cast immediately
			if targeting_ability.aoe > 0:
				units_to_affect = get_units_in_aoe(
					highlighted_unit.position,
					targeting_ability.aoe,
					AbilityEffect.affected_alliances(highlighted_unit.alliance, targeting_ability.affected_alliances)
				)
			else:
				units_to_affect = [highlighted_unit]
		_:
			# enter targeting mode
			in_targeting_mode = true

	cast_on_units(units_to_affect)

func cast_on_units(targets: Array):
	for unit in targets:
		var effect = AbilityEffect.new(
			{"source_unit": highlighted_unit, "target_unit": unit},
			targeting_ability.key,
			targeting_ability.level,
			targeting_ability.effect_fn,
			targeting_ability.duration
		)
		active_effects.append(effect)
		Game.arena.add_child(effect)

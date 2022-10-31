extends Node2D

class_name LootView

var map_view = load("res://Main/Views/MapView/MapView.tscn")

var rewards = {}
var rewards_taken: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var primary_type = Game.player.floor.current.reward_type
	var level = Game.player.floor.level

	var remaining_options = Shared.REWARD_TYPE.values()
	remaining_options.pop_at(primary_type)

	# choose from 3 primary and 1 wildcard
	match primary_type:
		Shared.REWARD_TYPE.UNIT_UPGRADE:
			var offset = randi() % 4
			for i in [1,2,3]:
				rewards[i] = UnitUpgrade.new(level, (i + offset) % 4)

			rewards[4] = [
				ActivatedAbility.new(ActivatedAbility.get_ability_data().keys()[randi() % len(ActivatedAbility.get_ability_data().keys())], 0),
				PassiveAbility.new(PassiveAbility.get_ability_data().keys()[randi() % len(PassiveAbility.get_ability_data().keys())]),
				AbilityUpgrade.new(level),
				Unit.new([Shared.BASE.HEALER, Shared.BASE.SOLDIER_SPEAR, Shared.BASE.SOLDIER_SWORD, Shared.BASE.SOLDIER_ARCHER][randi() % 4], level)
			][randi() % 4]

		Shared.REWARD_TYPE.NEW_UNIT:
			var offset = randi() % 4
			for i in [1,2,3]:
				rewards[i] = Unit.new([Shared.BASE.HEALER, Shared.BASE.SOLDIER_SPEAR, Shared.BASE.SOLDIER_SWORD, Shared.BASE.SOLDIER_ARCHER][(i + offset) % 4], level)

			rewards[4] = [
				ActivatedAbility.new(ActivatedAbility.get_ability_data().keys()[randi() % len(ActivatedAbility.get_ability_data().keys())], 0),
				PassiveAbility.new(PassiveAbility.get_ability_data().keys()[randi() % len(PassiveAbility.get_ability_data().keys())]),
				AbilityUpgrade.new(level),
				UnitUpgrade.new(level, randi() % 4)
			][randi() % 4]

		Shared.REWARD_TYPE.WILDCARD:
			var unit1_i = randi() % 4
			var unit_up1_i = randi() % 4
			var unit2_i = (unit1_i + randi() % 3) % 4
			var unit_up2_i = (unit_up1_i + randi() % 3) % 4

			var reward_choices = [
				ActivatedAbility.new(ActivatedAbility.get_ability_data().keys()[randi() % len(ActivatedAbility.get_ability_data().keys())], 0),
				PassiveAbility.new(PassiveAbility.get_ability_data().keys()[randi() % len(PassiveAbility.get_ability_data().keys())]),
				AbilityUpgrade.new(level),
				Unit.new([Shared.BASE.HEALER, Shared.BASE.SOLDIER_SPEAR, Shared.BASE.SOLDIER_SWORD, Shared.BASE.SOLDIER_ARCHER][unit1_i], level),
				Unit.new([Shared.BASE.HEALER, Shared.BASE.SOLDIER_SPEAR, Shared.BASE.SOLDIER_SWORD, Shared.BASE.SOLDIER_ARCHER][unit2_i], level),
				UnitUpgrade.new(level, unit_up1_i),
				UnitUpgrade.new(level, unit_up2_i),
			]
			
			while(len(reward_choices) > 4):
				reward_choices.pop_at(randi() % len(reward_choices))
				
			for i in [1,2,3,4]:
				rewards[i] = reward_choices[i-1]

		_:
			assert(false)

	print(rewards)

	for i in [1,2,3,4]:
		var frame = get_node("RewardFrame" + str(i))
		var scene = LootView.get_inventory_item_scene(rewards[i])
		scene.position = Vector2(100, 75)
		frame.add_child(scene)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		for i in [1,2,3,4]:
			var frame = get_node("RewardFrame" + str(i))
			if Geometry2D.is_point_in_polygon(event.position - frame.position, frame.get_polygon()):
				if rewards[i] is Unit:
					var valid_positions = []
					for col in range(10):
						for row in range(3):
							var new_position = Vector2(250 + 75*col, 720-(50 + 50*row))
							var valid = true
							for p_unit in Game.player.squad:
								if new_position.distance_to(p_unit["start_position"]) < 70:
									valid = false
									break
							if valid:
								valid_positions.append(new_position)

					Game.player.squad.append({"unit": rewards[i], "start_position": valid_positions[randi() % len(valid_positions)]})
				else:
					Game.player.inventory.append(rewards[i])
					
				rewards_taken += 1
				frame.position = Vector2(-500, -500)
				
				if rewards_taken == 2:
					queue_free()
					get_tree().change_scene_to_packed(map_view)

	elif event is InputEventMouseMotion:
		for i in [1,2,3,4]:
			var frame = get_node("RewardFrame" + str(i))
			if Geometry2D.is_point_in_polygon(event.position - frame.position, frame.get_polygon()):
				pass # could show tooltip here

static func get_inventory_item_scene(item):
	var scene = load("res://Main/Views/Components/ItemScene.tscn").instantiate()
	var label: String
	var sprite: Texture2D

	if item is Unit:
		scene.get_node("Sprite2D").scale = Vector2(2.5, 2.5)
		scene.get_node("Label").position += Vector2(0, 40)
		label = "Lv " + str(item.level + 1)
		sprite = Shared.get_models()[item.base].instantiate().get_node("AnimatedSprite2D").get_sprite_frames().get_frame("Idle_Down", 0)
	elif item is UnitUpgrade:
		scene.get_node("Sprite2D").scale = Vector2(4, 4)
		label = str(item.amount)
		match item.effect:
			UnitUpgrade.EFFECT.MORE_HP:
				sprite = load("res://Assets/upgrades_free_split_hp.png")
				label = "+" + str(item.amount) + " unit " + "hp"
			UnitUpgrade.EFFECT.MORE_DAMAGE:
				sprite = load("res://Assets/upgrades_free_split_damage.png")
				label = "+" + str(item.amount) + " unit " + "dmg"
			UnitUpgrade.EFFECT.MORE_SPEED:
				sprite = load("res://Assets/upgrades_free_split_speed.png")
				label = "+" + str(item.amount) + " unit " + "speed"
			UnitUpgrade.EFFECT.MORE_RANGE:
				sprite = load("res://Assets/upgrades_free_split_range.png")
				label = "+" + str(item.amount) + " unit " + "range"
			_:
				assert(false)
	elif item is ActivatedAbility:
		scene.get_node("Sprite2D").scale = Vector2(0.5, 0.5)
		label = item.key + " Lv " + str(item.level + 1)
		sprite = load("res://Assets/RPG_Fantasy_256/TomeBlue.png")
	elif  item is PassiveAbility:
		scene.get_node("Sprite2D").scale = Vector2(0.5, 0.5)
		label = item.key + " Lv " + str(item.level + 1)
		sprite = load("res://Assets/RPG_Fantasy_256/TomeGreen.png")
	elif item is AbilityUpgrade:
		label = str("Ability Lv +", item.amount)
		sprite = load("res://Assets/RPG_Fantasy_256/Scroll.png")
	else:
		print(item)
		assert(false)

	scene.get_node("Sprite2D").texture = sprite
	scene.get_node("Label").text = label

	return scene

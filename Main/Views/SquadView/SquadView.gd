extends Node2D

var map_view = load("res://Main/Views/MapView/MapView.tscn")
# Called when the node enters the scene tree for the first time.

var _use_item_button_function = func(): print("No use")
var use_item_button_function = func():
	Audio.effects.get_node("ui_equip").play()
	_use_item_button_function.call()

func _ready():
	$ReturnToMapButton.connect("pressed", func(): get_tree().change_scene_to_packed(map_view))

	$Items.set_fixed_icon_size(Vector2(64,64))
	$Units.set_fixed_icon_size(Vector2(64,64))
	$Abilities.set_fixed_icon_size(Vector2(32,32))
#	for i in len(Game.player.inventory):
#		var row = i/4
#		var col = i%4
#
#		var scene = LootView.get_inventory_item_scene(Game.player.inventory[i])
#
#		scene.position = Vector2(600 + col * 100, 200 + row * 100)
#
#		add_child(scene)

	for i in len(Game.player.inventory):
		var item = Game.player.inventory[i]
		var scene = LootView.get_inventory_item_scene(item)
		var texture = scene.get_node("Sprite2D").texture
		var label = scene.get_node("Label").text
		$Items.add_item(label, texture)
		$Items.set_item_metadata(i, {"data": item})

	for i in len(Game.player.squad):
		var data = Game.player.squad[i]
		var scene = Shared.get_models()[data.unit.base].instantiate()
		var texture = scene.get_node("AnimatedSprite2D").get_sprite_frames().get_frame("Idle_Down", 0)
		var label = str(Unit.BASE.keys()[data.unit.base], " lv ", str(data.unit.level + 1))
		$Units.add_item(label, texture)
		$Units.set_item_metadata(i, {"data": data.unit})

	$UseItemButton.connect("pressed", use_item_button_function)

func _process(delta):
	pass

func _on_units_item_selected(index):
	$Abilities.clear()

	var selection = $Units.get_selected_items()
	if(len(selection) > 0):
		var selected_index = selection[0]
		var unit = $Units.get_item_metadata(selected_index).data
		var data = unit.get_meta_data()
		$UnitData.text = data.stats

		if len(data.abilities) == 0:
			$Abilities.add_item("No abilities")
		else:
			for i in len(data.abilities):
				var ability = data.abilities[i]
				var scene = LootView.get_inventory_item_scene(ability)
				var texture = scene.get_node("Sprite2D").texture
				var label = scene.get_node("Label").text
				$Abilities.add_item(label, texture)
				$Abilities.set_item_metadata(i, {"data": ability})
				
	else:
		$UnitData.text = "No unit selected"

	update_use_item_button()

func _on_abilities_item_selected(index):
	print("update")
	$AbilityData.text = $Abilities.get_item_metadata(index).data.get_meta_data()

	update_use_item_button()

func _on_items_item_selected(index):
	update_use_item_button()

func update_use_item_button():
	$UseItemButton.text = "Use Item"
	$UseItemButton.disabled = true
	_use_item_button_function = func(): print("No use")

	var selected_item_arr = $Items.get_selected_items()
	var selected_item_index = -1 if len(selected_item_arr) == 0 else selected_item_arr[0]
	var selected_item = null if selected_item_index == -1 else $Items.get_item_metadata(selected_item_index).data

	var selected_unit_arr = $Units.get_selected_items()
	var selected_unit_index = -1 if len(selected_unit_arr) == 0 else selected_unit_arr[0]
	var selected_unit = null if selected_unit_index == -1 else $Units.get_item_metadata(selected_unit_index).data

	var selected_ability_arr = $Abilities.get_selected_items()
	var selected_ability_index = -1 if len(selected_ability_arr) == 0 else selected_ability_arr[0]
	var selected_ability = null if selected_ability_index == -1 else $Abilities.get_item_metadata(selected_ability_index).data

	if selected_item != null and selected_item is ActivatedAbility or selected_item is PassiveAbility:
		if selected_unit != null and len(selected_unit.activated_abilities) + len(selected_unit.passive_abilities) < 3:
			$UseItemButton.text = "Learn Ability"
			$UseItemButton.disabled = false
			_use_item_button_function = func():
				if selected_item is ActivatedAbility:
					selected_unit.activated_abilities.append(selected_item)
				elif selected_item is ActivatedAbility:
					selected_unit.passive_abilities.append(selected_item)

				Game.player.inventory.pop_at(Game.player.inventory.find(selected_item))
				$Items.remove_item(selected_item_index)

				_on_units_item_selected(selected_unit_index)

	elif selected_item != null and selected_item is UnitUpgrade:
		if selected_unit != null:
			$UseItemButton.text = "Upgrade Unit"
			$UseItemButton.disabled = false
			_use_item_button_function = func():
				selected_item.apply(selected_unit)

				Game.player.inventory.pop_at(Game.player.inventory.find(selected_item))
				$Items.remove_item(selected_item_index)

				_on_units_item_selected(selected_unit_index)

	elif selected_item != null and selected_item is AbilityUpgrade:
		if selected_ability != null:
			$UseItemButton.text = "Upgrade Ability"
			$UseItemButton.disabled = false
			_use_item_button_function = func():
				selected_ability.set_level(selected_ability.level + selected_item.amount)

				Game.player.inventory.pop_at(Game.player.inventory.find(selected_item))
				$Items.remove_item(selected_item_index)
				
				_on_abilities_item_selected(selected_ability_index)

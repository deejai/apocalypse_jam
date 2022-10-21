extends Node2D

var unit_bounds = {"left": 0, "right": 1280-200, "top": 0, "bottom": 720}
var basic_unit = load("res://Main/Views/ArenaView/ArenaViewUnit.tscn")
var enemy_arena_units = []
var player_arena_units = []

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# is the battle over?
	# handle inputs. buttons, selecting chars, menu, etc
	pass

func _draw():
	for arena_unit in enemy_arena_units:
		draw_circle(arena_unit.position, 20, Color.MAROON)
		arena_unit._draw()

	for arena_unit in player_arena_units:
		draw_circle(arena_unit.position, 20, Color.GREEN_YELLOW)
		arena_unit._draw()

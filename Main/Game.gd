extends Node

var width = 1280
var height = 720

var player = Player.new()

var next_battle = null

enum TARGETING_TYPE {SELF, POINT, UNIT, UNIT_ENEMY, UNIT_ALLY}

# Called when the node enters the scene tree for the first time.
func _ready():
#	print(OS.window_size())
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

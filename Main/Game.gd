extends Node

var width = 1280
var height = 720

var player = null

var next_battle = null

var arena = null

# Called when the node enters the scene tree for the first time.
func _ready():
#	print(OS.window_size())
	self.player = Player.new()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func save_game():
	var file = FileAccess.open("user://slot1.save", FileAccess.WRITE)
	var save_data = {
		"player": player,
		"next_battle": next_battle
	}
	file.store_line(JSON.stringify(save_data))

func load_game():
	var file = FileAccess.open("user://slot1.save", FileAccess.READ)
	if(file == null):
		return
	var save_data = JSON.parse_string(file.get_as_text())
	player = save_data["player"]
	next_battle = save_data["next_battle"]

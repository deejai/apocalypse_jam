extends Node

var map_view = load("res://Main/Views/MapView/MapView.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$NewGameButton.connect("pressed", func():
		print("New Game")
		self.get_tree().change_scene_to_packed(map_view)
	)

	$LoadGameButton.connect("pressed", func():
		print("Load Game")
		self.get_tree().change_scene_to_packed(map_view)
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

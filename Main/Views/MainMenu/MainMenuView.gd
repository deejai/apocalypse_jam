extends Node

var choose_char = load("res://Main/Views/ChooseACharacter/ChooseACharacter.tscn")
var map_view = load("res://Main/Views/MapView/MapView.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$NewGameButton.connect("pressed", func():
		print("New Game")
		Game.player = Player.new()
		Game.next_narration = Audio.narrations["NewGame"]
		self.get_tree().change_scene_to_packed(choose_char)
	)

	$LoadGameButton.connect("pressed", func():
		print("Load Game")
		Game.player = Player.new(false)
		SaveLoad.load_game(Game.player)
		Game.next_narration = Audio.narrations[str("Floor", Game.player.floor.level)]
		self.get_tree().change_scene_to_packed(map_view)
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

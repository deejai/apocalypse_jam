extends Node2D

var main_menu = load("res://Main/Views/MapView/MapView.tscn")
var squad_view = load("res://Main/Views/SquadView/SquadView.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Bar/ReturnToMainMenu.connect("pressed", func(): get_tree().change_scene_to_packed(main_menu))
	$Bar/Squad.connect("pressed", func(): get_tree().change_scene_to_packed(squad_view))
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

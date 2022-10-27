extends Node2D

var map_view = load("res://Main/Views/MapView/MapView.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	$ReturnToMapButton.connect("pressed", func(): get_tree().change_scene_to_packed(map_view))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

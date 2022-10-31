extends Node2D

var map_view = load("res://Main/Views/MapView/MapView.tscn")

var time_passed: float = 0.0
var clip_length: float

var pressed_once: bool = false

var audio_player

# Called when the node enters the scene tree for the first time.
func _ready():
	Game.pause_music = true
	audio_player = Game.next_narration.audio
	$Text.text = Game.next_narration.text
	print($Text.size)
	clip_length = audio_player.get_stream().get_length() * 1.0
	audio_player.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_passed += delta
	$Text.position.y = 720 - min(100.0 * time_passed, (720 + $Text.size.y) * (time_passed / clip_length))

	if $Text.position.y < -$Text.get_combined_minimum_size().y:
		proceed()

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if pressed_once:
			proceed()
		else:
			pressed_once = true
			$SkipNote.visible = true

func proceed():
	audio_player.stop()
	Game.pause_music = false
	get_tree().change_scene_to_packed(map_view)

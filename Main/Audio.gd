extends Node

enum VOICE {SOLDER, HEALER, ATHENA, ZEUS}

var solidier_voice = load("res://Main/Views/ArenaView/ArenaUnits/SoliderVoice.tscn")
var soldier_voice_yessir
var soldier_voice_ok
var soldier_voice_die
# Called when the node enters the scene tree for the first time.


func _ready():
	var v = solidier_voice.instantiate()
	soldier_voice_yessir = v.get_node("ResponseYessir")
	soldier_voice_ok = v.get_node("ResponseOk")
	soldier_voice_die = v.get_node("Die")
	add_child(v)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


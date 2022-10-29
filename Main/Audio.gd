extends Node

var battleMusic = load("res://Main/Views/Audio/battleMusic.tscn").instantiate()
var menuMusic = load("res://Main/Views/Audio/menuMusic.tscn").instantiate()
var effects = load("res://Main/Views/Audio/Effects.tscn").instantiate()

enum VOICE {SOLDIER, HEALER, HERMES, APOLLO, ZEUS, ARES, ATHENA, HADES}

var soldier_voice = load("res://Main/Views/ArenaView/ArenaUnits/UnitVoice/SoldierVoice.tscn").instantiate()
var healer_voice = load("res://Main/Views/ArenaView/ArenaUnits/UnitVoice/HealerVoice.tscn").instantiate()
var apollo_voice = load("res://Main/Views/ArenaView/ArenaUnits/UnitVoice/ApolloVoice.tscn").instantiate()
var ares_voice = load("res://Main/Views/ArenaView/ArenaUnits/UnitVoice/AresVoice.tscn").instantiate()
var athena_voice = load("res://Main/Views/ArenaView/ArenaUnits/UnitVoice/AthenaVoice.tscn").instantiate()
var hades_voice = load("res://Main/Views/ArenaView/ArenaUnits/UnitVoice/HadesVoice.tscn").instantiate()
var hermes_voice = load("res://Main/Views/ArenaView/ArenaUnits/UnitVoice/HermesVoice.tscn").instantiate()
var zeus_voice = load("res://Main/Views/ArenaView/ArenaUnits/UnitVoice/ZeusVoice.tscn").instantiate()

# Called when the node enters the scene tree for the first time.
var data = {}
var voiceSceneMap = {
	VOICE.SOLDIER: soldier_voice,
	VOICE.HEALER: healer_voice,
	VOICE.HERMES: hermes_voice,
	VOICE.APOLLO: apollo_voice,
	VOICE.ZEUS: zeus_voice,
	VOICE.ARES: ares_voice,
	VOICE.ATHENA: athena_voice,
	VOICE.HADES: hades_voice,
}
func _ready():
	for v in VOICE.values():
		data[v] = {}
		for key in ["Greeting", "Response", "Die", "Hit", "FriendlyCast", "EnemyCast"]:
			data[v][key] = []
			for vl in voiceSceneMap[v].get_node(key).get_children():
				if key in ["Hit"]:
					vl.volume_db = -9
				else:
					vl.volume_db = -6
				data[v][key].append(vl)
	for line in voiceSceneMap: 
		add_child(voiceSceneMap[line])

	add_child(menuMusic)
	add_child(battleMusic)
	add_child(effects)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Game.arena == null and !menuMusic.is_playing():
		battleMusic.stop()
		menuMusic.play()
	elif Game.arena != null and !battleMusic.is_playing():
		menuMusic.stop()
		battleMusic.play()

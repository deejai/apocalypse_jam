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

var narration = load("res://Main/Views/Narration/NarrationAudio.tscn").instantiate()

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
					vl.volume_db = -6
				elif key in ["Response", "Greeting"] and v == VOICE.SOLDIER:
					vl.volume_db = -9
				else:
					vl.volume_db = -3
				data[v][key].append(vl)
	for line in voiceSceneMap: 
		add_child(voiceSceneMap[line])

	add_child(menuMusic)
	add_child(battleMusic)
	add_child(effects)
	add_child(narration)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Game.pause_music:
		battleMusic.stop()
		menuMusic.stop()
	elif Game.arena == null and !menuMusic.is_playing():
		battleMusic.stop()
		menuMusic.play()
	elif Game.arena != null and !battleMusic.is_playing():
		menuMusic.stop()
		battleMusic.play()


var narrations = {
		"NewGame": {
			"audio": narration.get_node("NewGame"),
			"text": "Long ago, before the Gods oversaw the affairs of the mortal realm, the Titans ruled the earth - roaming and shaping the world after their own image. They created mighty and terrible beasts to assist in imposing their destructive will. Eons passed while the world writhed in chaos, that is until Zeus was born.

The Thunderer was more beautiful and more powerful than any creature thus far born by the Titans. They feared his capabilities would quickly surpass their own, and made plans to subdue him. But the Fates had a different plan.

When the Titans arrived to Zeus's home on Mount Olympus they found a new breed of being, The Olympians. Sons and Daughters of Zeus crafted after his wondrous visage, they took up arms with their father. After a battle that nearly split the world asunder, The Olympians emerged successful and arrested their abominable forebears in a deep watery prison.

An age of peace descended on the world. The Olympians, too, created many kinds of beings during their reign, with the Human being their most prized. The Olympians reveled in their worship, and humanity enjoyed the gifts of the gods.

Until, once again, the earth shook. The Titans had spent the age plotting and waiting for their opportunity to take back what was theirs. And indeed, they did. The world, once again, is under the rule of the Titans. The Olympians have all been scattered.

Will you, the last Olympian, be able to rise to the challenge and take back the mortal realm for your kind?"
		},
		"Floor0": {
			"audio": narration.get_node("Floor0"),
			"text": "With the first Titan felled, there is hope that our champion can save the mortal realm."
		},
		"Floor1": {
			"audio": narration.get_node("Floor1"),
			"text": "Our champion slips further and further towards restoring the rightful place of the Olympians."
		},
		"Floor2": {
			"audio": narration.get_node("Floor2"),
			"text": "Take strength in your victories, Olympian, and carry them forward with you to fell the next Titan."
		},
		"Floor3": {
			"audio": narration.get_node("Floor3"),
			"text": "Will this story end in victory for the Olympians after all?"
		},
		"Floor4": {
			"audio": narration.get_node("Floor3"),
			"text": "With the last of the Titans brought down, and sealed once more in their abyssal tomb, you, Champion and Last of the Olympians, may rest on Mount Olympus and enjoy another Golden Age of Olympian rule."
		},
		"Loss": {
			"audio": narration.get_node("Loss"),
			"text": "And here, our story and our hope both end. The last Olympian has been dethroned, and the Titans once again rule."
		}
	}

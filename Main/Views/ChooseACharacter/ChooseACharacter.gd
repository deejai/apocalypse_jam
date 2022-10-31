extends Node2D

var name_info = {
	"Sprite_Apollo": {
		"base": Shared.BASE.OLYMPIAN_APOLLO,
		"name": "Apollo",
	},
	"Sprite_Ares": {
		"base": Shared.BASE.OLYMPIAN_ARES,
		"name": "Ares",
	},
	"Sprite_Athena": {
		"base": Shared.BASE.OLYMPIAN_ATHENA,
		"name": "Athena",
	},
	"Sprite_Hermes": {
		"base": Shared.BASE.OLYMPIAN_HERMES,
		"name": "Hermes",
	},
	"Sprite_Zeus": {
		"base": Shared.BASE.OLYMPIAN_ZEUS,
		"name": "Zeus",
	},
}

var olympian_key = null

var narration_view = load("res://Main/Views/Narration/Narration.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$ChooseButton.connect("pressed", func():
		Game.player.squad.insert(0, {
			"unit": Unit.new(name_info[olympian_key].base),
			"start_position": Vector2(400, 720-100),
		})
		get_tree().change_scene_to_packed(narration_view)
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	queue_redraw()

func _draw():
	pass

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		for choice in [$Sprite_Apollo, $Sprite_Ares, $Sprite_Athena, $Sprite_Hermes, $Sprite_Zeus]:
			var texture = choice.get_sprite_frames().get_frame("default", choice.get_frame())
			var twidth = texture.get_width() * choice.scale.x
			var theight = texture.get_height() * choice.scale.y
			var relative_click_pos = event.position - choice.position + Vector2(twidth/2.0, theight/2.0)
			var inside = relative_click_pos.x >= 0 and relative_click_pos.x <= twidth and relative_click_pos.y >= 0 and relative_click_pos.y <= theight
			if inside:
				olympian_key = choice.name
				break

		if olympian_key != null:
			$ChooseButton.text = str("Choose ", name_info[olympian_key].name)
			$ChooseButton.visible = true
			$ChooseButton.disabled = false
		else:
			$ChooseButton.visible = false
			$ChooseButton.disabled = true

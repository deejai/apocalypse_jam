extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("pressed", _button_pressed)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _button_pressed():
	print("Test")
	add_child(load("res://Main/Views/MapView/MapView.tscn").instantiate())

extends Sprite2D

var timer: int = 500

func init(position: Vector2):
	self.position = position

	return self

# Called when the node enters the scene tree for the first time.
func _ready():
	modulate.a = 0.3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer -= delta
	if timer <= 0:
		queue_free()

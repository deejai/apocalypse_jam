extends Node2D

var unit: Unit

var velocity: Vector2
var speed: int
var hp: int
var radius: int

# Called when the node enters the scene tree for the first time.
func init(unit: Unit):
	self.unit = unit
	self.hp = unit.hp
	self.speed = unit.speed
	self.radius = 50 if unit.size == "Large" else 30 if  unit.size == "Medium" else 15
	
	return self

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _draw():
	print("draw me at position ", position)
	draw_circle(Vector2.ZERO, 1000, Color.RED)

func move_to_target(delta, target):
	velocity = Vector2.ZERO
	velocity = position.direction_to(target) * speed

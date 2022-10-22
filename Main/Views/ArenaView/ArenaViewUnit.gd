extends CharacterBody2D

var unit: Unit

var speed: float
var hp: int

var selected: bool = false

var move_target: Vector2

var stop_timer: int = 0
var last_position: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func init(unit: Unit):
	self.unit = unit
	self.hp = unit.hp
	self.speed = unit.speed

	$Collision.shape.radius = 50 if unit.size == "Large" else 30 if  unit.size == "Medium" else 15

	return self

func _ready():
	print("TEST")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	stop_timer = max(0, stop_timer - delta)
	move_to_target(delta, move_target)

func move_to_target(delta, target):
	move_target.x = clamp(move_target.x, 0, 1080)
	move_target.y = clamp(move_target.y, 0, 720)

	if(position.distance_to(target) < 10):
		move_target = position
		return

#	velocity = Vector2.ZERO
#	velocity = position.direction_to(target) * 50
#	if get_slide_collision_count() and stop_timer == 0:
#		stop_timer = 150
#		last_position = position
#	set_velocity(velocity)
#	move_and_slide()
#	print("move?")
	print(target)
	var dir = position.direction_to(target)
	var new_x = clamp(position.x + dir.x * speed, 0, 1080)
	var new_y = clamp(position.y + dir.y * speed, 0, 720)
	position = Vector2(new_x, new_y)

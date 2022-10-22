extends CharacterBody2D

var unit: Unit

var speed: float
var hp: int

var selected: bool = false

var move_target: Vector2

var stuck_timer: int = 0
var stuck: bool = false
var last_position: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func init(unit: Unit):
	self.unit = unit
	self.hp = unit.hp
	self.speed = unit.speed

	$Collision.shape.radius = 50 if unit.size == "Large" else 30 if  unit.size == "Medium" else 15

	return self

func _ready():
	print(move_target)
	print($Collision.name)
	move_target = position
	print(position)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	stuck_timer = max(0, stuck_timer - delta)
	move_to_target(move_target)
#	print("mv tar ", move_target)
#	print("pos ", position)
#	print("gpos ", global_position)

func move_to_target(target):
	if(position.distance_to(target) < 5):
		return
	velocity = global_position.direction_to(target) * speed * 50
	if get_slide_collision_count() and stuck_timer == 0:
		stuck = true
		stuck_timer = 50
		last_position = position
	move_and_slide()

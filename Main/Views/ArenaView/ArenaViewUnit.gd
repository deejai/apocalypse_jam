extends CharacterBody2D

var unit: Unit

var speed: float
var hp: int

var selected: bool = false

var move_target: Vector2

var stuck_timer: int = 0
var stuck: bool = false
var last_position: Vector2

# Called when the node enters the scene tree for the first time.
func init(unit: Unit):
	self.unit = unit
	self.hp = unit.hp
	self.speed = unit.speed

	# idk if this logic is helpful
#	$Collision.shape.radius = 50 if unit.size == "Large" else 30 if  unit.size == "Medium" else 15

	return self

func _ready():
	print(move_target)
	print($Collision.name)
	move_target = position
	last_position = position
	print(position)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	stuck_timer = max(0, stuck_timer - delta)
	if(stuck and stuck_timer == 0):
		move_target = position
		stuck = false
	else:
		move_to_target(move_target)
		$AnimatedSprite2D.z_index = 100 + 100 * (position.y/720)
		print($AnimatedSprite2D.z_index)
#	print("mv tar ", move_target)
#	print("pos ", position)
#	print("gpos ", global_position)

func move_to_target(target):
	if(position.distance_to(target) < 5):
		return
		
	

	velocity = global_position.direction_to(target) * speed * 50
	if(stuck):
		print("ive been stuck for ", stuck_timer, " ms")
	if last_position.distance_to(position) < 0.3:
		print(last_position.distance_to(position))
		# if we weren't already stuck, we're stuck now. otherwise keep being stuck (do nothing here)
		if(stuck_timer == 0):
			print("im stuck")
			stuck = true
			stuck_timer = 50

	else:
		# if we were stuck, we're not now
		stuck = false
		stuck_timer = 0

	last_position = position
	move_and_slide()

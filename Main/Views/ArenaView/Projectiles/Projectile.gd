extends Node2D

class_name Projectile

var damage: int = 0
var speed: int = 5
var direction: Vector2
var hits: int = 0
var max_hits: int = 1
var lifespan: int = -1
var time_alive: int = 0
var alliance: ArenaUnit.ALLIANCE
var payload_fn: Callable = func(proj, target):
	target.apply_damage(proj.damage)
	target.apply_status(ArenaUnit.STATUS.HIT, .3)
var units_hit = {}

func init(alliance: ArenaUnit.ALLIANCE, position: Vector2, direction: Vector2, speed: int, damage: int):
	self.alliance = alliance
	self.position = position
	self.direction = direction
	self.speed = speed
	self.damage = damage

	return self

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.rotation = direction.angle()
	$Sound/Spawn.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_alive += delta
	if(lifespan != -1 and time_alive >= lifespan):
		queue_free()
	elif position.x < 0 - 100 or position.x > 1080 + 100 or position.y < 0 - 100 or position.y > 720 + 100:
		queue_free()
	elif hits >= max_hits:
		queue_free()

	position += speed * delta * direction

	for target in $Area2D.get_overlapping_bodies():
		if target is ArenaUnit and not units_hit.has(target):
			if target.alliance != alliance:
				payload_fn.call(self, target)
				units_hit[target] = true
				hits += 1

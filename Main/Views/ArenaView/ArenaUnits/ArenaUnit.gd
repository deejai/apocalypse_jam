extends CharacterBody2D

class_name ArenaUnit

enum ALLIANCE { ALLY, ENEMY }

var unit: Unit

var speed: float
var hp: float
var attack_damage: float
var attack_speed: float

var dying = false

var selected: bool = false

var move_target: Vector2
var attack_target: ArenaUnit = null

var attack_cd: float = 0

var stuck_timer: float = 0
var stuck: bool = false
var last_position: Vector2

var attack_damage_add: float = 0
var attack_damage_mult: float = 1.0
var attack_speed_add: float = 0
var attack_speed_mult: float = 1.0
var speed_add: float = 0
var speed_mult: float = 1.0

var projectile: PackedScene

# statuses
enum STATUS { STUN, SILENCE, ROOT, INVULN, NOHEAL }

var statuses = {
	STATUS.STUN: 0,
	STATUS.SILENCE: 0,
	STATUS.ROOT: 0,
	STATUS.INVULN: 0,
	STATUS.NOHEAL: 0,
}

var alliance: ALLIANCE

var time_since_redraw = 0

# Called when the node enters the scene tree for the first time.
func init(unit: Unit, alliance: ALLIANCE):
	self.unit = unit
	self.hp = unit.hp
	self.speed = unit.speed
	self.alliance = alliance
	self.attack_damage = unit.attack_damage
	self.attack_speed = unit.attack_speed

	match unit.base:
		Unit.BASE.SOLDIER_SPEAR: projectile = load("res://Main/Views/ArenaView/Projectiles/Spear.tscn")
		_: projectile = load("res://Main/Views/ArenaView/Projectiles/Spear.tscn")

	# idk if this logic is helpful
#	$Collision.shape.radius = 50 if unit.size == "Large" else 30 if  unit.size == "Medium" else 15

	return self

func _ready():
#	print(move_target)
#	print($Collision.name)
	move_target = position
	last_position = position
#	print(position)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	stuck_timer = max(0, stuck_timer - delta)
	attack_cd = max(0, attack_cd - delta)

	if attack_target != null and (not is_instance_valid(attack_target) or attack_target.dying):
		attack_target = null
		move_target = position

	if(stuck and stuck_timer == 0):
		move_target = position
		stuck = false
	elif is_instance_valid(attack_target):
		if position.distance_to(attack_target.position) > unit.range:
			move_to_target(attack_target.position)
		else:
			$AnimatedSprite2D.animation = "Idle"
			auto_attack(attack_target)
	else:
		move_to_target(move_target)
		$AnimatedSprite2D.z_index = 100 + 100 * (position.y/720)
#		print($AnimatedSprite2D.z_index)

	time_since_redraw += delta
	if time_since_redraw > 1.0 / 10:
		queue_redraw()
		time_since_redraw = 0

func _draw():
	if selected:
		draw_arc(Vector2.ZERO, 20, 0, TAU, 50, Color.WHITE, 2.0, true)

	var hpbar_width = 28
	var hpbar_height = 4
	var hpbar_offset = Vector2(0, 12)

	if alliance == ArenaUnit.ALLIANCE.ALLY:
		# draw green health bar below unit
		draw_rect(Rect2(hpbar_offset - Vector2(hpbar_width/2, hpbar_height/2), Vector2(hpbar_width, hpbar_height)), Color.GREEN)
		draw_rect(Rect2(hpbar_offset - Vector2(hpbar_width/2, hpbar_height/2), Vector2(hpbar_width * (1 - 1.0 * hp/unit.hp), hpbar_height)), Color.RED)

	else:
		# draw orange health bar below unit
		draw_rect(Rect2(hpbar_offset - Vector2(hpbar_width/2, hpbar_height/2), Vector2(hpbar_width, hpbar_height)), Color.ORANGE)
		draw_rect(Rect2(hpbar_offset - Vector2(hpbar_width/2, hpbar_height/2), Vector2(hpbar_width * (1 - 1.0 * hp/unit.hp), hpbar_height)), Color.RED)

func move_to_target(target):
	if(position.distance_to(target) < 5):
		$AnimatedSprite2D.animation = "Idle"
		velocity = Vector2.ZERO
		return

	velocity = global_position.direction_to(target) * get_speed() * 0.5

	if last_position.distance_to(position) < 0.3:
		$AnimatedSprite2D.animation = "Idle"
#		print(last_position.distance_to(position))
		# if we weren't already stuck, we're stuck now. otherwise keep being stuck (do nothing here)
		if(stuck_timer == 0):
#			print("im stuck")
			stuck = true
			stuck_timer = 50

	else:
		# we're moving
		stuck = false
		stuck_timer = 0

		$AnimatedSprite2D.animation = "Walk"

	last_position = position
	move_and_slide()

func apply_damage(amount: int):
	if statuses[STATUS.INVULN] > 0:
		return

	hp -= amount
	if hp <= 0:
		dying = true
		Audio.soldier_voice_die.play()
		for i in range(len(Game.player.squad_active)):
			if Game.player.squad_active[i].unit == unit:
				Game.player.squad_active.pop_at(i)
				break

func apply_healing(amount: int):
	if statuses[STATUS.NOHEAL] > 0:
		return

	hp = min(unit.hp, hp + amount)

func apply_status(status: STATUS, duration: int):
	statuses[status] = max(statuses[status], duration)

func get_attack_damage():
	return attack_damage * attack_damage_mult + attack_damage_add

func get_attack_speed():
	return attack_speed * attack_speed_mult + attack_speed_add

func get_speed():
	return speed * speed_mult + speed_add

func auto_attack(target):
	if attack_cd == 0:
		var direction = position.direction_to(target.position)
		var spear = projectile.instantiate().init(alliance, position, direction, 350, get_attack_damage())
		get_parent().add_child(spear)
		attack_cd = 2 * (100.0 / get_attack_speed())

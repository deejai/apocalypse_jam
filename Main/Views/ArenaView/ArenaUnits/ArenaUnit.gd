extends CharacterBody2D

class_name ArenaUnit

enum ALLIANCE { PLAYER, ENEMY }

var unit

var speed: float
var hp: float
var attack_damage: float
var attack_speed: float

var dying = false

var selected: bool = false

var move_target: Vector2
var attack_target: ArenaUnit = null

var attack_cd: float = 0.0

var stuck_timer: float = 0.0
var stuck: bool = false
var last_position: Vector2

var attack_damage_add: float = 0.0
var attack_damage_mult: float = 1.0
var attack_speed_add: float = 0.0
var attack_speed_mult: float = 1.0
var speed_add: float = 0.0
var speed_mult: float = 1.0

var projectile: PackedScene

var ability_cooldowns: Dictionary = {}

# statuses
enum STATUS { STUN, SILENCE, ROOT, INVULN, NOHEAL, ONFIRE, POISON, HEAL, HIT, LIGHTNING }

var statuses

var alliance: ALLIANCE

var time_since_redraw = 0

var facing_up: bool = true

var passive_ticks: float = 0

# Called when the node enters the scene tree for the first time.
func init(unit, alliance: ALLIANCE):
	self.unit = unit
	self.hp = unit.hp
	self.speed = unit.speed
	self.alliance = alliance
	self.attack_damage = unit.attack_damage
	self.attack_speed = unit.attack_speed

	self.projectile = unit.projectile
	
	if self.alliance == ALLIANCE.ENEMY:
		facing_up = false

	var active_cd_mod = randf()
	for ability in unit.activated_abilities:
		ability_cooldowns[ability] = 1.5 + active_cd_mod # wait a couple seconds before you can cast abilities

	for ability in unit.passive_abilities:
		ability_cooldowns[ability] = randf() * 2.0 # offset passive ticks from each other

	# idk if this logic is helpful
#	$Collision.shape.radius = 50 if unit.size == "Large" else 30 if  unit.size == "Medium" else 15

	return self

func _ready():
	statuses = {
		STATUS.STUN: {"duration": 0.0, "particles_scene": Game.arena.particles_stun.instantiate()},
		STATUS.SILENCE: {"duration": 0.0, "particles_scene": null},
		STATUS.ROOT: {"duration": 0.0, "particles_scene": Game.arena.particles_root.instantiate()},
		STATUS.INVULN: {"duration": 0.0, "particles_scene": null},
		STATUS.HEAL: {"duration": 0.0, "particles_scene": Game.arena.particles_heal.instantiate()},
		STATUS.LIGHTNING: {"duration": 0.0, "particles_scene": Game.arena.particles_lightning.instantiate()},
		STATUS.NOHEAL: {"duration": 0.0, "particles_scene": null},
		STATUS.ONFIRE: {"duration": 0.0, "particles_scene": Game.arena.particles_fire.instantiate()},
		STATUS.POISON: {"duration": 0.0, "particles_scene": Game.arena.particles_poison.instantiate()},
		STATUS.SPEED_BUFF: {"duration": 0.0, "particles_scene": Game.arena.particles_magic.instantiate()},
		STATUS.DAMAGE_BUFF: {"duration": 0.0, "particles_scene": Game.arena.particles_magic.instantiate()},
		STATUS.HIT: {"duration": 0.0, "particles_scene": Game.arena.particles_bloodspurt.instantiate()},
	}

	for status in statuses:
		if(statuses[status]["particles_scene"] != null):
			statuses[status]["particles_scene"].get_children()[0].emitting = false
			add_child(statuses[status]["particles_scene"])
	
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

	passive_ticks = (passive_ticks + delta)
	if passive_ticks > 100:
		passive_ticks -= 100
	process_passive_abilities()

	for ability in ability_cooldowns:
		ability_cooldowns[ability] = max(0, ability_cooldowns[ability] - delta)

	handle_statuses(delta)

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
			$AnimatedSprite2D.animation = "Idle_Up" if facing_up else "Idle_Down"
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

	if alliance == ArenaUnit.ALLIANCE.PLAYER:
		# draw green health bar below unit
		draw_rect(Rect2(hpbar_offset - Vector2(hpbar_width/2.0, hpbar_height/2.0), Vector2(hpbar_width, hpbar_height)), Color.GREEN)
		draw_rect(Rect2(hpbar_offset - Vector2(hpbar_width/2.0, hpbar_height/2.0), Vector2(hpbar_width * (1 - 1.0 * hp/unit.hp), hpbar_height)), Color.RED)

	else:
		# draw orange health bar below unit
		draw_rect(Rect2(hpbar_offset - Vector2(hpbar_width/2.0, hpbar_height/2.0), Vector2(hpbar_width, hpbar_height)), Color.ORANGE)
		draw_rect(Rect2(hpbar_offset - Vector2(hpbar_width/2.0, hpbar_height/2.0), Vector2(hpbar_width * (1 - 1.0 * hp/unit.hp), hpbar_height)), Color.RED)

func move_to_target(target):
	if(statuses[STATUS.STUN]["duration"] > 0.0 or statuses[STATUS.ROOT]["duration"]):
		return

	if(position.distance_to(target) < 5):
		$AnimatedSprite2D.animation = "Idle_Up" if facing_up else "Idle_Down"
		velocity = Vector2.ZERO
		return

	velocity = global_position.direction_to(target) * get_speed() * 0.5
	
	facing_up = true if velocity.y < 0 else false

	if last_position.distance_to(position) < 0.3:
		$AnimatedSprite2D.animation = "Idle_Up" if facing_up else "Idle_Down"
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

		$AnimatedSprite2D.animation = "Walk_Up" if facing_up else "Walk_Down"

	last_position = position
	move_and_slide()

func apply_damage(amount: int):
	if statuses[STATUS.INVULN]["duration"] > 0.0:
		return

	hp -= amount
	if hp <= 0:
		dying = true
		Audio.data[unit.voice].Die[randi()%len(Audio.data[unit.voice].Die)].play()
		for i in range(len(Game.player.squad)):
			if Game.player.squad[i].unit == unit:
				Game.player.squad.pop_at(i)
				break

func apply_healing(amount: float):
	if statuses[STATUS.NOHEAL]["duration"] > 0.0:
		return

	hp = min(unit.hp, hp + amount)

func apply_status(status: STATUS, duration: float):
	statuses[status]["duration"] = max(statuses[status]["duration"], duration)

func get_attack_damage():
	return attack_damage * attack_damage_mult + attack_damage_add

func get_attack_speed():
	if(statuses[STATUS.SPEED_BUFF]["duration"] > 0.0):
		attack_speed_mult=2
	return attack_speed * attack_speed_mult + attack_speed_add

func get_speed():
	if(statuses[STATUS.SPEED_BUFF]["duration"] > 0.0):
		speed_mult=2
	return speed * speed_mult + speed_add

func auto_attack(target: ArenaUnit):
	if(statuses[STATUS.STUN]["duration"] > 0.0):
		return

	if attack_cd == 0:
		var direction = position.direction_to(target.position)
		var spear = projectile.instantiate().init(alliance, position, direction, 350, get_attack_damage())
		Game.arena.add_child(spear)
		attack_cd = 2 * (100.0 / get_attack_speed())

func in_range(target: ArenaUnit):
	var collision_radius_sum =  $Collision.shape.radius + target.get_node("Collision").shape.radius
	return position.distance_to(target.position) - collision_radius_sum <= unit.range

func handle_statuses(delta):
	for status in STATUS.values():
		statuses[status]["duration"] = max(0, statuses[status]["duration"]-delta)

	for status in STATUS.values():
		if statuses[status]["particles_scene"] != null:
			if statuses[status]["duration"] > 0:
				if statuses[status]["particles_scene"] == null:
					# status particles are not implemented
					pass
				else:
					statuses[status]["particles_scene"].get_children()[0].emitting = true

			elif statuses[status]["duration"] == 0.0:
				statuses[status]["particles_scene"].get_children()[0].emitting = false

func process_passive_abilities():
	for ability in unit.passive_abilities:
		if floori(passive_ticks) % ability.cooldown == 0 and ability_cooldowns[ability] == 0.0:
			print("tick")
			ability_cooldowns[ability] = ability.cooldown

			var units = Game.arena.get_units_in_aoe(
					position,
					350,
					ArenaUnit.affected_alliances(alliance, ability.targets)
				)

			for unit in units:
				ability.effect_fn.call(ability, unit)

static func affected_alliances(alliance: ArenaUnit.ALLIANCE, which):
	match which:
		Shared.TARGETS.SAME:
			return [alliance]
		Shared.TARGETS.OTHER:
			return [ArenaUnit.ALLIANCE.PLAYER] if alliance == ArenaUnit.ALLIANCE.ENEMY else [ArenaUnit.ALLIANCE.ENEMY]
		Shared.TARGETS.ALL:
			return [ArenaUnit.ALLIANCE.ENEMY, ArenaUnit.ALLIANCE.PLAYER]
		_:
			assert(false)
			return []

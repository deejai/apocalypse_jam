extends Node2D

var floorNode: FloorNode

func init(floorNode: FloorNode, x: int, y: int):
	match floorNode.reward_type:
		Shared.REWARD_TYPE.NEW_UNIT:
			$AnimatedSprite2D.frame = 0

		Shared.REWARD_TYPE.UNIT_UPGRADE:
			$AnimatedSprite2D.frame = 1

		Shared.REWARD_TYPE.WILDCARD:
			$AnimatedSprite2D.frame = 2

		_:
			assert(false)
			
	if floorNode.boss_node == true:
		$AnimatedSprite2D.frame = 3

	self.position = Vector2i(x, y)
	self.floorNode = floorNode
	floorNode.sceneNode = self # what if it had a sceneNode and we just overwrote it? probably won't happen :/

	return self

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _draw():
	pass

func _input(event: InputEvent):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_MASK_LEFT:
		if position.distance_to(event.position) < $Area/Collision.shape.radius:
			if floorNode.completed == false and floorNode == Game.player.floor.current:
				# queue up the battle to be grabbed by mapview
				Game.next_battle = floorNode.battle
			elif Game.player.floor.current.completed and floorNode in Game.player.floor.current.next:
				Game.player.floor.current = floorNode
				get_parent().queue_redraw()
				print("Navigated to next node")

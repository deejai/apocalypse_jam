extends Node2D

var floorNode: FloorNode

func init(floorNode: FloorNode, x: int, y: int):
	self.position = Vector2i(x, y)
	self.floorNode = floorNode
	floorNode.sceneNode = self # what if it had a sceneNode and we just overwrote it? probably won't happen :/

	for prev in floorNode.prev:
		if prev.sceneNode:
			prev.sceneNode._draw()
	
	return self

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _draw():
	for next in floorNode.next:
		if is_instance_valid(next.sceneNode):
#			print(next.sceneNode.position - self.position)
			draw_line(Vector2i(0,0), next.sceneNode.position - self.position, Color(255, 0, 0), 1)

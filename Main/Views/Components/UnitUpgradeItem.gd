extends AnimatedSprite2D

var upgrade: UnitUpgrade

func init(effect: UnitUpgrade.EFFECT = UnitUpgrade.EFFECT.RAND):
	self.upgrade = UnitUpgrade.new(Game.player.floor.level, effect)
	frame = upgrade.effect
	$Label.text = str(upgrade.amount)
	return self

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

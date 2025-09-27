extends Sprite2D

var frames = texture.get_width() / region_rect.size.x

func _ready():
	self.frame = randi_range(0,8)

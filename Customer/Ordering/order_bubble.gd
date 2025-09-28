extends Node2D
class_name OrderBubble

@export var bubbleSprite: Sprite2D
@export var orderIcon: Sprite2D

# dict to map order types to the textures
var orderFrames = {
	"chicken": 2,
	"fries": 3,
	"soda": 4,
	"burger": 5
}

func _ready():
	pass

func showOrder(orderType: String):
	#print("your food is ready" + orderType)
	if orderType in orderFrames.keys():
		#print("your food is ready" + orderType)
		orderIcon.frame = orderFrames[orderType]
		self.visible = true
		
		# pop in animation
		var tween = create_tween()

		#tween.tween_property(orderIcon, "scale", Vector2.ONE, 0.1)\
			#.set_ease(Tween.EASE_OUT)\
			#.set_trans(Tween.TRANS_BACK)
		tween.tween_property(bubbleSprite, "scale", Vector2.ONE, 0.1)\
			.set_ease(Tween.EASE_OUT)\
			.set_trans(Tween.TRANS_BACK)

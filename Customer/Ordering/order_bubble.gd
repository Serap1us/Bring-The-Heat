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

var currentOrders: Array = []
var currentIdx: int = 0
@onready var orderTimer = $OrderTimer

func _ready():
	pass

func showOrder(orderTypes: Array):
	#print("your food is ready" + orderType)
	currentOrders = orderTypes
	currentIdx = 0
	if !currentOrders.is_empty():
		var orderType = currentOrders[0]
		if orderType in orderFrames.keys():
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
				
			cycleOrders()
			
func cycleOrders():
	if currentOrders.size() <= 1:
		return
	orderTimer.timeout.connect(_nextOrder)

func _nextOrder():
	currentIdx = (currentIdx + 1) % currentOrders.size()
	var orderType = currentOrders[currentIdx]
	
	if orderType in orderFrames.keys():
		orderIcon.frame = orderFrames[orderType]
		
		cycleOrders()
	

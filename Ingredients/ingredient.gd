extends Throwable
class_name Ingredient

enum Ingredients {
	CHEESE,
	TOMATO,
	RAW_CHICKEN,
	SODA,
	BREAD,
	VEGETABLE
	}

@export var ingredient: Ingredients


func _ready() -> void:
	#Display the name when player is near.
	interact_label = Ingredients.keys()[ingredient]

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

@export var cooked_version: Ingredients

var is_cooked: bool = false


func _ready() -> void:
	#Display the name when player is near.
	interact_label = Ingredients.keys()[ingredient]

func cook():
	ingredient = cooked_version
	is_cooked = true
	
	change_sprite()

func change_sprite():
	pass

#TODO: Add some code to change the sprite based on the enum vars

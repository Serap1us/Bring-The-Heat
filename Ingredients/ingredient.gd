extends Throwable
class_name Ingredient

enum Ingredients {
	CHEESE,
	TOMATO,
	CHICKEN,
	SODA,
	BREAD,
	VEGETABLE
	}


@export var ingredient: Ingredients : set = set_ingredient
@onready var ingredient_sprite = $Sprite2D

func set_ingredient(new_ingredient: int):
	ingredient = new_ingredient as Ingredients
	interact_label = Ingredients.keys()[ingredient]

func _ready() -> void:
	ingredient_sprite.frame = ingredient

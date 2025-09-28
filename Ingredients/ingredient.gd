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
@onready var ingredient_sprite = $Sprite2D

func set_ingredient(new_ingredient: String):
	ingredient = Ingredients.find_key(new_ingredient.to_upper())
	interact_label = new_ingredient
	ingredient_sprite.frame = ingredient

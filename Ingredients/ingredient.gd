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

func _ready() -> void:
	set_ingredient(Ingredients.CHICKEN)
func set_ingredient(new_ingredient: Ingredients):
	ingredient = new_ingredient
	interact_label = Ingredients.keys()[ingredient]
	ingredient_sprite.frame = ingredient

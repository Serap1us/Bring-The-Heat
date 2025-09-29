extends Throwable
class_name Ingredient

enum Ingredients {
	PATTY,
	CHICKEN,
	KEBAB,
	PIZZA,
	DOUGH
	}
	
var is_cooked: bool = false

@export var ingredient: Ingredients : set = set_ingredient
@onready var ingredient_sprite = $Sprite2D

func set_ingredient(new_ingredient: int):
	ingredient = new_ingredient as Ingredients
	interact_label = Ingredients.keys()[ingredient]

func _ready() -> void:
	super()
	ingredient_sprite.frame = ingredient

func _physics_process(delta: float) -> void:
	super(delta)
	if is_cooked:
		ingredient_sprite.frame_coords.y = 1
	else:
		ingredient_sprite.frame_coords.y = 0

func cook():
	is_cooked = true

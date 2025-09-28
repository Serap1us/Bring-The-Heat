class_name Pantry extends Interactable

@export_category("Allowed Ingredients")
## MAKE SURE THIS IS THE SAME ENUM AS THE ONE IN INGREDIENT.GD
enum Ingredients {
	CHEESE,
	TOMATO,
	RAW_CHICKEN,
	SODA,
	BREAD,
	VEGETABLE
	}

##List of ingredient types that this appliance can cook.
@export var allowed_ingredients: Array[Ingredients]

@export_category("Outputs")
##These are the scenes it will spawn when the cooking is done.
@export var outputs: Array[PackedScene]

@export_category("Node Parts")

@export var pop_out_point: Marker2D

@export var cook_point: Marker2D

@export var stored_food: Ingredients = Ingredients.CHEESE
var ingredient_scene = preload("res://Ingredients/Ingredient.tscn")


func _ready() -> void:
	$StorePoint/Sprite2D.frame = stored_food


func execute(player: Player):
	if !player.held_item:
		var spawn_ingredient : Ingredient = ingredient_scene.instantiate()
		spawn_ingredient.set_ingredient(stored_food)
		spawn_ingredient.global_position = pop_out_point.position
		set_deferred("add_child", spawn_ingredient)

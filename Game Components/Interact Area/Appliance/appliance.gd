class_name Appliance extends Interactable

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

@export var allowed_ingredients: Array[Ingredients]


@export_category("Outputs")
##These are the scenes it will spawn when the cooking is done.
@export var outputs: Array[PackedScene]


@export_category("Node Parts")

@export var anim_player: AnimationPlayer

@export var pop_out_point: Marker2D

@export var cook_point: Marker2D

@export var cooking_timer: Timer

@export var cooking_time: float


var stored_food: Ingredient

var stored_fire: Interactable


func _ready() -> void:
	cooking_timer.wait_time = cooking_time
	
	cooking_timer.start()
	
	cooking_timer.paused = true
	
	if outputs.size() != allowed_ingredients.size():
		print("NEED TO ASSIGN AN OUTPUT/INPUT")


func _physics_process(delta: float) -> void:
	if stored_fire != null and stored_food != null:
		cooking_timer.paused = false
		
		if !anim_player.current_animation == "Flaming":
			anim_player.play("Flaming")
	else: 
		cooking_timer.paused = true
		
		anim_player.play("Idle")


func execute(player: Player):
	if player.held_item:
		print("dsf")
		if player.held_item is Ingredient && stored_food == null:
			stored_food = player.held_item
			
			store_ingredient()
			
		else:
			stored_fire = player.held_item
			
			store_fire()
			
	else:
		if stored_fire != null:
			eject_fire()
			
		elif stored_food != null:
			eject_ingredient()


##Turn off the ingredient from being picked up and turn it invisible.
func store_ingredient():
	stored_food.unfollow_player()
	
	stored_food.global_position = cook_point.global_position
	
	stored_food.close_area()
	
	stored_food.z_index += 1
	
	cooking_timer.wait_time = cooking_time


func eject_ingredient():
	stored_food.monitorable = true
	
	stored_food.z_index -= 1
	
	stored_food = null
	
	cooking_timer.wait_time = cooking_time


func store_fire():
	pass


func eject_fire():
	pass


##Instantiate the output based on the input. (So if the first ingredient is raw chicken then the first output must be cooked chicken).
func eject_cooked():
	pass


func _on_cooking_timer_timeout() -> void:
	cooking_timer.start()
	
	cooking_timer.paused = true
	
	eject_cooked()

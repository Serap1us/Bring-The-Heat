class_name Appliance extends Interactable

@export_category("Allowed Ingredients")
## MAKE SURE THIS IS THE SAME ENUM AS THE ONE IN INGREDIENT.GD
enum Ingredients {
	PATTY,
	CHICKEN,
	KEBAB,
	PIZZA,
	DOUGH
	}

##List of ingredient types that this appliance can cook.
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


func _physics_process(_delta: float) -> void:
	if stored_fire != null:
		if anim_player.current_animation != "Flaming":
				anim_player.play("Flaming")
		
		if stored_food != null:
			cooking_timer.paused = false
		else: 
			cooking_timer.paused = true
	else:
		anim_player.play("Idle")


func execute(player: Player):
	if player.held_item:
		if player.held_item is Ingredient && stored_food == null:
			stored_food = player.held_item
			
			if allowed_ingredients.has(stored_food.ingredient):
				store_ingredient()
			else:
				stored_food = null
			
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
	
	stored_food.global_position = pop_out_point.global_position
	
	stored_food = null
	
	cooking_timer.wait_time = cooking_time


func store_fire():
	stored_fire.unfollow_player()
	
	stored_fire.close_area()
	
	stored_fire.visible = false
	
	cooking_timer.wait_time = cooking_time


func eject_fire():
	stored_fire.monitorable = true
	
	stored_fire.global_position = pop_out_point.global_position
	
	stored_fire.visible = true
	
	stored_fire = null
	
	cooking_timer.wait_time = cooking_time



##Instantiate the output based on the input. (So if the first ingredient is raw chicken then the first output must be cooked chicken).
func eject_cooked():
	stored_food.cook()
	
	eject_ingredient()


func _on_cooking_timer_timeout() -> void:
	cooking_timer.start()
	
	cooking_timer.paused = true
	
	eject_cooked()

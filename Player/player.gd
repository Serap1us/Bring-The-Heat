class_name Player

extends CharacterBody2D

# Variables
@export var speed: int = 250
@export var player_idx: int = 1 # player 1 = idx 1, player 2 = idx 2
@onready var sprite = $Sprite2D
@onready var arrow_sprite = $ArrowSprite

##An array that can only be filled with objects that inherit from Interactable
@onready var all_interactions: Array [Interactable]
@onready var interactLabel = $"Interaction Components/InteractLabel"

@export var held_item: Throwable

var dir: Vector2

func _ready():
	if player_idx == 2:
		sprite.frame = 1
	
	update_interactions()

func _physics_process(_delta: float) -> void:
	get_movement_input()
	
	if Input.is_action_just_pressed("player" + str(player_idx) + "_interact"):
		execute_interactions()
	
	
# function to get player input for movement
func get_movement_input():
	var input_vector = Vector2.ZERO
	
	if Input.is_action_pressed("player" + str(player_idx) + "_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("player" + str(player_idx) + "_right"):
		input_vector.x += 1
	if Input.is_action_pressed("player" + str(player_idx) + "_up"):
		input_vector.y -= 1
	if Input.is_action_pressed("player" + str(player_idx) + "_down"):
		input_vector.y += 1
	if Input.is_action_pressed("player" + str(player_idx) + "_rotate"):
		velocity = Vector2.ZERO
	else:
		velocity = input_vector.normalized() * speed

	
	# Change sprite arrow direction
	if input_vector != Vector2.ZERO:
		var direction_faced = get_direction_faced(input_vector)
		
		dir = input_vector #this one is used by scripts outside of the player
		
		# player facing orientation
		var facing_left_list = ["left", "up_left", "down_left"]
		var facing_right_list = ["right", "up_right", "down_right"]
		
		if direction_faced in facing_left_list:
			sprite.flip_h = false
		elif direction_faced in facing_right_list:
			sprite.flip_h = true
		
		
		# orient the arrow to the players facing direction
		match direction_faced:
			"right":
				arrow_sprite.rotation = PI
			"down_right":
				arrow_sprite.rotation = -3*PI/4
			"down":
				arrow_sprite.rotation = -PI/2
			"down_left":
				arrow_sprite.rotation = -PI/4
			"left":
				arrow_sprite.rotation = 0 
			"up_left":
				arrow_sprite.rotation = PI/4
			"up":
				arrow_sprite.rotation = PI/2
			"up_right":
				arrow_sprite.rotation = 3*PI/4
	move_and_slide()

# Use vectors to determine the sprite arrow direction
func get_direction_faced(vector: Vector2) -> String:
	var angle = vector.angle()

	if angle > -PI/8 and angle <= PI/8:
		return "right"
	elif angle > PI/8 and angle <= 3*PI/8: 
		return "down_right" 
	elif angle > 3*PI/8 and angle <= 5*PI/8:
		return "down"
	elif angle > 5*PI/8 and angle <= 7*PI/8:
		return "down_left"
	elif angle > 7*PI/8 or angle <= -7*PI/8:
		return "left"
	elif angle > -7*PI/8 and angle <= -5*PI/8:
		return "up_left"
	elif angle > -5*PI/8 and angle <= -3*PI/8:
		return "up"
	elif angle > -3*PI/8 and angle <= -PI/8:
		return "up_right"
	else:
		return "none"
	


# Player interaction methods
func _on_interaction_area_area_entered(area: Area2D) -> void:
	if area is Interactable:
		all_interactions.insert(0, area)
		update_interactions()


func _on_interaction_area_area_exited(area: Area2D) -> void:
	if area is Interactable:
		all_interactions.erase(area)
		update_interactions()

##Displays the first interactable item near the player.
func update_interactions():
	if !all_interactions.is_empty():
		print(all_interactions)
		interactLabel.text = all_interactions[0].interact_label
	else:
		interactLabel.text = ""

##Execute the first interactable near the player.
func execute_interactions():
	if all_interactions:
		var cur_interaction: Interactable = all_interactions[0]
		
		#calls the execute() function which is present within all Interactables. 
		cur_interaction.execute(self) #Gives a reference to self (used for pickin up items).
	
func set_held_item(item):
	held_item = item

func hasFood() -> bool:
	return held_item is Ingredient

func getCurrentFood() -> Ingredient:
	if held_item is Ingredient:
		return held_item.interact_label
	return null

func removeFood():
	if held_item is Ingredient:
		held_item = null

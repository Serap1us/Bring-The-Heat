class_name Player

extends CharacterBody2D

# Variables
@export var speed: int = 250
@export var player_idx: int = 1 # player 1 = idx 1, player 2 = idx 2
@onready var sprite = $Sprite2D

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
	
	sprite.rotation = input_vector.angle()
	
	# Change sprite direction
	if input_vector != Vector2.ZERO:
		var direction_faced = get_direction_faced(input_vector)
		
		match direction_faced:
			"right": sprite.rotation = 0
			"down_right": sprite.rotation = PI/4
			"down": sprite.rotation = PI/2
			"down_left": sprite.rotation = 3*PI/4
			"left": sprite.rotation = PI
			"up_left": sprite.rotation = -3*PI/4
			"up": sprite.rotation = -PI/2
			"up_right": sprite.rotation = -PI/4
			
		
	move_and_slide()

# Use vectors to determine the sprite direction
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
	elif angle > 7*PI/8 and angle <= -7*PI/8:
		return "left"
	elif angle > -7*PI/8 and angle <= -5*PI/8:
		return "up_left"
	elif angle > -5*PI/8 and angle <= -3*PI/8:
		return "up"
	elif angle > -3*PI/8 and angle <= -PI/8:
		return "up_right"
	else:
		return "down"
	
	


		
	
func _physics_process(delta: float) -> void:
	get_movement_input()
	
	 
	

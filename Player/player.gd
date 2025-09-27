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
	move_and_slide()
		
	
func _physics_process(delta: float) -> void:
	get_movement_input()
	
	 
	

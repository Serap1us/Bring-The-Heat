class_name Player

extends CharacterBody2D

@export var speed: int = 250
@export var player_idx: int = 2 # player 1 = idx 1, player 2 = idx 2

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
		
	velocity = input_vector * speed
	

func _physics_process(delta: float) -> void:
	get_movement_input()
	
	move_and_slide()
	 
	

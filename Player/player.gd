class_name Player

extends CharacterBody2D

@export var speed: int = 400
@export var player_idx: int = 1 # player 1 = idx 1, player 2 = idx 2

func _physics_process(delta: float) -> void:
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
	
	move_and_slide()
	 
	

class_name Throwable extends Interactable

@export var ui: throwableUI

#The higher the number the faster it charges up to throw.
@export var throw_val: float = 1.4
@export var speed: float = 2


var is_picked_up: bool = false

var player: Player

#Is this object following the player?
var is_following: bool = false

var is_charging_up: bool = false

#Is the throwable in the air?
var has_landed: bool = true

var landing_spot: Vector2

var max_throw_val: float = 100


func _ready() -> void:
	if !ui:
		print("No Ui attached")
	else:
		ui.prog_bar.max_value = max_throw_val
		ui.prog_bar.value = 0
		
		ui.visible = false


func _physics_process(delta: float) -> void:
	#If there's a player and you're holding the throw button.
	if player:
		if Input.is_action_pressed("player" + str(player.player_idx) + "_rotate"):
			is_charging_up = true
			ui.rotation = player.dir.angle()
			
			ui.whole_bar.rotation =  -ui.rotation
		
		elif Input.is_action_just_released("player" + str(player.player_idx) + "_rotate"):
			throw()
			is_charging_up = false
		
		else:
			is_charging_up = false
	
	charge_throw()
	
	# This if/else is for changing the position of the throwable.
	if is_following and player != null:
		position = player.position
	
	#logic for when this is being thrown.
	elif !is_following and !has_landed:
		global_position = global_position.lerp(landing_spot, speed * delta)
		
		if global_position.distance_to(landing_spot) < 32:
			has_landed = true


#Inherited from Interactable. When this item has been picked up.
func execute(interact_player: Player):
	if !is_picked_up and interact_player.held_item == null:
		follow_player(interact_player)
		
		is_picked_up = true
		
		close_area()


##Parent this to a player
func follow_player(new_player: Player):
	self.player = new_player
	
	player.set_held_item(self)
	
	z_index += 1
	
	is_following = true


##Unattach from player.
func unfollow_player():
	player.set_held_item(null)
	
	self.player = null
	
	#turn the area2D back on. Quickly move it so the player registers it as entering its area again.
	monitorable = true
	var past_pos = global_position
	global_position = Vector2.ZERO
	global_position = past_pos
	
	z_index -= 1
	
	is_following = false
	is_picked_up = false


func charge_throw():
	if is_charging_up:
		ui.visible = true
		
		ui.landing.progress_ratio += throw_val * get_process_delta_time()
		
		ui.prog_bar.value = ui.landing.progress_ratio
	else:
		ui.prog_bar.value -= throw_val
		
		ui.visible = false
		
		ui.landing.progress_ratio -= throw_val * get_process_delta_time()


func throw():
	landing_spot = ui.landing.global_position + Vector2(0, -16)
	
	if ui.landing.progress_ratio > 0.75: 
		landing_spot += (player.dir * 192)
	
	unfollow_player()
	
	has_landed = false

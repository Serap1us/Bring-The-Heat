class_name Throwable extends Interactable

@export var ui: throwableUI

var is_picked_up: bool = false

var player: Player

#Is this object following the player?
var is_following: bool = false

var is_charging_up: bool = false

var max_throw_val: float = 100

@export var throw_val: float = 5


func _ready() -> void:
	if !ui:
		print("No Ui attached")
	else:
		ui.prog_bar.max_value = max_throw_val
		ui.prog_bar.value = 0
		
		ui.landing.visible = false


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("player" + str(player.player_idx) + "_rotate"):
		if Input.is_action_pressed("player" + str(player.player_idx) + "_interact"):
			is_charging_up


func _process(delta: float) -> void:
	if is_following and player != null:
		position = player.position
	
	if is_charging_up:
		ui.prog_bar.value += throw_val
	elif ui.prog_bar.value > 0:
		ui.prog_bar.value -= throw_val * 5


#Inherited from Interactable. When this item has been picked up.
func execute(player: Player):
	if !is_picked_up:
		follow_player(player)
		
		player.held_item = self
		
		is_picked_up = true
		
		close_area()
	
	else:
		charge_throw()
		
		is_picked_up = false


##Parent this to a player
func follow_player(player: Player):
	self.player = player
	
	is_following = true


##Unattach from player.
func unfollow_player():
	is_following = false


func charge_throw():
	print(player.dir)


func throw():
	pass

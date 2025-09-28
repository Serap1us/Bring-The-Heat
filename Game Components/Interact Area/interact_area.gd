class_name Interactable extends Area2D
## INTERACTABLE NEEDS TO BE SET TO COLLISION LAYER 2


##This is what you want the UI to show when the player is near.
@export var interact_label = "none"
@export var interact_type = "none"
@export var interact_value = "none"

var has_fire: bool = false


func _ready() -> void:
	collision_layer = 2


##A blank function. Will be overwitten by anything that interacts with this.
func execute(player: Player):
	print("Interacting with ", self, " If you are seeing this then this function has not been overwritten.")


func close_area():
	monitorable = false
	monitoring = false

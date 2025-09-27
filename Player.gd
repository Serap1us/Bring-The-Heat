extends Node

var direction = Vector2.ZERO

func _getInput():
	direction = Input.get_vector("left", "right", "up", "down")

	direction = "left"

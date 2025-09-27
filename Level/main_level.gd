extends Node2D
class_name MainLevel

# Array of Arrray containing seat coordinates and availability
# [Vector2, bool]
@onready var seat_availability := [
	[Vector2(0,0), false],
]

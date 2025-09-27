extends Node2D
class_name MainLevel

# Array of Arrray containing seat coordinates and availability
# [Vector2, bool]
@onready var seat_availability := [
	[Vector2(0,0), false],
]

@export var curr_score := 0 : set = _set_score
@onready var score_label = $Control/Score

func _set_score(new_score):
	var prev_score := curr_score
	curr_score = new_score
	score_label.text = "Score: " + str(curr_score)
	
	var number = Label.new()
	number.z_index = 5
	number.text = str(new_score - prev_score)
	number.label_settings = LabelSettings.new()
	
	number.label_settings.font_size = 22
	number.label_settings.outline_color = "#000"
	number.label_settings.outline_size = 1
	
	score_label.call_deferred("add_child", number)
	
	await number.resized
	number.pivot_offset = Vector2(number.size / 2)
	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(
		number, "position:y", number.position.y - 24, 0.25
	).set_ease(Tween.EASE_OUT)


func _physics_process(delta: float) -> void:
	curr_score += 1

extends Control


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file('res://Level/main_level.tscn')
	

var tween_intensity = 1.1
var tween_duration = 0.25

func _ready():
	var vbox = $CenterContainer/VBoxContainer
	for child in vbox.get_children():
		if child is Button:
			setup_hover_tween(child)

func setup_hover_tween(button: Button) -> void:
	button.mouse_entered.connect(_on_button_hover_in.bind(button))
	button.mouse_exited.connect(_on_button_hover_out.bind(button))
	
func _on_button_hover_in(button: Button) -> void:
	var tween = create_tween()
	tween.tween_property(button, "scale", Vector2(tween_intensity, tween_intensity), tween_duration)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _on_button_hover_out(button: Button) -> void:
	var tween = create_tween()
	tween.tween_property(button, "scale", Vector2(1.0, 1.0), tween_duration)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)

#func kill_tweens_for(target: Object) -> void:
	#for t in get_tweens():
		#if t.is_running() and t.target == target:
			#t.kill()

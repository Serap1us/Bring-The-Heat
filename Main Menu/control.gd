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
			
	# Settings
	handle_connecting_signals()

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


# Settings for main menu 
@onready var settings: Button = $CenterContainer/VBoxContainer/Settings as Button
@onready var settings_menu: SettingsMenu = $Settings_Menu as SettingsMenu
@onready var center_container: CenterContainer = $CenterContainer as CenterContainer


func on_settings_pressed() -> void:
	print("load settings menu")
	center_container.visible = false
	settings_menu.set_process(true)
	settings_menu.visible = true
	
func on_exit_settings_menu() -> void:
	center_container.visible = true
	settings_menu.visible = false

func handle_connecting_signals() -> void:
	settings.button_down.connect(on_settings_pressed)
	settings_menu.exit_settings_menu.connect(on_exit_settings_menu)

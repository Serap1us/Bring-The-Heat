extends Control

var _is_paused:bool = false:
	set = set_paused
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_is_paused = !_is_paused
	
func set_paused(value: bool) -> void:
	_is_paused = value
	get_tree().paused = _is_paused
	visible = _is_paused
	

func _on_resume_btn_pressed() -> void:
	_is_paused = false
	
	
func _on_settings_btn_pressed() -> void:
	pass # Replace with function body.


func _on_quit_btn_pressed() -> void:
	get_tree().quit()



# Settings 
func _ready():
	handle_connecting_signals()
	
@onready var settings_btn: Button = $GridContainer/SettingsBtn as Button
@onready var settings_menu: SettingsMenu = $Settings_Menu as SettingsMenu
@onready var grid_container: GridContainer = $GridContainer as GridContainer


func on_settings_pressed() -> void:
	print("load settings menu")
	grid_container.visible = false
	settings_menu.set_process(true)
	settings_menu.visible = true
	
func on_exit_settings_menu() -> void:
	grid_container.visible = true
	settings_menu.visible = false

func handle_connecting_signals() -> void:
	settings_btn.button_down.connect(on_settings_pressed)
	settings_menu.exit_settings_menu.connect(on_exit_settings_menu)

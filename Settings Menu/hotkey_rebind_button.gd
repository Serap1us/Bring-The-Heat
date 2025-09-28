class_name HotkeyRebindButton
extends Control

@onready var label: Label = $HBoxContainer/Label as Label
@onready var button: Button = $HBoxContainer/Button as Button

@export var action_name : String = "player1_left"

func _ready():
	set_process_unhandled_key_input(false)
	set_action_name()
	set_text_for_key()

# Display controls name in settings
func set_action_name() -> void:
	label.text = "Unassigned"
	
	match action_name:
		# Player one controls
		"player1_left":
			label.text = "Move Left"
		"player1_right":
			label.text = "Move Right"
		"player1_up":
			label.text = "Move Up"
		"player1_down":
			label.text = "Move Down"
		"player1_rotate": # Might need to change
			label.text = "Throw"
		"player1_interact":
			label.text = "Interact"
			
		# Player Two Controls
		"player2_left":
			label.text = "Move Left"
		"player2_right":
			label.text = "Move Right"
		"player2_up":
			label.text = "Move Up"
		"player2_down":
			label.text = "Move Down"
		"player2_rotate": # Might need to change
			label.text = "Throw"
		"player2_interact":
			label.text = "Interact"

# New keybind
func set_text_for_key() -> void:
	var action_events = InputMap.action_get_events(action_name)
	var action_event = action_events[0]
	var action_keycode = OS.get_keycode_string(action_event.physical_keycode)
	
	button.text = "%s" % action_keycode
	
# Ensures only one button can be rebinded at a time
func _on_button_toggled(button_pressed: bool) -> void:
	if button_pressed:
		button.text = "Press any key..."
		set_process_unhandled_key_input(button_pressed)
		
		for i in get_tree().get_nodes_in_group("hotkey_button"):
			if i.action_name != self.action_name:
				i.button.toggle_mode = false
				i.set_process_unhandled_key_input(false)
				
	else:
		
		for i in get_tree().get_nodes_in_group("hotkey_button"):
			if i.action_name != self.action_name:
				i.button.toggle_mode = true
				i.set_process_unhandled_key_input(false)
				
		set_text_for_key()

func _unhandled_key_input(event: InputEvent) -> void:
	rebind_action_key(event)
	button.button_pressed = false
	
func rebind_action_key(event):
	InputMap.action_erase_events(action_name)
	InputMap.action_add_event(action_name, event)
	
	set_process_unhandled_key_input(false)
	set_text_for_key()
	set_action_name()

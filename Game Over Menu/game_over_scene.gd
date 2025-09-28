extends CanvasLayer




func _on_main_menu_btn_pressed() -> void:
	pass # Replace with function body.


func _on_restart_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Level/main_level.tscn")
	

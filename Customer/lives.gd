extends Node

func _ready() -> void:
	LivesCounter.lives = 5
	
func _physics_process(delta: float) -> void:
	if LivesCounter.lives == 4:
		$Star1.hide()
	if LivesCounter.lives == 3:
		$Star2.hide()
	if LivesCounter.lives == 2:
		$Star3.hide()
	if LivesCounter.lives == 1:
		$Star4.hide()
	if LivesCounter.lives == 0:
		get_tree().change_scene_to_file("res://Game Over Menu/game_over_scene.tscn")
		## game over scene

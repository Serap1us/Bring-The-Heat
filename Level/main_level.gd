extends Node2D
class_name MainLevel

@export var curr_score := 0 : set = _set_score
@onready var score_label = $Control/Score
@onready var asp: AudioStreamPlayer = $music
@onready var flame_scene = "res://Game Components/Interact Area/flame.tscn"

# game music
var volume = -15

func _ready() -> void:
	$CustomerSpawner.counterPositions = $Tables.get_children() as Array[Marker2D]
	$CustomerSpawner.spawnPosition = $SpawnPoint.position
	
	# Music
	AudioServer.set_bus_volume_db(0, volume)
	asp.play()

func _set_score(new_score):
	var prev_score := curr_score
	curr_score = new_score
	$CustomerSpawner.changeDifficulty(get_difficulty())
	score_label.text = "Score: " + str(curr_score)
	
	var number = Label.new()
	number.z_index = 5
	number.position.x = ((score_label.size.x - 131) / 2) + 117
	number.text = str(new_score - prev_score)
	number.label_settings = LabelSettings.new()
	
	number.label_settings.font_size = 16
	number.label_settings.outline_color = "#000"
	number.label_settings.outline_size = 1
	
	score_label.call_deferred("add_child", number)
	
	await number.resized
	number.pivot_offset = Vector2(number.size / 2)
	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(
		number, "position:y", number.position.y + 24, 0.25
	).set_ease(Tween.EASE_OUT)
	tween.tween_property(
		number, "scale", Vector2.ZERO, 0.25
	).set_ease(Tween.EASE_IN).set_delay(0.20)
	await tween.finished
	number.queue_free()


func get_difficulty() -> float:
	var steepness := 0.000075

	var difficulty := 1.0 + curr_score * steepness
	return difficulty

## Pause menu
#@onready var pause_menu = $PauseMenu
#var paused = false
#
#
#func _process(delta):
	#if Input.is_action_just_pressed("pause"):
		#pauseMenu()
		#
#func pauseMenu():
	#if paused:
		#pause_menu.hide()
		#Engine.time_scale = 1
		##get_tree().paused = false
	#else:
		#pause_menu.show()
		#Engine.time_scale = 0
		##get_tree().paused = true
		#
		#
	#paused = !paused
	
func _on_audio_stream_player_finished() -> void:
	asp.play()

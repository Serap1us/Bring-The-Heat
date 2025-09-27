extends Control
class_name PatienceBar

@onready var progressBar: ProgressBar = $ProgressBar
## @onready var moodIcon: (maybe add a mood if time)

### textures for diff moods
## happy
## neutral
## angry

# Colors for the different patience levels
@export var highPatienceColor: Color = Color.GREEN
@export var medPatienceColor: Color = Color.YELLOW
@export var lowPatienceColor: Color = Color.RED

var maxValue := 15
 
# Make it jump when its getting critically low
var isCritical: bool = false

func _ready():
	$ProgressBar.max_value = maxValue
	$ProgressBar.value = maxValue
	## Test animation
	#if OS.has_feature("editor"):  # Only run test in editor
		#_test_bar_animation()
#
#func _test_bar_animation():
	#updatePatience(100, 100) # Start full (green)
	#
	## Create a tween to smoothly reduce patience
	#var tween = create_tween()
	#tween.tween_method(
		#func(current_value): updatePatience(current_value, 100.0),
		#100.0,  # from
		#0.0,    # to
		#5.0     # duration
	#)
	##tween.set_loops()  # Loop forever for testing
	
func updatePatience(current: float):
	if !progressBar:
		return
	
	progressBar.max_value = maxValue
	progressBar.value = max(current, 0)
	
	# calc the ratio
	var ratio = current / maxValue
	
	# update the colors
	if ratio > 0.66:
		progressBar.modulate = highPatienceColor
		isCritical = false
	elif ratio > 0.33:
		progressBar.modulate = medPatienceColor
		isCritical = false
	else:
		progressBar.modulate = lowPatienceColor
		isCritical = ratio < 0.15
		
	# add these particles later when time
	#if ratio < 0.2  and !has_node("AngerParticles"):
		#var particles = angerParticles.instantiate()
		#add_child(particles)

func _process(_delta):
	# pulse effect when its critical
	if isCritical:
		var pulse = abs(sin(Time.get_ticks_msec() / 200.0))
		modulate.a = 0.5 + pulse * 0.5
	else:
		modulate.a = 1.0
	

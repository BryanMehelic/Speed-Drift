extends CanvasLayer

# Reference to your Label node
@onready var label: Label = $Label

# Variable to track elapsed time in seconds
var time_elapsed: float = 0.0
var timer_running: bool = false

func _process(delta: float) -> void:
	if timer_running:
		time_elapsed += delta
		label.text = _format_time(time_elapsed)

# Starts the speed trial timer 
func start_trial() -> void:
	time_elapsed = 0.0
	timer_running = true

#may want a pause_trial() func for multiple stages

# Stops the speed trial timer
func stop_trial() -> String: #change so returns and got rid of time time: float arg
	timer_running = false
	return _format_time(time_elapsed) #lets see
	
	
# Formats the time into MM:SS.MS (Minutes : Seconds . Milliseconds)
func _format_time(time: float) -> String:
	var minutes: int = time / 60
	var seconds: int = fmod(time, 60)
	var milliseconds: int = fmod(time, 1) * 100
	
	return "%02d:%02d.%02d" % [minutes, seconds, milliseconds]

extends Node
@onready var character_body_2d: CharacterBody2D = $"."
@onready var start_sound: AudioStreamPlayer = $"../start_sound"
@onready var select_sound: AudioStreamPlayer = $"../select_sound"
@onready var label_1: Label = $lvl1/Control/Label_1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



	#at area2d for lvl, want ui to pop up w/picture of map, fastest time, shift to play, play audio
	

#curr_speed and 2000 are not relative to this overworld car.
#engine.volume_db = lerp(-10.0, 0.0, clamp(curr_speed / 2000, 0.0, 1.0)) #clamp is a limiter. 0 is min, 1 is max, prob wanna change
#engine.pitch_scale = lerp(0.7, 1.5, clamp(curr_speed / 2000, 0.0, 1.0))	

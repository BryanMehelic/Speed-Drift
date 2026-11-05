extends Control
@onready var start_sound: AudioStreamPlayer = $start_sound
@onready var fade: CanvasLayer = $Fade
@onready var select_sound: AudioStreamPlayer = $select_sound


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("drift"):
		start_sound.play()
		select_sound.play()
		await fade._fade(1.0, 1.0).finished #works because tween can use .finished
		get_tree().change_scene_to_file("res://world.tscn") #change to overworld

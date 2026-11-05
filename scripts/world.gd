extends Node2D
@onready var start_sound: AudioStreamPlayer = $start_sound
@onready var select_sound: AudioStreamPlayer = $select_sound
@onready var fade: CanvasLayer = $Fade
@onready var levels: Area2D = $levels
#maybe want vars to store best times of lvls


var scene_names = []




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for lvl in levels.get_children(): 
		scene_names.append(lvl.scene.resource_path.get_file().get_basename()) #ordered array of scene names
		lvl.change_scene.connect(_change_scene.bind(lvl.scene))
		

func _change_scene(scene):
		start_sound.play()
		select_sound.play()
		await fade._fade(1.0, 1.0).finished #works because tween can use .finished
		get_tree().change_scene_to_packed(scene) #use change_scene_to_packed instead

#if time i wanna make a track, add some coins, on ready set speed... all that track stuff... add settings

extends Node2D
@onready var canvas_layer: CanvasLayer = $"CanvasLayer"
@onready var node_2d: CharacterBody2D = $"Node2D" #just renamed all  char node to node2d cuz lazy
@onready var music: AudioStreamPlayer = $music
@onready var coin_sfx: AudioStreamPlayer = $coin_sfx
var index
@onready var label: Label = $Node2D/Label

@onready var fade: CanvasLayer = $Fade
var coin_count = 0 #as long as I reset coin count to 0 every level seems fine.
var scene_path
var scene_name



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scene_name = get_scene_file_path().get_file().get_basename()
	match scene_name:
		"track-1":
			index = 0
		"track_2":
			index = 1
		"track_3":
			index = 2
	_setup_level_one() #want main screen. on level select, do lvl select start which invoves countdown?...
	


func _setup_level_one() -> void: #this should be in a track-1 script
	get_tree().paused = true #get_tree().paused may not be needed. may be nice if i start driving during fade in but test and see.
	fade.color_rect.modulate.a = 1.0
	await fade._fade(0.0, 1.0).finished
	get_tree().paused = false
	var coins = $"coins" 
	coin_count = coins.get_child_count()
	for coin in coins.get_children():
		coin.collected.connect(_coin_collected) #connects func to coin so it runs once per coin and attaches to coin.
	node_2d.start_timer.connect(_start_timer) #will this work?

func _start_timer() -> void:
	canvas_layer.start_trial() # timer

func _coin_collected() -> void:
	coin_count -= 1
	coin_sfx.pitch_scale = randf_range(0.99, 1.12)
	coin_sfx.play()
	node_2d.max_speed += 100 #arbitrary num
	print(node_2d.max_speed)
	if coin_count <= 0:
		var time = canvas_layer.stop_trial() #returns string
		var game_time = _parse_time_string(time)
		var curr_score = _parse_time_string(ScoreManager.level_scores[index])
		if game_time < curr_score:
			ScoreManager.level_scores[index] = time
			ScoreManager.save_scores()
		set_process_unhandled_input(true)
		label.visible = true
	else:
		set_process_unhandled_input(false)
		#bookmarked web storage api. stores on local web browser of specific pc
		
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("space"):
		await fade._fade(1.0, 1.0).finished #works because tween can use .finished
		get_tree().change_scene_to_file("res://world.tscn") #change to overworld
		
func _parse_time_string(time_str: String) -> float:

	var parts := time_str.split(":")
	if parts.size() != 2:
		return 0.0
		
	var minutes := parts[0].to_int()
	
	var second_parts := parts[1].split(".")
	if second_parts.size() != 2:
		return 0.0
		
	var seconds := second_parts[0].to_int()
	var milliseconds := second_parts[1].to_int()
	
	var total_seconds: float = (minutes * 60) + seconds + (milliseconds / 100.0)
	return total_seconds

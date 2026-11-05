extends Area2D

@export var scene: PackedScene #packedscene so goated
var scene_name


@onready var label: Label = $Label
@onready var start_sound: AudioStreamPlayer = $start_sound
@onready var select_sound: AudioStreamPlayer = $select_sound
@onready var fade: CanvasLayer = $Fade
signal change_scene
var in_body = false
var index

func _ready() -> void:
	scene_name = scene.resource_path.get_file().get_basename()
	match scene_name:
		"track-1":
			index = 0
		"track_2":
			index = 1
		"track_3":
			index = 2

	label.text = "Space to play\nBest time: %s" % ScoreManager.level_scores[index]
	
	body_entered.connect(_entered_body)
	body_exited.connect(_exited_body) #idk why func _on_body_entered and _exited don't work
	label.visible = false
	

func _entered_body(body: Node2D) -> void: 
	in_body = true
	if body.name == "CharacterBody2D": 
		label.visible = true
			

func _exited_body(body: Node2D) -> void:
	in_body = false
	if body.name == "CharacterBody2D":
		label.visible = false

func _process(delta: float) -> void:
	if Input.is_action_pressed("space") && in_body == true:
		change_scene.emit()

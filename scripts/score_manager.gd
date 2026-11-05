extends Node

var lvl1_score: String = "99:99.99"
var lvl2_score: String = "99:99.99"
var lvl3_score: String = "99:99.99"
var level_scores: Array[String] = [lvl1_score, lvl2_score, lvl3_score]

const SAVE_FILE := "user://save_game.json"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_scores()




func load_scores():
	if not FileAccess.file_exists(SAVE_FILE):
		return

	var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
	var json = JSON.parse_string(file.get_as_text())
	if json != null:
		var loaded_scores = json["level_scores"]
		for i in range(min(level_scores.size(), loaded_scores.size())):
			level_scores[i] = str(loaded_scores[i])
		
		
		
func save_scores():
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	if file:
		var data = {
			"level_scores": level_scores
		}
		file.store_string(JSON.stringify(data))

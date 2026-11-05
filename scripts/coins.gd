extends Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
signal collected 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite_2d.play("default")
	body_entered.connect(_entered_body)

#ADD COIN SFX

func _entered_body(body: Node2D) -> void:
	if body.name == "Node2D": 
		emit_signal("collected") #having audio play in track-1 where signal is received avoids hassle w/queue_free() but downside is messiness
		queue_free()

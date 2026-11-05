extends CanvasLayer
@onready var color_rect: ColorRect = $ColorRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS #works in pause tho pause may be unneccessary now
	color_rect.modulate.a = 0.0
	
func _fade(target_alpha: float, duration: float = 1.0): #default 1 sec if no arg given.
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", target_alpha, duration)
	return tween

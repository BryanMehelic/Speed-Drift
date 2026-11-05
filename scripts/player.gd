extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var engine: AudioStreamPlayer2D = $engine
@onready var drift_1: AudioStreamPlayer2D = $drift_1
@onready var drift_2: AudioStreamPlayer2D = $drift_2
@onready var boost: AudioStreamPlayer2D = $boost
@onready var hit_wall: AudioStreamPlayer2D = $hit_wall
@onready var label: Label = $Label



@export var low_speed: float = 500.0
@export var med_speed: float = 700.0
@export var max_speed: float = 900.0
@export var low_turn_speed: float = 1.2
@export var turn_speed: float = 2.0
@export var low_acc_rate: float = 1.05
@export var med_acc_rate: float = 1.03
@export var max_acc_rate: float = 1.01
@export var deceleration_rate: float = 0.7
@export var reg_traction = 20.0
@export var drift_traction = 2.0
@export var drift_direction = 0.0
var brake_factor: float = 1
var drift = 1
var curr_speed: float = base_speed
var base_speed: float = 50.0
var min_speed: float = 0.0
var w_pressed = false
var velocity_direction: Vector2 = Vector2.ZERO
signal start_timer
var start_move = false

	
func _physics_process(delta: float) -> void:
	var turn_direction: float = 0.0
	if start_move == false && Input.is_action_pressed("forward"): #changed from just pressed to pressed for hold w in transition fix (hope)
		start_timer.emit() #using custom signal
		start_move = true
				
	var traction = reg_traction
	if Input.is_action_just_pressed("drift"):
		drift_1.play()
	if Input.is_action_pressed("drift"): 
		traction = drift_traction
		if drift_direction == 0: 
			if Input.is_action_pressed("left"):
				drift_direction = -1
				animated_sprite_2d.play("drift_left") #just realized mario kart drift is analog...
			elif Input.is_action_pressed("right"):
				drift_direction = 1
				animated_sprite_2d.play("drift_right")
				
		if drift_direction == -1:
			turn_direction = -1.2
			if Input.is_action_just_pressed("right"):
				drift_2.play()
				animated_sprite_2d.play("drift_right") 
			if Input.is_action_pressed("right"):
				turn_direction = -0.5 #COUNTER STEER
		elif drift_direction == 1:
			turn_direction = 1.2
			if Input.is_action_just_pressed("left"):
				drift_2.play()
				animated_sprite_2d.play("drift_left") 
			if Input.is_action_pressed("left"):
				turn_direction = 0.5 #COUNTER STEER
	else:	
	#turning. want turn direction to have max
		if drift_direction != 0:
			drift_direction = 0
			curr_speed += 50 #speed boost after drift. want more extreme prob or visual
			animated_sprite_2d.play("speed_boost")
			boost.play()
		if Input.is_action_pressed("left"):
			turn_direction = -1.0
		if Input.is_action_pressed("right"):
			turn_direction = 1.0
	if curr_speed > 0:
		if curr_speed < med_speed:
			rotation += turn_direction * low_turn_speed * delta
		else:
			rotation += turn_direction * turn_speed * delta #+ or -1 * 2 * delta
		
	#w key to go forward
	if Input.is_action_pressed("forward"):
		#animated_sprite_2d.animation = "taxi-move"
		w_pressed = true
		velocity_direction = velocity_direction.lerp(transform.x, traction * delta).normalized()
		if curr_speed < base_speed:
			curr_speed = base_speed
		if curr_speed < low_speed:
			curr_speed *= low_acc_rate 
		elif curr_speed < med_speed:
			curr_speed *= med_acc_rate
		elif curr_speed < max_speed:
			curr_speed *= max_acc_rate
		elif curr_speed > max_speed:
			curr_speed *= deceleration_rate
	if w_pressed == true:
		if not Input.is_action_pressed("forward"):
			#engine.volume_db = -10
			#engine.pitch_scale = 0.5
			velocity_direction = velocity_direction.lerp(transform.x, traction * delta).normalized()
			if curr_speed > min_speed:
				if Input.is_action_pressed("brake"):
					brake_factor = 0.98
				else:
					brake_factor = 1.0
				curr_speed *= deceleration_rate * brake_factor
				if curr_speed < base_speed:
					curr_speed = 0
					#animated_sprite_2d.animation = "taxi"
		velocity = velocity_direction * curr_speed
		
	engine.volume_db = lerp(-15.0, -10.0, clamp(curr_speed / 2000, 0.0, 1.0)) #clamp is a limiter. 0 is min, 1 is max, prob wanna change
	engine.pitch_scale = lerp(0.7, 1.5, clamp(curr_speed / 2000, 0.0, 1.0))	#just say 2000 to be safe. would need 10 coins in lvl to be 2k

	
	if get_slide_collision_count() > 0:
			var collision = get_slide_collision(0) #idk what this index means...
			hit_wall.play()
			var bounce_direction = velocity_direction.bounce(collision.get_normal()).normalized() #learn... making var cuz i don't want 1.0 i get from normalized
			velocity_direction = velocity_direction.lerp(bounce_direction, 0.5)
			curr_speed *= 0.9
	
		
			
	move_and_slide()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.visible = false
	max_speed = 900
	velocity_direction = Vector2.ZERO
	
	

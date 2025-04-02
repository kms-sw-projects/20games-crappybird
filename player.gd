extends CharacterBody2D

var move_speed=100
var active = false
var is_dead = false
var screen_size 

var current_t = 0

@export var jump_height:float
@export var jump_time_to_peak : float
@export var jump_time_to_descent : float

@onready var jump_velocity : float = -(2.0*jump_height) /jump_time_to_peak
@onready var jump_gravity : float =  -jump_velocity / jump_time_to_peak
@onready var fall_gravity : float = (2.0*jump_height)/(jump_time_to_descent**2)

signal hit_obstacle

func _ready()->void:
	screen_size = get_viewport_rect().size
	
func _physics_process(delta: float) -> void:
	if active:
		velocity.x = 0
		velocity.y += my_get_gravity()*delta
		if Input.is_action_pressed("ui_up"):
			jump()
		if move_and_slide():
			hit_obstacle.emit()
			
		#position += velocity*delta
		
	if !active and !is_dead:
			current_t += delta
			position.y += 0.5*sin(current_t)
			#move_and_slide()
				#hit_obstacle.emit()
	position = position.clamp(Vector2.ZERO, screen_size)
	if is_dead:
		$AnimatedSprite2D.animation="dead"
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.animation="flying"
		$AnimatedSprite2D.play()
			
func my_get_gravity()->float:
	return jump_gravity if velocity.y < 0 else fall_gravity
	
func jump()->void:
	velocity.y = jump_velocity 

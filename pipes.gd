class_name pipes
extends StaticBody2D

var velocity: float = 0
var g_texture_width: float = 0

signal area_exited

func _ready():
	g_texture_width = 100#$pipe.$Sprite2D.texture.get_size().x * scale.x
	$Area2D.body_exited.connect(_on_area_2d_body_exited)
	
func _process(delta: float) -> void:
	position.x += velocity*delta
	if position.x < -300:
		queue_free()

func _on_area_2d_body_exited(_body: Node2D) -> void:
	area_exited.emit()
	$Area2D.body_exited.disconnect(_on_area_2d_body_exited)
	#print("I triggered my signal.")
	
func start_moving()->void:
	velocity = -200
func stop_moving()->void:
	velocity=0

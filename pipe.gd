extends StaticBody2D

const VELOCITY: float = -1.5
var g_texture_width: float = 0

func _ready():
	g_texture_width = $Sprite2D.texture.get_size().x * scale.x
	print(g_texture_width)
	
func _process(_delta: float) -> void:
	position.x += VELOCITY
	_attempt_reposition()
	
func _attempt_reposition() -> void:
	if position.x < -399:#g_texture_width/2:
		# Don't just reset position to texture width, otherwise there will be a gap
		position.x += 2 * g_texture_width

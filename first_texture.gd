extends Sprite2D

var VELOCITY: float = -2
var g_texture_width: float = 0

func _ready():
	g_texture_width =texture.get_size().x * scale.x
	print(g_texture_width)
	
func _process(_delta: float) -> void:
	position.x += VELOCITY
	_attempt_reposition()

func start_moving():
	VELOCITY = -2
	
func stop_moving():
	VELOCITY = 0
	#position.x = 0

func _attempt_reposition() -> void:
	if position.x < -g_texture_width/2:
		# Don't just reset position to texture width, otherwise there will be a gap
		position.x += 2.0*g_texture_width

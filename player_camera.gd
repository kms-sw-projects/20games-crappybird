extends Camera2D

var smooth_zoom = 1
var target_zoom = 1
var smooth_offset = 1
var target_offset = 200

const ZOOM_SPEED = 0.01

func _ready():
	pass

func zoomout(_delta):
		smooth_zoom = lerp(smooth_zoom, target_zoom, ZOOM_SPEED)
		smooth_offset = lerp(smooth_offset, target_offset, ZOOM_SPEED)
		if smooth_zoom != target_zoom:
			set_zoom(Vector2(smooth_zoom, smooth_zoom))
			if smooth_offset != target_offset:
				set_offset(Vector2(smooth_offset,0))

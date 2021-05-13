extends RayCast2D


var last_collider
var selected = false

func _physics_process(_delta):
	global_position = get_global_mouse_position()
	
	if is_colliding():
		selected = true
		last_collider = get_collider()
		last_collider.underline()
	elif selected:
		selected = false
		last_collider.stop_underline()

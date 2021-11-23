extends State

export(float, 0, 100) var ladder_climb_speed : float

func _setup() -> void:
	var root : Actor = persistant_state
	set_meta('gravity', root.gravity_value)
	root.gravity_value = 0
	root.velocity.x = 0
	root.move_and_slide(Vector2.UP, Vector2.UP)

func cleanup() -> void:
	persistant_state.gravity_value = get_meta('gravity')

func physics_main(_delta):
	if (persistant_state.direction.y < 0.0 or persistant_state.direction.x != 0.0) or persistant_state.is_on_floor():
		return persistant_state.STATE_NORMAL
	
	var vdir := Input.get_axis('ui_up', 'ui_down')
	persistant_state.velocity.y = ladder_climb_speed * vdir

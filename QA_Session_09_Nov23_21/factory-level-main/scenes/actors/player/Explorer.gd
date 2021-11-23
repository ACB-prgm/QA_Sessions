tool
extends Actor

enum { STATE_NORMAL, STATE_CLIMB }

var direction := Vector2()

var States : StateMachine

var _in_ladder := false

func _ready() -> void:
	if Engine.editor_hint:
		set_physics_process(false)
		return
	
	NodeMapper.map_nodes(self)
	
	for node in get_tree().get_nodes_in_group('ladders'):
		(node as Area2D).connect('body_entered', self, '_on_ladder_body_entered')
		(node as Area2D).connect('body_exited', self, '_on_ladder_body_exited')
	
	States.change_state(STATE_NORMAL)

func _unhandled_key_input(event: InputEventKey) -> void:
	direction.x = Input.get_axis('ui_left', 'ui_right')
	
	if event.is_action_pressed('jump') and direction.y == 0.0:
		direction.y = -1
		velocity.y = -speed_cap.y
	elif event.is_action_pressed('ui_up') and _in_ladder:
		States.change_state(STATE_CLIMB)

func _physics_process(delta: float) -> void:
	var state_return = States.state_physics(delta)
	if state_return is int:
		state_return = States.change_state(state_return)
		assert(state_return == OK)
	
	var snap_vector := Vector2.UP * 10 if velocity.y > 0 else Vector2()
	velocity = move_and_slide_with_snap(velocity, snap_vector, Vector2.UP, true, 4, 0.785398, true)
	
	if direction.y < 0.0:
		if is_on_floor():
			direction.y = 0

func _on_ladder_body_entered(_node):
	_in_ladder = true

func _on_ladder_body_exited(_node):
	_in_ladder = false
	if States.current_state() == STATE_CLIMB:
		States.change_state(STATE_NORMAL)

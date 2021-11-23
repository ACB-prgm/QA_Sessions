extends RigidBody2D

#signal picked(node)

export(float, 1, 100000, 0.5) var throw_force : float = 1
export(float, 1, 100000, 0.5) var upward_force : float = 1

var picked := false
var picker = null
var set_new_position := false

func _ready() -> void:
	set_physics_process(false)

func _unhandled_key_input(event: InputEventKey) -> void:
	if event.is_action_pressed('action'):
		if picked:
			set_physics_process(false)
			
			mode = MODE_CHARACTER
			var force : float = throw_force * picker.direction.x
			apply_central_impulse(Vector2(force, -upward_force))
			
			picked = false
			picker = null
			get_tree().set_input_as_handled()
		else:
			var bodies : Array = $DetectionField.get_overlapping_bodies()
			for body in bodies:
				if body.name == 'Explorer':
					# Set the item as being picked up
					picked = true
					picker = body
					
					mode = MODE_STATIC
					set_physics_process(true)
					get_tree().set_input_as_handled()

func _physics_process(_delta: float) -> void:
	if picked:
		position = picker.global_position

func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	if set_new_position:
		# Change position
		set_new_position = false
		var xform := state.transform
		xform.origin = get_meta('new_position')
		state.transform = xform
	
#	if picked:
#		# Update position to be synced with player
#		var xform := state.transform
#		xform.origin = picker.global_position
#		print(xform.origin)
#		state.transform = xform
#	elif set_new_position:
#		# Change position
#		set_new_position = false
#		var xform := state.transform
#		xform.origin = get_meta('new_position')
#		state.transform = xform

func set_rigid_position(pos: Vector2):
	set_new_position = true
	set_meta('new_position', pos)

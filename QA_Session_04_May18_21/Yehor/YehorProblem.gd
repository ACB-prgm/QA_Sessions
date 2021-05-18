extends KinematicBody2D

const GRAVITY = 100
const WALK_FORCE = 100
const STOP_FORCE = 1300

var WALK_MAX_SPEED = 1000
var JUMP_SPEED = 2001
var velocity = Vector2()
var input_vector : Vector2
var on_ground : bool
 

func _physics_process(delta):
	movement()


func movement():
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if input_vector != Vector2.ZERO:
		velocity += input_vector * WALK_FORCE
		velocity.x = clamp(velocity.x, -WALK_MAX_SPEED, WALK_MAX_SPEED)
	else:
		velocity.x = move_toward(velocity.x, 0, WALK_FORCE)

	var on_ground = is_on_floor()
	if !on_ground:
		velocity.y += GRAVITY
		velocity.y = clamp(velocity.y, -JUMP_SPEED, JUMP_SPEED)
		
	if on_ground:
		velocity.y = clamp(velocity.y, 5, 5)
		if Input.is_action_just_pressed("ui_up"):  # JUMP
			velocity.y = -JUMP_SPEED
			velocity.x += WALK_MAX_SPEED * input_vector.x

# warning-ignore:return_value_discarded
	move_and_slide(velocity, Vector2.UP)

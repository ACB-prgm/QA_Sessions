extends KinematicBody2D


const MAX_VEL = 1000
const ACCELERATION = 100
const MAX_POINTS = 40

var input_vector = Vector2.ZERO
var velocity = Vector2.ZERO
var points := []


func _ready():
	Globals.player = self


func _physics_process(_delta):
	movement()
	create_points()


func movement():
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity += input_vector * ACCELERATION
		velocity = velocity.clamped(MAX_VEL)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, ACCELERATION)

# warning-ignore:return_value_discarded
	move_and_slide(velocity)

func create_points():	
	points.append(global_position)
	
	if points.size() > MAX_POINTS:
		points.pop_front()

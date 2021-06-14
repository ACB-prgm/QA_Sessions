extends KinematicBody2D


const MAX_VEL = 1000
const ACCELERATION = 100

var input_vector = Vector2.ZERO
var velocity = Vector2.ZERO

enum {
	IDLE,
	MOVE
}
var state = MOVE


func _ready():
	Globals.player = self


func _physics_process(_delta):
	match state:
		IDLE:
			idle()
		MOVE:
			movement()
	
#	print(state)


func movement():
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity += input_vector * ACCELERATION
		velocity = velocity.clamped(MAX_VEL)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, ACCELERATION)
		
		if velocity == Vector2.ZERO:
			state = IDLE

	move_and_slide(velocity)


func idle():
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		state = MOVE

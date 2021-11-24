extends KinematicBody2D


const FOLLOW_DISTANCE = 200
const MAX_POINTS = 50
const MIN_POINTS = 20
const MAX_VEL = 1000
const ACCELERATION = 100

export var bake_interval = 60

var input_vector = Vector2.ZERO
var velocity = Vector2.ZERO
var last_point = Vector2.ZERO

onready var points = []


func _ready():
	Globals.player = self


func _physics_process(_delta):
	movement()


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
	
	adjust_path(velocity)
	move_and_slide(velocity)

func adjust_path(vel):
	var num_points = points.size()
	if vel != Vector2.ZERO:
		last_point = global_position
		points.append(last_point)
		if num_points > MAX_POINTS:
			points.remove(0)
	elif num_points > MIN_POINTS:
		points.remove(0)



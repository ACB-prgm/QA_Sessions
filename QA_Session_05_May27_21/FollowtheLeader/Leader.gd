extends KinematicBody2D


const MAX_VEL = 1000
const ACCELERATION = 100
const MAX_curve = 60

var input_vector = Vector2.ZERO
var velocity = Vector2.ZERO
onready var start_pos = global_position
onready var curve = $Path2D.curve
onready var line = $Line2D


func _ready():
	
	Globals.player = self


func _physics_process(_delta):
	line.global_position = start_pos
	line.points = curve.get_baked_points()
	movement()


func movement():
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity += input_vector * ACCELERATION
		velocity = velocity.clamped(MAX_VEL)
		create_curve()
	else:
		velocity = velocity.move_toward(Vector2.ZERO, ACCELERATION)

# warning-ignore:return_value_discarded
	move_and_slide(velocity)

func create_curve():
#	prints(curve.get_baked_points().size(), curve.get_point_count())
	curve.add_point(global_position)
	
	if curve.get_point_count() > MAX_curve:
		curve.remove_point(0)

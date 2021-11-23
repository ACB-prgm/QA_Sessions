extends Sprite


const MAX_VEL = 30
const ACCELERATION = 10

var input_vector = Vector2.ZERO
var velocity = Vector2.ZERO


var particles = preload("res://QA_Sessions/QA_Session_09_Nov23_21/particles/Particles2D.tscn")


func _ready():
	yield(get_tree().create_timer(0.3), "timeout")
	
	var part_inms = particles.instance()
	part_inms.global_position = position
	add_child(part_inms)


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
	
	global_translate(velocity)
